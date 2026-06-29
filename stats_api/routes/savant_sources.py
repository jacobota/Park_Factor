"""
Savant + Baseball-Reference leaderboard sources.

FanGraphs (pybaseball's `batting_stats` / `pitching_stats` / `team_batting` / `team_pitching`)
now sits behind a Cloudflare JS challenge and returns 403, so those functions are unusable.
This module rebuilds the leaderboards from sources that are NOT blocked:

  * Baseball-Reference  (`batting_stats_bref` / `pitching_stats_bref`) — standard counting/rate stats
  * Baseball Savant     (`statcast_*_exitvelo_barrels`)                 — Statcast EV / Barrel%

FanGraphs-proprietary metrics (wRC+, WAR, FIP, SIERA, Stuff+, BsR, vFA) have no equivalent here
and are simply omitted; the app renders only the stat keys that are present.

Output shape matches the old FanGraphs routes exactly:
    { "<stat>": [ { "Team": str, "Name": str, "<stat>": number }, ... up to 5 ] }
"""

import time
import math
import requests
import numpy as np
import pybaseball as pb
from datetime import datetime

# --- team identity --------------------------------------------------------------------------
# The app keys team logos/colors/navigation off the FanGraphs abbreviation (see mobile teams.ts).
# bbref uses ambiguous city names (two "Los Angeles") but carries league in `Lev`, so we
# disambiguate by (city, league). The MLB Stats API (team leaderboards) maps by numeric id.

_BBREF_CITY_LEAGUE_TO_FG = {
    ('Arizona', 'NL'): 'ARI', ('Athletics', 'AL'): 'ATH', ('Atlanta', 'NL'): 'ATL',
    ('Baltimore', 'AL'): 'BAL', ('Boston', 'AL'): 'BOS', ('Chicago', 'AL'): 'CHW',
    ('Chicago', 'NL'): 'CHC', ('Cincinnati', 'NL'): 'CIN', ('Cleveland', 'AL'): 'CLE',
    ('Colorado', 'NL'): 'COL', ('Detroit', 'AL'): 'DET', ('Houston', 'AL'): 'HOU',
    ('Kansas City', 'AL'): 'KCR', ('Los Angeles', 'AL'): 'LAA', ('Los Angeles', 'NL'): 'LAD',
    ('Miami', 'NL'): 'MIA', ('Milwaukee', 'NL'): 'MIL', ('Minnesota', 'AL'): 'MIN',
    ('New York', 'AL'): 'NYY', ('New York', 'NL'): 'NYM', ('Philadelphia', 'NL'): 'PHI',
    ('Pittsburgh', 'NL'): 'PIT', ('San Diego', 'NL'): 'SDP', ('San Francisco', 'NL'): 'SFG',
    ('Seattle', 'AL'): 'SEA', ('St. Louis', 'NL'): 'STL', ('Tampa Bay', 'AL'): 'TBR',
    ('Texas', 'AL'): 'TEX', ('Toronto', 'AL'): 'TOR', ('Washington', 'NL'): 'WSN',
}

_MLB_ID_TO_FG = {
    109: 'ARI', 133: 'ATH', 144: 'ATL', 110: 'BAL', 111: 'BOS', 112: 'CHC', 145: 'CHW',
    113: 'CIN', 114: 'CLE', 115: 'COL', 116: 'DET', 117: 'HOU', 118: 'KCR', 108: 'LAA',
    119: 'LAD', 146: 'MIA', 158: 'MIL', 142: 'MIN', 121: 'NYM', 147: 'NYY', 143: 'PHI',
    134: 'PIT', 135: 'SDP', 137: 'SFG', 136: 'SEA', 138: 'STL', 139: 'TBR', 140: 'TEX',
    141: 'TOR', 120: 'WSN',
}


def _bbref_team_fg(tm, lev):
    """Map a bbref (Tm, Lev) pair to a FanGraphs abbr. Returns None for multi-team stint rows."""
    if not tm or ',' in str(tm):
        return None
    league = 'AL' if 'AL' in str(lev) else ('NL' if 'NL' in str(lev) else None)
    return _BBREF_CITY_LEAGUE_TO_FG.get((str(tm), league))

# --- tiny in-process cache (the bbref / savant pulls take a few seconds each) ----------------

_CACHE = {}
_TTL_SECONDS = 30 * 60


def _cached(key, producer):
    now = time.time()
    hit = _CACHE.get(key)
    if hit and now - hit[0] < _TTL_SECONDS:
        return hit[1]
    value = producer()
    _CACHE[key] = (now, value)
    return value


