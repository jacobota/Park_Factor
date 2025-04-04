from flask import Blueprint, jsonify, request
import pybaseball as pb
import numpy as np

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
        
        # Get Fangraphs batting stats for the current season and filter by playerid
        fg_hitter_data = pb.batting_stats(current_year, qual=1);
        fg_hitter_record = fg_hitter_data[fg_hitter_data['IDfg'] == key_fangraphs].to_dict('records')
        
        # Get Fangraphs fielding stats for the current season and filter by playerid
        fg_fielding_data = pb.fielding_stats(current_year, qual=1);
        fg_fielding_record = fg_fielding_data[fg_fielding_data['IDfg'] == key_fangraphs].to_dict('records')

        # Get statcast data for sprint speed
        statcast_sprint_speed_data = pb.statcast_sprint_speed(current_year)  
        statcast_sprint_speed_record = statcast_sprint_speed_data[statcast_sprint_speed_data['player_id'] == key_mlbam].to_dict('records')      

         # Select specific attributes to return for batting, sprint speed, fielding stats
        fg_hitter_record_selected_attributes = ['G', 'AVG', 'OBP', 'SLG', 'OPS', 'WAR', 'HR', 'R', 'H', 'RBI', 'SB', 'wOBA', 'xwOBA', 'xBA', 'xSLG', 'EV', 'maxEV', 'Barrel%', 'HardHit%', 'Swing%', 'Z-Swing%', 'Contact%', 'WPA', 'BB%', 'K%', 'BB/K', 'BsR', 'CS', 'wSB', 'ISO', 'BABIP', 'wRC+']
        fg_selected_attribute_record = [
            {attr: hitter[attr] for attr in fg_hitter_record_selected_attributes if attr in hitter}
            for hitter in fg_hitter_record
        ]

        fg_fielding_record_selected_attributes = ['FP', 'E', 'DRS', 'OAA', 'UZR']
        fg_fielding_record = [
            {attr: fielding[attr] for attr in fg_fielding_record_selected_attributes if attr in fielding}
            for fielding in fg_fielding_record
        ]

        statcast_sprint_speed_selected_attributes = ['sprint_speed']
        statcast_sprint_speed_record = [
            {attr: sprint_speed[attr] for attr in statcast_sprint_speed_selected_attributes if attr in sprint_speed}
            for sprint_speed in statcast_sprint_speed_record
        ]

        #combine all stats into one
        hitter_stats = {}
        if fg_selected_attribute_record:
            hitter_stats.update(fg_selected_attribute_record[0])
        if statcast_sprint_speed_record:
            hitter_stats.update(statcast_sprint_speed_record[0])
        if fg_fielding_record:
            hitter_stats.update(fg_fielding_record[0])

        hitter_stats = replace_nan_with_none(hitter_stats)        

        return jsonify({'hitter_stats': hitter_stats})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

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
            return jsonify({'career_stats': None})

         # Select specific attributes to return for batting, sprint speed, oaa stats
        fg_hitter_record_selected_attributes = ['G', 'AVG', 'OBP', 'SLG', 'OPS', 'WAR', 'HR', 'R', 'H', 'RBI', 'SB', 'wOBA', 'EV', 'maxEV', 'Barrel%', 'HardHit%', 'Swing%', 'Z-Swing%', 'Contact%', 'WPA', 'BB%', 'K%', 'BB/K', 'BsR', 'CS', 'wSB', 'ISO', 'BABIP']
        fg_selected_attribute_record = [
            {attr: hitter[attr] for attr in fg_hitter_record_selected_attributes if attr in hitter}
            for hitter in fg_hitter_record
        ]

        fg_selected_attribute_record = replace_nan_with_none(fg_selected_attribute_record)

        return jsonify({'career_stats': fg_selected_attribute_record})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    

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
        
        # Replace NaN values with None
        statcast_percentiles_record = replace_nan_with_none(statcast_percentiles_record)
        
        return jsonify({"percentile": statcast_percentiles_record})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@hitter_route.route('/api/hitter-stats/leaderboard')
def get_hitter_leaderboard():
    try:
        current_year = pb.utils.most_recent_season()
        statcast_leaderboard = pb.batting_stats(current_year)
        # Define the stats the leaderboard will present
        leaderboard_stats = ['AVG', 'OBP', 'SLG', 'OPS', 'WAR', 'HR', 'R', 'H', 'RBI', 'SB', 'xwOBA', 'EV', 'Barrel%', 'BB%', 'K%', 'BsR', 'wRC+']
        leaderboard_records = statcast_leaderboard.to_dict('records')

        # Replace NaN values with None
        leaderboard_records = replace_nan_with_none(leaderboard_records)

        top_5_per_stat = {}
        for stat in leaderboard_stats:
            # If the stat is K%, we want the lowest values
            if stat == 'K%':
                top_5_per_stat[stat] = [
                    {
                        "Team": hitter["Team"],
                        "Name": hitter["Name"],
                        stat: hitter[stat]
                    }
                    for hitter in sorted(
                        # Run a lambda function to sort each record of players by stat, take bottom 5
                        (record for record in leaderboard_records if stat in record and record[stat] is not None),
                        key=lambda x: x[stat]
                    )[:5]
                ]
            else:
                # Sort the stat and take the top 5 for the remaining stats
                top_5_per_stat[stat] = [
                    {
                        "Team": hitter["Team"],
                        "Name": hitter["Name"],
                        stat: hitter[stat]
                    }
                    for hitter in sorted(
                        # Run a lambda function to sort each record of players by stat, take top 5
                        (record for record in leaderboard_records if stat in record and record[stat] is not None),
                        key=lambda x: x[stat],
                        reverse=True
                    )[:5]
                ]
        
        return jsonify(top_5_per_stat)
    except Exception as e:
        return jsonify({'error': str(e)}), 500