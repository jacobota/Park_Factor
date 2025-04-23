from flask import Blueprint, jsonify, request
import pybaseball as pb
import numpy as np

# Set up Blueprint for team_route
team_route = Blueprint('team_route', __name__)

def replace_nan_with_none(data):
    if isinstance(data, list):
        return [replace_nan_with_none(item) for item in data]
    elif isinstance(data, dict):
        return {key: replace_nan_with_none(value) for key, value in data.items()}
    elif isinstance(data, float) and np.isnan(data):
        return None
    else:
        return data
    
@team_route.route('/')
def home():
    return jsonify( {'message': 'Team API'} )

@team_route.route('/api/mlb-teams')
def get_all_mlb_teams():
    try:
        # Call the team_ids function from pybaseball and return all teams and their ids (using 2020 as year to search from)
        teams = pb.team_ids(2020)
        teams_list = teams.to_dict('records')

        # Replace NaN values with None
        teams_list = replace_nan_with_none(teams_list)
        return jsonify(teams_list)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@team_route.route('/api/mlb-team-id')
def get_team_id():
    try:
        # Get team name from query parameters
        team_name = request.args.get('team-name')
        
        # Check if team name is given
        if not team_name:
            return jsonify({'error': 'Team name is required'}), 400
        
        # Call the team_ids function from pybaseball and return the team with the matching team id
        team_id = pb.team_ids(2020)
        team_id = team_id[team_id['teamIDBR'] == team_name].to_dict('records')

        # Replace NaN values with None
        team_id = replace_nan_with_none(team_id)

        return jsonify(team_id)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@team_route.route('/api/mlb-team/schedule')
def get_team_schedule():
    try:
        # Get team name from query parameters
        team_name = request.args.get('team-name')
        current_year = pb.utils.most_recent_season()
        
        # Check if team name is given
        if not team_name:
            return jsonify({'error': 'Team name is required'}), 400
        
        schedule_data = pb.schedule_and_record(current_year, team_name)
        schedule_data_record = schedule_data.to_dict('records')
        print(schedule_data_record)

        # Replace NaN values with None
        schedule_data_record = replace_nan_with_none(schedule_data_record)

        return jsonify(schedule_data_record)
    except Exception as e:
        return jsonify({'error': str(e)}), 500