# --- helpers --------------------------------------------------------------------------------

def _num(v):
    """Coerce to float, treating NaN / blanks as None."""
    if v is None:
        return None
    try:
        f = float(v)
    except (TypeError, ValueError):
        return None
    return None if math.isnan(f) else f


def _pct(v):
    """Savant percentages come as e.g. 12.3; scale to the 0.123 fraction the UI formats at 3dp."""
    f = _num(v)
    return f / 100 if f is not None else None


def _fix_encoding(s):
    """bbref name fields arrive with UTF-8 bytes mangled into literal escapes
    (e.g. 'Jos\\xc3\\xa9 Suarez'). Re-decode them to real text ('José Suarez')."""
    if not isinstance(s, str) or '\\x' not in s:
        return s
    try:
        return s.encode('latin-1').decode('unicode_escape').encode('latin-1').decode('utf-8')
    except (UnicodeDecodeError, UnicodeEncodeError):
        return s


def _mlbam(v):
    """Coerce a bbref mlbID to an int MLBAM key, or None if blank/NaN."""
    if v in (None, ''):
        return None
    try:
        f = float(v)
        return None if math.isnan(f) else int(f)
    except (TypeError, ValueError):
        return None


def _ip_to_outs(ip):
    """Baseball-Reference IP is e.g. 75.1 = 75 + 1/3 innings. Convert to integer outs."""
    f = _num(ip)
    if f is None:
        return 0
    whole = int(f)
    frac = round((f - whole) * 10)  # .1 -> 1 out, .2 -> 2 outs
    return whole * 3 + frac


def _build_top5(records, stats, ascending, key_fields):
    """Generic top-5-per-stat builder. `ascending` is the set of stats where lower is better."""
    out = {}
    for stat in stats:
        rows = [r for r in records if r.get(stat) is not None]
        rows.sort(key=lambda r: r[stat], reverse=stat not in ascending)
        out[stat] = [
            {**{k: r.get(k) for k in key_fields}, stat: r[stat]}
            for r in rows[:5]
        ]
    return out


def _most_recent_season_with_data(loader):
    """Try the most-recent season; if the frame is empty (very early in a new year) fall back."""
    year = pb.utils.most_recent_season()
    df = loader(year)
    if df is None or len(df) == 0:
        year -= 1
        df = loader(year)
    return year, df


# --- raw frame loaders (cached) -------------------------------------------------------------

def _bbref_batting():
    def load():
        _, df = _most_recent_season_with_data(lambda y: pb.batting_stats_bref(y))
        if 'Lev' in df.columns:
            # bbref labels MLB rows 'Maj-AL' / 'Maj-NL' (and 'Maj-AL,Maj-NL' for traded players).
            df = df[df['Lev'].astype(str).str.contains('Maj', na=False)]
        if 'Name' in df.columns:
            df = df.copy()
            df['Name'] = df['Name'].map(_fix_encoding)
        return df
    return _cached('bbref_bat', load)


def _bbref_pitching():
    def load():
        _, df = _most_recent_season_with_data(lambda y: pb.pitching_stats_bref(y))
        if 'Lev' in df.columns:
            # bbref labels MLB rows 'Maj-AL' / 'Maj-NL' (and 'Maj-AL,Maj-NL' for traded players).
            df = df[df['Lev'].astype(str).str.contains('Maj', na=False)]
        if 'Name' in df.columns:
            df = df.copy()
            df['Name'] = df['Name'].map(_fix_encoding)
        return df
    return _cached('bbref_pit', load)


def _savant_batter_ev():
    def load():
        year = pb.utils.most_recent_season()
        try:
            df = pb.statcast_batter_exitvelo_barrels(year)
        except Exception:
            df = pb.statcast_batter_exitvelo_barrels(year - 1)
        return {int(r['player_id']): r for r in df.to_dict('records') if r.get('player_id') is not None}
    return _cached('savant_bat_ev', load)


def _savant_pitcher_ev():
    def load():
        year = pb.utils.most_recent_season()
        try:
            df = pb.statcast_pitcher_exitvelo_barrels(year)
        except Exception:
            df = pb.statcast_pitcher_exitvelo_barrels(year - 1)
        return {int(r['player_id']): r for r in df.to_dict('records') if r.get('player_id') is not None}
    return _cached('savant_pit_ev', load)


