from flask import Blueprint, jsonify, request
import pybaseball as pb
import numpy as np

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
        
        # Get Fangraphs pitching stats for the current season and filter by playerid
        fg_pitcher_data = pb.pitching_stats(current_year, qual=1);
        fg_pitcher_record = fg_pitcher_data[fg_pitcher_data['IDfg'] == key_fangraphs].to_dict('records')
        
        if not fg_pitcher_record:
            return jsonify({'pitcher_stats': None})

        # Select specific attributes to return for pitching, sprint speed, oaa stats
        fg_pitcher_record_selected_attributes = ['Team', 'G', 'GS', 'CG', 'SV', 'W', 'L', 'ERA', 'IP', 'SO', 'BB', 'WHIP', 'WAR', 'Stuff+', 'Location+', 'Pitching+', 'xERA', 'SIERA', 'FIP', 'xFIP', 'K%', 'BB%', 'K-BB%', 'GB%', 'EV', 'HardHit%', 'Barrel%', 'BABIP', 'Stf+ CH', 'Stf+ CU', 'Stf+ FA', 'Stf+ FC', 'Stf+ FO', 'Stf+ FS', 'Stf+ KC', 'Stf+ SI', 'Stf+ SL', 'Loc+ CH', 'Loc+ CU', 'Loc+ FA', 'Loc+ FC', 'Loc+ FO', 'Loc+ FS', 'Loc+ KC', 'Loc+ SI', 'Loc+ SL', 'Pit+ CH', 'Pit+ CU', 'Pit+ FA', 'Pit+ FC', 'Pit+ FO', 'Pit+ FS', 'Pit+ KC', 'Pit+ SI', 'Pit+ SL', 'CH% (pi)', 'vCH (pi)', 'CU% (pi)', 'vCU (pi)', 'FA% (pi)', 'vFA (pi)', 'FC% (pi)', 'vFC (pi)', 'FO% (pi)', 'vFO (pi)', 'FS% (pi)', 'vFS (pi)', 'KC% (pi)', 'vKC (pi)', 'SI% (pi)', 'vSI (pi)', 'SL% (pi)', 'vSL (pi)', 'O-Swing% (pi)']
        fg_pitcher_record = [
            {attr: pitcher[attr] for attr in fg_pitcher_record_selected_attributes if attr in pitcher}
            for pitcher in fg_pitcher_record
        ]

        fg_pitcher_record = replace_nan_with_none(fg_pitcher_record)
        
        return jsonify({'pitcher_stats': fg_pitcher_record})
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
        
        # Get BBREF pitching stats for the current season and filter by playerid
        bbref_pitcher_data = pb.pitching_stats_bref(current_year)
        bbref_pitcher_record = bbref_pitcher_data[bbref_pitcher_data['mlbID'] == key_mlbam].to_dict('records')

        if not bbref_pitcher_record:
            return jsonify({'pitcher_preview_stats': None})

        bbref_pitcher_record = replace_nan_with_none(bbref_pitcher_record)
        
        return jsonify({'pitcher_preview_stats': bbref_pitcher_record})
    except Exception as e:
        return jsonify({'pitcher_preview_stats': None})

"""Gets the pitchers career stats for a given range of years. This data will retrieve basic and advanced
pitching stats for the specified pitcher.

Return: 
    JSON: The pitcher's career stats for the specified range of years
Throws:
    Exception: If an error occurs while getting pitcher stats or if the ID is not provided
"""
    
