from flask import Blueprint, jsonify, request
import pybaseball as pb
import numpy as np
from datetime import datetime
from routes import savant_sources
from store import read as store_read

# Set up Blueprint for pitcher_route
pitcher_route = Blueprint('pitcher_route', __name__)

def replace_nan_with_none(data):
    if isinstance(data, list):
        return [replace_nan_with_none(item) for item in data]
    elif isinstance(data, dict):
        return {key: replace_nan_with_none(value) for key, value in data.items()}
    elif isinstance(data, float) and np.isnan(data):
        return None
    else:
        return data

@pitcher_route.route('/')
def home():
    return jsonify( {'message': 'Pitcher API'} )

"""Get pitcher stats for the current season. Using their Fangraphs ID, this data will retrieve
basic and advanced stats for the specified pitcher for the current season.

Return: 
    JSON: The pitcher's stats for the current season
Throws:
    Exception: If an error occurs while getting pitcher stats or if the ID is not provided
"""

@pitcher_route.route('/api/pitcher-stats/current-season')
def get_pitcher_stats_this_season():
    try:
        # Get pitcher id from query parameters and most recent year from pybaseball
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

        # FanGraphs (pb.pitching_stats) is Cloudflare-blocked; built from bbref + Savant + bWAR.
        # See routes/savant_sources.py and .claude/plans/Park_Factor_Data_Architecture_1.0.md.
        record = savant_sources.pitcher_season(key_mlbam)
        if not record:
            return jsonify({'pitcher_stats': None})
        return jsonify({'pitcher_stats': [replace_nan_with_none(record)]})
    except Exception as e:
        return jsonify({'pitcher_stats': None})
    
"""Get pitcher stats for the current season if no fg id. Using their MLB ID, this data will retrieve
basic and advanced stats for the specified pitcher for the current season.

Return: 
    JSON: The pitcher's stats for the current season
Throws:
    Exception: If an error occurs while getting pitcher stats or if the ID is not provided
"""

@pitcher_route.route('/api/pitcher-stats/current-season-preview')
def get_pitcher_stats_this_season_preview():
    try:
        # Get pitcher id from query parameters and most recent year from pybaseball
        key_mlbam = request.args.get('mlbam-id')
        current_year = pb.utils.most_recent_season()

        # Check if key_mlbam is given or convert to int
        if not key_mlbam:
            return jsonify({'error': 'Savant ID required'}), 400
        
        # Get BBREF pitching stats for the current season and filter by playerid (store-first).
        bbref_pitcher_data = store_read.season_frame('bbref_pitching', current_year)
        if bbref_pitcher_data is None or len(bbref_pitcher_data) == 0:
            bbref_pitcher_data = pb.pitching_stats_bref(current_year)
        bbref_pitcher_record = bbref_pitcher_data[bbref_pitcher_data['mlbID'] == key_mlbam].to_dict('records')

        if not bbref_pitcher_record:
            return jsonify({'pitcher_preview_stats': None})

        bbref_pitcher_record = replace_nan_with_none(bbref_pitcher_record)
        
        return jsonify({'pitcher_preview_stats': bbref_pitcher_record})
    except Exception as e:
        return jsonify({'pitcher_preview_stats': None})

"""Gets a pitcher's career totals. FanGraphs career lines (pb.pitching_stats) are Cloudflare-blocked,
so this is built from the MLB Stats API career hydrate + career bWAR (FIP computed), keyed by MLBAM
id. See routes/savant_sources.py.

Return:
    JSON: The pitcher's career totals (single aggregate row)
Throws:
    Exception: If an error occurs while getting pitcher stats or if the id is not provided
"""

@pitcher_route.route('/api/pitcher-stats/career')
def get_pitcher_stats_career():
    try:
        key_mlbam = request.args.get('mlbam-id')
        if not key_mlbam:
            return jsonify({'error': 'Savant ID required'}), 400
        key_mlbam = int(key_mlbam)

        record = savant_sources.pitcher_career(key_mlbam)
        if not record:
            return jsonify({'pitching_career_stats': None})
        return jsonify({'pitching_career_stats': [replace_nan_with_none(record)]})
    except Exception as e:
        return jsonify({'pitching_career_stats': None})
    
