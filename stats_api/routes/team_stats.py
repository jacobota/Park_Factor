from flask import Blueprint, jsonify, request
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
    # FanGraphs (pb.team_batting/team_pitching/team_fielding) is Cloudflare-blocked; this single-team
    # batting/pitching/fielding aggregate is built from the MLB Stats API. See routes/savant_sources.py.
    try:
        teamIdfg = request.args.get('team-fg')
        if not teamIdfg:
            return jsonify({'error': 'Team ID is required'}), 400
        teamIdfg = int(teamIdfg)

        record = savant_sources.team_season_stats(teamIdfg)
        if not record:
            return jsonify({'team_batting': [], 'team_pitching': [], 'team_fielding': []})
        return jsonify(replace_nan_with_none(record))
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