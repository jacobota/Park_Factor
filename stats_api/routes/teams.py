from flask import Blueprint, jsonify, request
import pybaseball as pb

# Set up Blueprint for team_route
team_route = Blueprint('team_route', __name__)

@team_route.route('/')
def home():
    return jsonify( {'message': 'Team API'} )

@team_route.route('/api/mlb-teams')
def get_all_mlb_teams():
    try:
        # Call the team_ids function from pybaseball and return all teams and their ids (using 2020 as year to search from)
        teams = pb.team_ids(2020)
        teams_list = teams.to_dict('records')
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

        return jsonify(team_id)
    except Exception as e:
        return jsonify({'error': str(e)}), 500