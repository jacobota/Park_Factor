from flask import Blueprint, jsonify, request
import pybaseball as pb
import numpy as np
from routes import savant_sources

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

        team_batting_selected_attributes = ['wRC+', 'wOBA', 'HR', 'AVG', 'SLG', 'OPS', 'R', 'BB%', 'K%', 'BB/K', 'ISO', 'BABIP', 'SB', 'CS', 'wSB', 'BsR', 'Age', 'WAR', 'H', 'BB', 'OBP', 'SO']
        team_batting_list = [
            {attr: team_batting[attr] for attr in team_batting_selected_attributes}
            for team_batting in team_batting_list
        ]

        # Call the team_pitching function from pybaseball
        team_pitching = pb.team_pitching(current_year,league='all', ind=1)
        team_pitching_list = team_pitching[team_pitching['teamIDfg'] == teamIdfg].to_dict('records')

        team_pitching_selected_attributes = ['ERA', 'FIP', 'xFIP', 'SIERA', 'BABIP', 'K-BB%', 'K%', 'BB%', 'WHIP', 'GB%', 'HR/FB', 'LOB%', 'Stuff+', 'Location+', 'Pitching+', 'WAR', 'W', 'L', 'R', 'vFA (pi)', 'SV', 'SO', 'BB', 'H', "AVG"]
        team_pitching_list = [
            {attr: team_pitching[attr] for attr in team_pitching_selected_attributes}
            for team_pitching in team_pitching_list
        ]

        # Call team_fielding function from pybaseball
        team_fielding = pb.team_fielding(current_year, league='all', ind=1)
        team_fielding_list = team_fielding[team_fielding['teamIDfg'] == teamIdfg].to_dict('records')

        team_fielding_selected_attributes = ['DRS', 'OAA', 'E', 'FP']
        team_fielding_list = [
            {attr: team_fielding[attr] for attr in team_fielding_selected_attributes}
            for team_fielding in team_fielding_list
        ]

        team_batting_list = replace_nan_with_none(team_batting_list)
        team_pitching_list = replace_nan_with_none(team_pitching_list)
        team_fielding_list = replace_nan_with_none(team_fielding_list)

        return jsonify({'team_batting': team_batting_list, 'team_pitching': team_pitching_list, 'team_fielding': team_fielding_list})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@team_stats_route.route('/api/stats/leaderboard/hitting')
def get_team_hitting_leaderboard():
    # FanGraphs (pb.team_batting) is Cloudflare-blocked; built from the MLB Stats API instead
    # (exact official per-team totals with proper team identity). See routes/savant_sources.py.
    try:
        return jsonify(savant_sources.team_hitting_leaderboard())
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@team_stats_route.route('/api/stats/leaderboard/pitching')
def get_team_pitching_leaderboard():
    # FanGraphs (pb.team_pitching) is Cloudflare-blocked; built from the MLB Stats API instead.
    try:
        return jsonify(savant_sources.team_pitching_leaderboard())
    except Exception as e:
        return jsonify({'error': str(e)}), 500