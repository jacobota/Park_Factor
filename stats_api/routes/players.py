from flask import Blueprint, jsonify, request
from pybaseball.playerid_lookup import _get_client
import pybaseball as pb
import numpy as np

# Get an instance of PlayerSearchClient using _get_client
player_search = _get_client()

# Set up Blueprint for player_route
player_route = Blueprint('player_route', __name__)

def replace_nan_with_none(data):
    if isinstance(data, list):
        return [replace_nan_with_none(item) for item in data]
    elif isinstance(data, dict):
        return {key: replace_nan_with_none(value) for key, value in data.items()}
    elif isinstance(data, float) and np.isnan(data):
        return None
    else:
        return data

@player_route.route('/')
def home():
    return jsonify( {'message': 'Player API'} )

""" Route to get all MLB Players that played in this year or last year if season
has not begun yet.

Return:
    JSON: List of all current mlb players and information
Throws:
    Exception: If an error occurs while getting players
"""
@player_route.route('/api/mlb-players')
def get_all_mlb_players():
    try:
        # Call table initialized by player_search to get all players, filter by mlb_played_last
        players = player_search.table
        current_year = pb.utils.most_recent_season()
        players_list = players[players['mlb_played_last'] == current_year].to_dict('records')

        # Replace NaN values with None
        players_list = replace_nan_with_none(players_list)

        return jsonify(players_list)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

"""Get playerid's by last name and first name of player

Return: 
    JSON: The player's player information
Throws:
    Exception: If an error occurs while getting playerid or first and last name are not given
""" 
@player_route.route('/api/playerid')
def get_id_of_player():
    # Get last and first name from query parameters
    last = request.args.get('last')
    first = request.args.get('first')
    
    # Check if last and first name is given
    if not last:
        return jsonify({'error': 'Last name is required'}), 400
    
    if not first:
        return jsonify({'error': 'First name recommended'}), 400
    
    try:
        # Call the playerid_lookup function from pybaseball and return player info
        playerid_results = pb.playerid_lookup(last, first)
        player_info = playerid_results.to_dict('records')
        if not player_info:
            return jsonify({'error': 'No player found'}), 404
        
        player_info = replace_nan_with_none(player_info)
        return jsonify(player_info)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

"""Gather player biographical information based on bbref id. This pulls player
biographical information from Baseball Reference data.

Return: 
    JSON: The player's biographical information
Throws:
    Exception: If an error occurs while getting player biographical information
"""
   
@player_route.route('/api/player-bio')
def get_player_bio():
    try:
        # Get player-id from query parameters
        bbref_id = request.args.get('bbref-id')
        
        # Player biographical info based on bbref id
        df, player_bio = pb.get_splits(bbref_id, player_info=True)

        player_bio = replace_nan_with_none(player_bio)

        return jsonify({'player_bio': player_bio})
    except Exception as e:
        return jsonify({'player_bio': None})