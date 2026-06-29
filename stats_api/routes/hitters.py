from flask import Blueprint, jsonify, request, send_file
import pybaseball as pb
import numpy as np
from datetime import datetime
from io import BytesIO
import matplotlib
matplotlib.use('Agg')
from routes import savant_sources

# Set up Blueprint for player_route
hitter_route = Blueprint('hitter_route', __name__)

def replace_nan_with_none(data):
    if isinstance(data, list):
        return [replace_nan_with_none(item) for item in data]
    elif isinstance(data, dict):
        return {key: replace_nan_with_none(value) for key, value in data.items()}
    elif isinstance(data, float) and np.isnan(data):
        return None
    else:
        return data

@hitter_route.route('/')
def home():
    return jsonify( {'message': 'Hitter API'} )

"""Get hitter stats for this current season, if season hasn't started yet then the last
season will be used. The stats will be returned for the player with the given playerid 
from the query parameters. The playerid from fangraphs and baseball reference is required 
to get the stats for the player.

Return: 
    JSON: The hitter stats for the current season
Throws:
    Exception: If an error occurs while getting player stats or playerids is not given
"""

@hitter_route.route('/api/hitter-stats/current-season')
def get_hitter_stats_this_season():
    try:
        # Get hitter id from query parameters and most recent year from pybaseball
        key_fangraphs = request.args.get('fg-id')
        key_mlbam = request.args.get('mlbam-id')
        current_year = pb.utils.most_recent_season()

        # Check if key_fangraphs and another if key_mlbam is given or convert to int
        if not key_fangraphs:
            return jsonify({'error': 'Fangraph ID required'}), 400
        else:
            key_fangraphs = int(key_fangraphs)

        if not key_mlbam:
            return jsonify({'error': 'Savant ID required'}), 400
        else:
            key_mlbam = int(key_mlbam)

        # FanGraphs (pb.batting_stats) is Cloudflare-blocked; built from bbref + Savant + bWAR.
        # See routes/savant_sources.py and .claude/plans/Park_Factor_Data_Architecture_1.0.md.
        record = savant_sources.hitter_season(key_mlbam)
        if not record:
            return jsonify({'hitter_stats': None})
        return jsonify({'hitter_stats': replace_nan_with_none(record)})
    except Exception as e:
        return jsonify({'hitter_stats': None})
    
"""Get hitter stats for this current season if they don't have a Fangraphs ID, if season hasn't started yet then the last
season will be used. The stats will be returned for the player with the given playerid 
from the query parameters. The playerid from fangraphs and baseball reference is required 
to get the stats for the player.

Return: 
    JSON: The hitter stats for the current season
Throws:
    Exception: If an error occurs while getting player stats or playerids is not given
"""

@hitter_route.route('/api/hitter-stats/current-season-preview')
def get_hitter_stats_this_season_preview():
    try:
        # Get hitter id from query parameters and most recent year from pybaseball
        key_mlbam = request.args.get('mlbam-id')
        current_year = pb.utils.most_recent_season()

        if not key_mlbam:
            return jsonify({'error': 'Savant ID required'}), 400
        else:
            key_mlbam = int(key_mlbam)
        
        # Get BBREF batting stats for the current season and filter by playerid
        bbref_hitter_data = pb.batting_stats_bref(current_year);
        bbref_hitter_record = bbref_hitter_data[bbref_hitter_data['mlbID'] == key_mlbam].to_dict('records')

        if not bbref_hitter_record:
            return jsonify({'hitter_preview_stats': None})

        bbref_hitter_record = replace_nan_with_none(bbref_hitter_record)        

        return jsonify({'hitter_preview_stats': bbref_hitter_record})
    except Exception as e:
        return jsonify({'hitter_preview_stats': None})

"""Get stats for a hitter for their career. The stats will be returned for the player with the given playerid
and start year and last (previous) year of their career. The playerid from fangraphs is required to get the 
stats.

Return: 
    JSON: The hitter stats for their career
Throws:
    Exception: If an error occurs while getting player stats or playerid, start year or end year is not given
"""

@hitter_route.route('/api/hitter-stats/career')
def get_hitter_stats_career():
    try:
        # Get hitter id from query parameters
        key_fangraphs = request.args.get('fg-id')
        start_year = request.args.get('start-year')
        end_year = request.args.get('end-year')
        
        # Check if key_fangraphs is given or convert to int
        if not key_fangraphs:
            return jsonify({'error': 'Fangraph ID required'}), 400
        else:
            key_fangraphs = int(key_fangraphs)

        # Ensure start_year and end_year are present
        if not start_year or not end_year:
            return jsonify({'error': 'Start year and end year are required'}), 400

        # Get Fangraphs batting stats for the current season and filter by playerid
        fg_hitter_data = pb.batting_stats(start_year, end_year, qual=1, ind=0);
        fg_hitter_record = fg_hitter_data[fg_hitter_data['IDfg'] == key_fangraphs].to_dict('records')
        
        if not fg_hitter_record:
            return jsonify({'hitting_career_stats': None})

        # Select specific attributes to return for batting, sprint speed, oaa stats
        fg_hitter_record_selected_attributes = ['G', 'AVG', 'OBP', 'SLG', 'OPS', 'WAR', 'HR', 'R', 'H', 'RBI', 'SB', 'wOBA', 'EV', 'maxEV', 'Barrel%', 'HardHit%', 'Swing%', 'Z-Swing%', 'Contact%', 'WPA', 'BB%', 'K%', 'BB/K', 'BsR', 'CS', 'wSB', 'ISO', 'BABIP', 'wRC+']
        fg_selected_attribute_record = [
            {attr: hitter[attr] for attr in fg_hitter_record_selected_attributes if attr in hitter}
            for hitter in fg_hitter_record
        ]

        fg_selected_attribute_record = replace_nan_with_none(fg_selected_attribute_record)
        

        return jsonify({'hitting_career_stats': fg_selected_attribute_record})
    except Exception as e:
        return jsonify({'hitting_career_stats': None})
    