def _savant_batter_xstats():
    """Expected stats (xwOBA via est_woba) keyed by MLBAM id."""
    def load():
        year = pb.utils.most_recent_season()
        try:
            df = pb.statcast_batter_expected_stats(year)
        except Exception:
            df = pb.statcast_batter_expected_stats(year - 1)
        return {int(r['player_id']): r for r in df.to_dict('records') if r.get('player_id') is not None}
    return _cached('savant_bat_x', load)


def _savant_pitcher_xstats():
    """Expected stats (xERA, est_woba allowed) keyed by MLBAM id."""
    def load():
        year = pb.utils.most_recent_season()
        try:
            df = pb.statcast_pitcher_expected_stats(year)
        except Exception:
            df = pb.statcast_pitcher_expected_stats(year - 1)
        return {int(r['player_id']): r for r in df.to_dict('records') if r.get('player_id') is not None}
    return _cached('savant_pit_x', load)


def _savant_positions():
    """Primary fielding position (e.g. SS, CF) keyed by MLBAM id, from the OAA leaderboard."""
    def load():
        year = pb.utils.most_recent_season()
        try:
            df = pb.statcast_outs_above_average(year, 'all')
        except Exception:
            df = pb.statcast_outs_above_average(year - 1, 'all')
        return {int(r['player_id']): r.get('primary_pos_formatted')
                for r in df.to_dict('records') if r.get('player_id') is not None}
    return _cached('savant_pos', load)


def _mlb_team_stats(group):
    """Official per-team season aggregates from the MLB Stats API (unblocked, exact, proper ids)."""
    def load():
        year = pb.utils.most_recent_season()
        url = (f'https://statsapi.mlb.com/api/v1/teams/stats'
               f'?stats=season&group={group}&season={year}&sportIds=1')
        splits = requests.get(url, timeout=20).json()['stats'][0]['splits']
        return splits
    return _cached(f'mlb_team_{group}', load)


# --- public leaderboard builders ------------------------------------------------------------

def hitter_leaderboard():
    bat = _bbref_batting()
    team_games = int(_num(bat['G'].max()) or 0) if len(bat) else 0
    qual_pa = 3.1 * team_games  # standard batting-title qualifier
    ev_map = _savant_batter_ev()
    x_map = _savant_batter_xstats()
    pos_map = _savant_positions()

    records = []
    for r in bat.to_dict('records'):
        pa, ab = _num(r.get('PA')) or 0, _num(r.get('AB')) or 0
        bb, so = _num(r.get('BB')) or 0, _num(r.get('SO')) or 0
        bmlbid = _mlbam(r.get('mlbID'))
        rec = {
            'Team': _bbref_team_fg(r.get('Tm'), r.get('Lev')), 'Name': r.get('Name'),
            'Pos': (pos_map.get(bmlbid) if bmlbid else None) or 'DH',
            'H': _num(r.get('H')), 'HR': _num(r.get('HR')), 'R': _num(r.get('R')),
            'RBI': _num(r.get('RBI')), 'SB': _num(r.get('SB')),
        }
        if pa >= qual_pa and pa > 0:  # rate stats only for qualified hitters
            rec['AVG'] = _num(r.get('BA'))
            rec['OBP'] = _num(r.get('OBP'))
            rec['SLG'] = _num(r.get('SLG'))
            rec['OPS'] = _num(r.get('OPS'))
            rec['BB%'] = bb / pa
            rec['K%'] = so / pa
        sv = ev_map.get(bmlbid) if bmlbid else None
        if sv:
            rec['EV'] = _num(sv.get('avg_hit_speed'))
            rec['Barrel%'] = _pct(sv.get('brl_percent'))      # Statcast advanced
            rec['HardHit%'] = _pct(sv.get('ev95percent'))     # Statcast advanced
        xs = x_map.get(bmlbid) if bmlbid else None
        if xs:
            rec['xwOBA'] = _num(xs.get('est_woba'))           # Statcast advanced
        records.append(rec)

    # Advanced metrics lead (per plan: Stats tab leans hard into advanced), traditional follow.
    stats = ['xwOBA', 'Barrel%', 'HardHit%', 'EV', 'K%', 'BB%',
             'AVG', 'OBP', 'SLG', 'OPS', 'H', 'HR', 'R', 'RBI', 'SB']
    return _build_top5(records, stats, ascending={'K%'}, key_fields=['Team', 'Name', 'Pos'])