@pitcher_route.route('/api/pitcher-stats/arsenal')
def get_pitcher_arsenal():
    try:
        # Get mlbam key to filter a player
        key_mlbam = request.args.get('mlbam-id')
        current_year = pb.utils.most_recent_season()

        if not key_mlbam:
            return jsonify({'error': 'Savant ID required'}), 400
        else:
            key_mlbam = int(key_mlbam)

        # Per-pitch movement leaderboard for the season (store-first, live fallback).
        pitcher_arsenal_data = store_read.season_frame('savant_pitch_movement', current_year)
        if pitcher_arsenal_data is None or len(pitcher_arsenal_data) == 0:
            pitcher_arsenal_data = pb.statcast_pitcher_pitch_movement(current_year, minP=1, pitch_type="ALL")
        pitcher_arsenal_record = pitcher_arsenal_data[pitcher_arsenal_data["pitcher_id"] == key_mlbam].to_dict('records')

        pitcher_arsenal_selected_attributes = ['avg_speed', 'diff_x', 'diff_y', 'league_break_x', 'league_break_y', 'pitch_hand', 'pitch_per', 'pitch_type', 'pitch_type_name', 'pitcher_break_z_induced', 'pitches_thrown']
        pitcher_arsenal_record = [
            {attr: pitcher[attr] for attr in pitcher_arsenal_selected_attributes if attr in pitcher}
            for pitcher in pitcher_arsenal_record
        ]

        if not pitcher_arsenal_record:
            return jsonify({'pitcher_arsenal': None})


        pitcher_arsenal_record = replace_nan_with_none(pitcher_arsenal_record)

        return jsonify({'pitcher_arsenal':pitcher_arsenal_record})
    except Exception as e:
        return jsonify({'pitcher_arsenal': None})
    
@pitcher_route.route('/api/pitcher-stats/arsenal-full')
def get_pitcher_arsenal_full():
    # Per-pitch-type arsenal (velo/IVB/HB/ext/spin/usage + run-value Action+ proxy) built from a
    # single season Statcast event pull. See routes/savant_sources.py.
    try:
        key_mlbam = request.args.get('mlbam-id')
        if not key_mlbam:
            return jsonify({'error': 'Savant ID required'}), 400
        start_year = request.args.get('start-year')
        start_year = int(start_year) if start_year else None
        record = savant_sources.pitcher_arsenal_full(int(key_mlbam), start_year)
        return jsonify({'pitcher_arsenal_full': replace_nan_with_none(record)})
    except Exception as e:
        return jsonify({'pitcher_arsenal_full': None})


@pitcher_route.route('/api/pitcher-stats/percentiles')
def get_pitcher_percentiles():
    try:
        key_mlbam = request.args.get('mlbam-id')
        if not key_mlbam:
            return jsonify({'error': 'Savant ID required'}), 400
        else:
            key_mlbam = int(key_mlbam)
        current_year = pb.utils.most_recent_season()
        statcast_percentiles_data = store_read.season_frame('savant_pitcher_percentiles', current_year)
        if statcast_percentiles_data is None or len(statcast_percentiles_data) == 0:
            statcast_percentiles_data = pb.statcast_pitcher_percentile_ranks(current_year)
        statcast_percentiles_record = statcast_percentiles_data[statcast_percentiles_data['player_id'] == key_mlbam].to_dict('records')

        if not statcast_percentiles_record:
            return jsonify({'pitcher_percentile': None})
        
        # Replace NaN values with None
        statcast_percentiles_record = replace_nan_with_none(statcast_percentiles_record)
        
        return jsonify({"pitcher_percentile": statcast_percentiles_record})
    except Exception as e:
        return jsonify({"pitcher_percentile": None})
    
@pitcher_route.route('/api/pitcher-stats/leaderboard')
def get_pitcher_leaderboard():
    # FanGraphs (pb.pitching_stats) is Cloudflare-blocked; built from bbref + Savant instead.
    # See routes/savant_sources.py and .claude/plans/Park_Factor_Data_Architecture_1.0.md.
    try:
        return jsonify(savant_sources.pitcher_leaderboard())
    except Exception as e:
        return jsonify({'error': str(e)}), 500