@hitter_route.route('/api/hitter-stats/percentiles')
def get_hitter_percentiles():
    try:
        key_mlbam = request.args.get('mlbam-id')
        if not key_mlbam:
            return jsonify({'error': 'Savant ID required'}), 400
        else:
            key_mlbam = int(key_mlbam)
        current_year = pb.utils.most_recent_season()
        statcast_percentiles_data = pb.statcast_batter_percentile_ranks(current_year)
        statcast_percentiles_record = statcast_percentiles_data[statcast_percentiles_data['player_id'] == key_mlbam].to_dict('records')

        if not statcast_percentiles_record:
            return jsonify({'hitter_percentile': None})
        
        # Replace NaN values with None
        statcast_percentiles_record = replace_nan_with_none(statcast_percentiles_record)
        
        return jsonify({"hitter_percentile": statcast_percentiles_record})
    except Exception as e:
        return jsonify({"hitter_percentile": None})
    
@hitter_route.route('/api/hitter-stats/leaderboard')
def get_hitter_leaderboard():
    # FanGraphs (pb.batting_stats) is Cloudflare-blocked; built from bbref + Savant instead.
    # See routes/savant_sources.py and .claude/plans/Park_Factor_Data_Architecture_1.0.md.
    try:
        return jsonify(savant_sources.hitter_leaderboard())
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@hitter_route.route('/api/hitter-stats/spraychart')
def get_hitter_spraychart():
    try:
        key_mlbam = request.args.get('mlbam-id')
        team = request.args.get('team')
        if not key_mlbam:
            return jsonify({'error': 'Savant ID required'}), 400
        else:
            key_mlbam = int(key_mlbam)
        
        # Grab date of earliest month of games starting
        current_year = pb.utils.most_recent_season()
        start_date = f'{current_year}-03-01'
        # Get today's date in YYYY-MM-DD format
        end_date = datetime.now().strftime('%Y-%m-%d')
        statcast_spraychart_data = pb.statcast_batter(start_date, end_date, key_mlbam)
        sub_data = statcast_spraychart_data[statcast_spraychart_data['home_team'] == team]
        sub_data = sub_data[sub_data['events'].notna()]
        sub_data = sub_data[sub_data['events'].str.contains('single|double|triple|home_run')]

        team_stadium = ""
        # Get the team stadium
        if team == "LAA":
            team_stadium = "angels"
        elif team == "HOU":
            team_stadium = "astros"
        elif team == "ATH":
            team_stadium = "athletics"
        elif team == "TOR":
            team_stadium = "blue_jays"
        elif team == "ATL":
            team_stadium = "braves"
        elif team == "MIL":
            team_stadium = "brewers"
        elif team == "STL":
            team_stadium = "cardinals"
        elif team == "CHC":
            team_stadium = "cubs"
        elif team == "ARI":
            team_stadium = "diamondbacks"
        elif team == "LAD":
            team_stadium = "dodgers"
        elif team == "SFG":  
            team_stadium = "giants"
        elif team == "CLE":
            team_stadium = "indians"  
        elif team == "SEA":
            team_stadium = "mariners"
        elif team == "MIA":
            team_stadium = "marlins"
        elif team == "NYM":
            team_stadium = "mets"
        elif team == "WSN":
            team_stadium = "nationals"
        elif team == "BAL":
            team_stadium = "orioles"
        elif team == "SD":
            team_stadium = "padres"
        elif team == "PHI":
            team_stadium = "phillies"
        elif team == "PIT":
            team_stadium = "pirates"
        elif team == "TEX":
            team_stadium = "rangers"
        elif team == "TBR":
            team_stadium = "rays"
        elif team == "BOS":
            team_stadium = "red_sox"
        elif team == "CIN":
            team_stadium = "reds"
        elif team == "COL":
            team_stadium = "rockies"
        elif team == "KC":
            team_stadium = "royals"
        elif team == "DET":
            team_stadium = "tigers"
        elif team == "MIN":
            team_stadium = "twins"
        elif team == "CHW":
            team_stadium = "white_sox"
        elif team == "NYY":
            team_stadium = "yankees"
        else:
            team_stadium = "generic"
        
        spray_chart = pb.spraychart(sub_data, team_stadium)
        
        # Save the plot to a BytesIO object
        figure = spray_chart.get_figure()
        buf = BytesIO()
        figure.savefig(buf, format="png")
        buf.seek(0) 

        return send_file(buf, mimetype='image/png')
    except Exception as e:
        return jsonify({'error': str(e)}), 500