def pitcher_leaderboard():
    pit = _bbref_pitching()
    team_games = int(_num(_bbref_batting()['G'].max()) or 0) if len(_bbref_batting()) else 0
    qual_ip = 1.0 * team_games  # standard ERA-title qualifier (1 IP per team game)
    ev_map = _savant_pitcher_ev()
    x_map = _savant_pitcher_xstats()

    records = []
    for r in pit.to_dict('records'):
        ip = _num(r.get('IP')) or 0
        bf, ab = _num(r.get('BF')) or 0, _num(r.get('AB')) or 0
        bb, so, h = _num(r.get('BB')) or 0, _num(r.get('SO')) or 0, _num(r.get('H')) or 0
        gs, sv_ct = _num(r.get('GS')) or 0, _num(r.get('SV')) or 0
        pos = 'SP' if gs > 0 else ('CL' if sv_ct >= 10 else 'RP')  # role from starts/saves
        rec = {
            'Team': _bbref_team_fg(r.get('Tm'), r.get('Lev')), 'Name': r.get('Name'), 'Pos': pos,
            'W': _num(r.get('W')), 'L': _num(r.get('L')), 'SV': _num(r.get('SV')),
            'SO': _num(r.get('SO')), 'BB': _num(r.get('BB')), 'H': _num(r.get('H')),
            'R': _num(r.get('R')), 'HR': _num(r.get('HR')), 'IP': ip,
        }
        if ip >= qual_ip and ip > 0:  # rate stats only for qualified pitchers
            rec['ERA'] = _num(r.get('ERA'))
            rec['WHIP'] = _num(r.get('WHIP'))
            rec['AVG'] = (h / ab) if ab > 0 else None
            if bf > 0:
                rec['K%'] = so / bf
                rec['BB%'] = bb / bf
        mlbid = _mlbam(r.get('mlbID'))
        sv = ev_map.get(mlbid) if mlbid else None
        if sv:
            rec['EV'] = _num(sv.get('avg_hit_speed'))
            rec['Barrel%'] = _pct(sv.get('brl_percent'))   # contact quality allowed (advanced)
        xs = x_map.get(mlbid) if mlbid else None
        if xs:
            rec['xERA'] = _num(xs.get('xera'))             # Statcast advanced
        records.append(rec)

    # Advanced metrics lead, traditional follow.
    stats = ['xERA', 'K%', 'BB%', 'Barrel%', 'EV', 'ERA', 'WHIP', 'AVG', 'IP',
             'SO', 'W', 'L', 'SV', 'BB', 'H', 'R', 'HR']
    ascending = {'xERA', 'AVG', 'ERA', 'WHIP', 'BB%', 'Barrel%', 'BB', 'H', 'R', 'HR', 'EV'}
    return _build_top5(records, stats, ascending=ascending, key_fields=['Team', 'Name', 'Pos'])


def team_hitting_leaderboard():
    records = []
    for split in _mlb_team_stats('hitting'):
        fg = _MLB_ID_TO_FG.get(split['team']['id'])
        if not fg:
            continue
        s = split['stat']
        pa = _num(s.get('plateAppearances')) or 0
        records.append({
            'Team': fg,
            'AVG': _num(s.get('avg')), 'OBP': _num(s.get('obp')),
            'SLG': _num(s.get('slg')), 'OPS': _num(s.get('ops')),
            'H': _num(s.get('hits')), 'HR': _num(s.get('homeRuns')), 'R': _num(s.get('runs')),
            'RBI': _num(s.get('rbi')), 'SB': _num(s.get('stolenBases')),
            'BB%': (_num(s.get('baseOnBalls')) or 0) / pa if pa else None,
            'K%': (_num(s.get('strikeOuts')) or 0) / pa if pa else None,
        })
    stats = ['K%', 'BB%', 'OPS', 'OBP', 'SLG', 'AVG', 'H', 'HR', 'R', 'RBI', 'SB']
    return _build_top5(records, stats, ascending={'K%'}, key_fields=['Team'])