@pitcher_route.route('/api/pitcher-stats/career')
def get_pitcher_stats_career():
    try:
        # Get pitcher id and start and end year from query parameters
        key_fangraphs = request.args.get('fg-id')
        start_year = request.args.get('start-year')
        end_year = request.args.get('end-year')

        # Check if key_fangraphs is given convert to int
        if not key_fangraphs:
            return jsonify({'error': 'Fangraph ID required'}), 400
        else:
            key_fangraphs = int(key_fangraphs)

        # Ensure start_year and end_year are present
        if not start_year or not end_year:
            return jsonify({'error': 'Start year and end year are required'}), 400
    
        # Get Fangraphs pitching stats for career and filter by playerid
        fg_pitcher_data = pb.pitching_stats(start_year, end_year, qual=1, ind=0);
        fg_pitcher_record = fg_pitcher_data[fg_pitcher_data['IDfg'] == key_fangraphs].to_dict('records')

        if not fg_pitcher_record:
            return jsonify({'pitching_career_stats': None})
    
        fg_pitcher_record_selected_attributes = ['G', 'GS', 'CG', 'SV', 'W', 'L', 'ERA', 'IP', 'SO', 'BB', 'WHIP', 'WAR', 'Stuff+', 'Location+', 'Pitching+', 'xERA', 'SIERA', 'FIP', 'xFIP', 'K%', 'BB%', 'K-BB%', 'GB%', 'EV', 'HardHit%', 'Barrel%', 'BABIP', 'Stf+ CH', 'Stf+ CU', 'Stf+ FA', 'Stf+ FC', 'Stf+ FO', 'Stf+ FS', 'Stf+ KC', 'Stf+ SI', 'Stf+ SL', 'Loc+ CH', 'Loc+ CU', 'Loc+ FA', 'Loc+ FC', 'Loc+ FO', 'Loc+ FS', 'Loc+ KC', 'Loc+ SI', 'Loc+ SL', 'Pit+ CH', 'Pit+ CU', 'Pit+ FA', 'Pit+ FC', 'Pit+ FO', 'Pit+ FS', 'Pit+ KC', 'Pit+ SI', 'Pit+ SL', 'CH% (pi)', 'vCH (pi)', 'CU% (pi)', 'vCU (pi)', 'FA% (pi)', 'vFA (pi)', 'FC% (pi)', 'vFC (pi)', 'FO% (pi)', 'vFO (pi)', 'FS% (pi)', 'vFS (pi)', 'KC% (pi)', 'vKC (pi)', 'SI% (pi)', 'vSI (pi)', 'SL% (pi)', 'vSL (pi)', 'O-Swing% (pi)']
        fg_pitcher_record = [
            {attr: pitcher[attr] for attr in fg_pitcher_record_selected_attributes if attr in pitcher}
            for pitcher in fg_pitcher_record
        ]

        fg_pitcher_record = replace_nan_with_none(fg_pitcher_record)

        return jsonify({'pitching_career_stats': fg_pitcher_record})
    except Exception as e:
        return jsonify({'pitching_career_stats': None})
    
@pitcher_route.route('/api/pitcher-stats/percentiles')
def get_pitcher_percentiles():
    try:
        key_mlbam = request.args.get('mlbam-id')
        if not key_mlbam:
            return jsonify({'error': 'Savant ID required'}), 400
        else:
            key_mlbam = int(key_mlbam)
        current_year = pb.utils.most_recent_season()
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
    try:
        # Get pitcher id from query parameters and most recent year from pybaseball
        current_year = pb.utils.most_recent_season()
        statcast_leaderboard = pb.pitching_stats(current_year, qual=1)

        # Define the stats the leaderboard will represent
        leaderboard_stats = ['AVG', 'BB', 'R', 'H', 'W', 'L', 'IP', 'HR', 'SV', 'ERA', 'SO', 'WHIP', 'WAR', 'SIERA', 'K%', 'BB%', 'GB%', 'EV', 'vFA (pi)']
        leaderboard_records = statcast_leaderboard.to_dict('records')

        # Replace NaN values with None
        leaderboard_records = replace_nan_with_none(leaderboard_records)

        top_5_per_stat = {}
        for stat in leaderboard_stats:
            # If the stat is K%, we want the lowest values
            if stat == 'AVG' or stat == 'BB' or stat == 'R' or stat == 'H' or stat == 'HR' or stat == 'L' or stat == 'ERA' or stat == 'WHIP' or stat == 'SIERA' or stat == 'BB%' or stat == 'EV':
                top_5_per_stat[stat] = [
                    {
                        "Team": pitcher["Team"],
                        "Name": pitcher["Name"],
                        stat: pitcher[stat]
                    }
                    for pitcher in sorted(
                        # Run a lambda function to sort each record of players by stat, take bottom 5
                        (record for record in leaderboard_records if stat in record and record[stat] is not None),
                        key=lambda x: x[stat]
                    )[:5]
                ]
            else:
                # Sort the stat and take the top 5 for the remaining stats
                top_5_per_stat[stat] = [
                    {
                        "Team": pitcher["Team"],
                        "Name": pitcher["Name"],
                        stat: pitcher[stat]
                    }
                    for pitcher in sorted(
                        # Run a lambda function to sort each record of players by stat, take top 5
                        (record for record in leaderboard_records if stat in record and record[stat] is not None),
                        key=lambda x: x[stat],
                        reverse=True
                    )[:5]
                ]
        
        return jsonify(top_5_per_stat)
    except Exception as e:
        return jsonify({'error': str(e)}), 500