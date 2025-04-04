from flask import Blueprint, jsonify, request
import pybaseball as pb
import numpy as np

# Set up Blueprint for team_route
team_stats_route = Blueprint('team_stats_route', __name__)

def replace_nan_with_none(data):
    if isinstance(data, list):
        return [replace_nan_with_none(item) for item in data]
    elif isinstance(data, dict):
        return {key: replace_nan_with_none(value) for key, value in data.items()}
    elif isinstance(data, float) and np.isnan(data):
        return None
    else:
        return data
    
@team_stats_route.route('/')
def home():
    return jsonify( {'message': 'Team Stats API'} )

@team_stats_route.route('/api/stats/current-season')
def get_team_stats():
    try:
        # Get ID from query parameters
        teamIdfg = request.args.get('team-fg')

        # Make sure teamId is given and convert to int
        if not teamIdfg:
            return jsonify({'error': 'Team ID is required'}), 400
        
        teamIdfg = int(teamIdfg)

        current_year = pb.utils.most_recent_season()

        # Call the team_batting function from pybaseball
        team_batting = pb.team_batting(current_year,league='all', ind=1)
        team_batting_list = team_batting[team_batting['teamIDfg'] == teamIdfg].to_dict('records')

        team_batting_selected_attributes = ['wRC+', 'wOBA', 'HR', 'AVG', 'SLG', 'OPS', 'BB%', 'K%', 'BB/K', 'ISO', 'BABIP', 'SB', 'CS', 'wSB', 'BsR', 'Age', 'WAR']
        team_batting_list = [
            {attr: team_batting[attr] for attr in team_batting_selected_attributes}
            for team_batting in team_batting_list
        ]

        # Call the team_pitching function from pybaseball
        team_pitching = pb.team_pitching(current_year,league='all', ind=1)
        team_pitching_list = team_pitching[team_pitching['teamIDfg'] == teamIdfg].to_dict('records')

        team_pitching_selected_attributes = ['ERA', 'FIP', 'xFIP', 'SIERA', 'BABIP', 'K-BB%', 'K%', 'BB%', 'WHIP', 'GB%', 'HR/FB', 'LOB%', 'Stuff+', 'Location+', 'Pitching+', 'WAR', 'W', 'L', 'RS', 'R', 'vFA (pi)']
        team_pitching_list = [
            {attr: team_pitching[attr] for attr in team_pitching_selected_attributes}
            for team_pitching in team_pitching_list
        ]

        # Call team_fielding function from pybaseball
        team_fielding = pb.team_fielding(current_year, league='all', ind=1)
        team_fielding_list = team_fielding[team_fielding['teamIDfg'] == teamIdfg].to_dict('records')

        team_fielding_selected_attributes = ['DRS', 'OAA', 'UZR', 'E', 'FRM', 'FP']
        team_fielding_list = [
            {attr: team_fielding[attr] for attr in team_fielding_selected_attributes}
            for team_fielding in team_fielding_list
        ]

        return jsonify({'team_batting': team_batting_list, 'team_pitching': team_pitching_list, 'team_fielding': team_fielding_list})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@team_stats_route.route('/api/stats/leaderboard/hitting')
def get_team_hitting_leaderboard():
    try:
        # Get the leaderboard from the current year
        current_year = pb.utils.most_recent_season()
        team_hitting_data = pb.team_batting(current_year, league='all')
        # Define the stats the leaderboard will present
        leaderboard_stats = ['AVG', 'OBP', 'SLG', 'OPS', 'WAR', 'HR', 'R', 'H', 'RBI', 'SB', 'xwOBA', 'EV', 'Barrel%', 'BB%', 'K%', 'BsR', 'wRC+']
        team_hitting_leaderboard_records = team_hitting_data.to_dict('records')

         # Replace NaN values with None
        team_hitting_leaderboard_records = replace_nan_with_none(team_hitting_leaderboard_records)

        top_5_per_stat = {}
        for stat in leaderboard_stats:
            # If the stat is K%, we want the lowest values
            if stat == 'K%':
                top_5_per_stat[stat] = [
                    {
                        "Team": team_hitting["Team"],
                        stat: team_hitting[stat]
                    }
                    for team_hitting in sorted(
                        # Run a lambda function to sort each record of players by stat, take bottom 5
                        (record for record in team_hitting_leaderboard_records if stat in record and record[stat] is not None),
                        key=lambda x: x[stat]
                    )[:5]
                ]
            else:
                # Sort the stat and take the top 5 for the remaining stats
                top_5_per_stat[stat] = [
                    {
                        "Team": team_hitting["Team"],
                        stat: team_hitting[stat]
                    }
                    for team_hitting in sorted(
                        # Run a lambda function to sort each record of players by stat, take top 5
                        (record for record in team_hitting_leaderboard_records if stat in record and record[stat] is not None),
                        key=lambda x: x[stat],
                        reverse=True
                    )[:5]
                ]
        
        return jsonify(top_5_per_stat)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@team_stats_route.route('/api/stats/leaderboard/pitching')
def get_team_pitching_leaderboard():
    try:
        # Get the leaderboard from the current year
        current_year = pb.utils.most_recent_season()
        team_pitching_data = pb.team_pitching(current_year, league='all')
        # Define the stats the leaderboard will present
        leaderboard_stats = ['SV', 'ERA', 'SO', 'WHIP', 'WAR', 'xERA', 'SIERA', 'K%', 'BB%', 'GB%', 'EV', 'vFA (pi)']
        team_pitching_leaderboard_records = team_pitching_data.to_dict('records')

        # Replace NaN values with None
        team_pitching_leaderboard_records = replace_nan_with_none(team_pitching_leaderboard_records)

        top_5_per_stat = {}
        for stat in leaderboard_stats:
            # If the stat is K%, we want the lowest values
            if stat == 'ERA' or stat == 'WHIP' or stat == 'xERA' or stat == 'SIERA' or stat == 'BB%' or stat == 'EV':
                top_5_per_stat[stat] = [
                    {
                        "Team": team_pitching["Team"],
                        stat: team_pitching[stat]
                    }
                    for team_pitching in sorted(
                        # Run a lambda function to sort each record of players by stat, take bottom 5
                        (record for record in team_pitching_leaderboard_records if stat in record and record[stat] is not None),
                        key=lambda x: x[stat]
                    )[:5]
                ]
            else:
                # Sort the stat and take the top 5 for the remaining stats
                top_5_per_stat[stat] = [
                    {
                        "Team": team_pitching["Team"],
                        stat: team_pitching[stat]
                    }
                    for team_pitching in sorted(
                        # Run a lambda function to sort each record of players by stat, take top 5
                        (record for record in team_pitching_leaderboard_records if stat in record and record[stat] is not None),
                        key=lambda x: x[stat],
                        reverse=True
                    )[:5]
                ]
        
        return jsonify(top_5_per_stat)
    except Exception as e:
        return jsonify({'error': str(e)}), 500