def team_pitching_leaderboard():
    records = []
    for split in _mlb_team_stats('pitching'):
        fg = _MLB_ID_TO_FG.get(split['team']['id'])
        if not fg:
            continue
        s = split['stat']
        bf = _num(s.get('battersFaced')) or 0
        records.append({
            'Team': fg,
            'ERA': _num(s.get('era')), 'WHIP': _num(s.get('whip')), 'AVG': _num(s.get('avg')),
            'SO': _num(s.get('strikeOuts')), 'BB': _num(s.get('baseOnBalls')),
            'H': _num(s.get('hits')), 'R': _num(s.get('runs')), 'HR': _num(s.get('homeRuns')),
            'SV': _num(s.get('saves')), 'W': _num(s.get('wins')), 'L': _num(s.get('losses')),
            'K%': (_num(s.get('strikeOuts')) or 0) / bf if bf else None,
            'BB%': (_num(s.get('baseOnBalls')) or 0) / bf if bf else None,
        })
    stats = ['ERA', 'WHIP', 'K%', 'BB%', 'AVG', 'SO', 'W', 'L', 'SV', 'BB', 'H', 'R', 'HR']
    ascending = {'ERA', 'WHIP', 'AVG', 'BB%', 'BB', 'H', 'R', 'HR', 'L'}
    return _build_top5(records, stats, ascending=ascending, key_fields=['Team'])


# === player-page sources (single-player season lines + bio) =================================
# Rebuilds the FanGraphs-blocked season-stat endpoints from bbref + Savant + bWAR + computed
# metrics, keyed by MLBAM id. FIP is computed; xERA/Barrel%/EV come from Savant. Stuff+/Command
# have no free source, so the frontend uses labeled Savant proxies (velo / walk-rate percentiles).

_FIP_CONSTANT = 3.10  # league-ish FIP constant; good enough without the FanGraphs yearly value


def _bbref_row_map(loader, cache_key):
    """Build {mlbam_id: record} from a cached bbref frame for single-player lookups."""
    def build():
        rows = {}
        for r in loader().to_dict('records'):
            mid = _mlbam(r.get('mlbID'))
            if mid is not None and mid not in rows:  # first stint row wins
                rows[mid] = r
        return rows
    return _cached(cache_key, build)


def _bwar_map(loader, cache_key):
    """{mlbam_id: total WAR} for the current season (summed across stints)."""
    def build():
        year = pb.utils.most_recent_season()
        df = loader(return_all=True)
        df = df[df['year_ID'] == year]
        out = {}
        for r in df.to_dict('records'):
            mid = _mlbam(r.get('mlb_ID'))
            if mid is None:
                continue
            out[mid] = out.get(mid, 0.0) + (_num(r.get('WAR')) or 0.0)
        return out
    return _cached(cache_key, build)


def player_bio(mlbam):
    """Header/bio from the MLB Stats API people endpoint (number, B/T, height, weight, born, age)."""
    def load():
        p = requests.get(f'https://statsapi.mlb.com/api/v1/people/{mlbam}', timeout=15).json()['people'][0]
        region = p.get('birthStateProvince') or p.get('birthCountry')
        born = ', '.join(x for x in (p.get('birthCity'), region) if x)
        return {
            'fullName': p.get('fullName'),
            'number': p.get('primaryNumber'),
            'position': (p.get('primaryPosition') or {}).get('abbreviation'),
            'bats': (p.get('batSide') or {}).get('code'),
            'throws': (p.get('pitchHand') or {}).get('code'),
            'height': p.get('height'),
            'weight': p.get('weight'),
            'born': born or None,
            'age': p.get('currentAge'),
        }
    return _cached(f'bio_{mlbam}', load)


def pitcher_season(mlbam):
    row = _bbref_row_map(_bbref_pitching, 'bbref_pit_map').get(mlbam)
    if not row:
        return None
    ip = _ip_to_outs(row.get('IP')) / 3
    bf = _num(row.get('BF')) or 0
    so, bb, hbp = _num(row.get('SO')) or 0, _num(row.get('BB')) or 0, _num(row.get('HBP')) or 0
    hr = _num(row.get('HR')) or 0
    out = {
        'Team': _bbref_team_fg(row.get('Tm'), row.get('Lev')),
        'G': _num(row.get('G')), 'GS': _num(row.get('GS')), 'SV': _num(row.get('SV')),
        'W': _num(row.get('W')), 'L': _num(row.get('L')), 'IP': _num(row.get('IP')),
        'SO': so, 'BB': bb, 'HR': hr, 'ERA': _num(row.get('ERA')), 'WHIP': _num(row.get('WHIP')),
        'K%': (so / bf) if bf else None,
        'BB%': (bb / bf) if bf else None,
        'K-BB%': ((so - bb) / bf) if bf else None,
        'HR/9': (hr * 9 / ip) if ip else None,
        'FIP': ((13 * hr + 3 * (bb + hbp) - 2 * so) / ip + _FIP_CONSTANT) if ip else None,
        'WAR': _bwar_map(pb.bwar_pitch, 'bwar_pit').get(mlbam),
    }
    xs = _savant_pitcher_xstats().get(mlbam)
    if xs:
        out['xERA'] = _num(xs.get('xera'))
    ev = _savant_pitcher_ev().get(mlbam)
    if ev:
        out['EV'] = _num(ev.get('avg_hit_speed'))
        out['Barrel%'] = _pct(ev.get('brl_percent'))
    return out


def hitter_season(mlbam):
    row = _bbref_row_map(_bbref_batting, 'bbref_bat_map').get(mlbam)
    if not row:
        return None
    pa, ab = _num(row.get('PA')) or 0, _num(row.get('AB')) or 0
    bb, so = _num(row.get('BB')) or 0, _num(row.get('SO')) or 0
    avg, slg = _num(row.get('BA')), _num(row.get('SLG'))
    h, hr = _num(row.get('H')) or 0, _num(row.get('HR')) or 0
    babip_den = ab - so - hr + (_num(row.get('SF')) or 0)
    out = {
        'Team': _bbref_team_fg(row.get('Tm'), row.get('Lev')),
        'G': _num(row.get('G')), 'PA': pa, 'AB': ab,
        'H': h, 'HR': hr, 'R': _num(row.get('R')), 'RBI': _num(row.get('RBI')), 'SB': _num(row.get('SB')),
        'AVG': avg, 'OBP': _num(row.get('OBP')), 'SLG': slg, 'OPS': _num(row.get('OPS')),
        'BB%': (bb / pa) if pa else None,
        'K%': (so / pa) if pa else None,
        'ISO': (slg - avg) if (slg is not None and avg is not None) else None,
        'BABIP': ((h - hr) / babip_den) if babip_den > 0 else None,
        'WAR': _bwar_map(pb.bwar_bat, 'bwar_bat').get(mlbam),
    }
    xs = _savant_batter_xstats().get(mlbam)
    if xs:
        out['wOBA'] = _num(xs.get('woba'))
        out['xwOBA'] = _num(xs.get('est_woba'))
        out['xBA'] = _num(xs.get('est_ba'))
        out['xSLG'] = _num(xs.get('est_slg'))
    ev = _savant_batter_ev().get(mlbam)
    if ev:
        out['EV'] = _num(ev.get('avg_hit_speed'))
        out['maxEV'] = _num(ev.get('max_hit_speed'))
        out['Barrel%'] = _pct(ev.get('brl_percent'))
        out['HardHit%'] = _pct(ev.get('ev95percent'))
    return out


def _mean(series):
    v = series.dropna()
    return float(v.mean()) if len(v) else None


def pitcher_arsenal_full(mlbam, start_year=None):
    """Per-pitch-type arsenal from a statcast pull: velo / IVB / HB / extension / spin, usage, and a
    run-value-derived Action+ proxy (100 = league avg, higher = better). `start_year` widens the
    window from a single season (default) back to a career span for the season/career toggle."""
    def load():
        year = pb.utils.most_recent_season()
        sy = start_year if start_year and start_year < year else year
        start, end = f'{sy}-03-01', datetime.now().strftime('%Y-%m-%d')
        try:
            df = pb.statcast_pitcher(start, end, mlbam)
        except Exception:
            return []
        if df is None or len(df) == 0:
            return []
        total = len(df)
        out = []
        for pt, g in df.groupby('pitch_type'):
            n = len(g)
            rv = g['delta_run_exp'].dropna()
            # Run value per 100 pitches; pitcher-favourable events are negative, so invert for a
            # 100-centred "Action+" proxy where higher is better. Scaled to a FotMob-ish ±20 spread.
            rv100 = (rv.sum() / n * 100) if n else 0.0
            out.append({
                'pitch_type': pt,
                'pitch_name': str(g['pitch_name'].iloc[0]) if 'pitch_name' in g.columns and len(g) else pt,
                'usage': n / total,
                'velo': _mean(g['release_speed']),
                'ivb': (_mean(g['pfx_z']) or 0) * 12,    # feet → inches (induced vertical break)
                'hb': (_mean(g['pfx_x']) or 0) * 12,     # feet → inches (horizontal break)
                'ext': _mean(g['release_extension']),
                'spin': _mean(g['release_spin_rate']),
                'action_plus': 100 - rv100 * 10,
                'count': n,
            })
        out.sort(key=lambda x: x['usage'], reverse=True)
        return out
    return _cached(f'arsenal_full_{mlbam}_{start_year or 0}', load)
