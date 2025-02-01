from flask import Blueprint, jsonify
from pybaseball.playerid_lookup import _get_client

# Get an instance of PlayerSearchClient using _get_client
player_search = _get_client()

# Set up Blueprint for player_route
player_route = Blueprint('player_route', __name__)

@player_route.route('/')
def home():
    return jsonify( {'message': 'Player API'} )

@player_route.route('/api/mlb-players')
def get_all_mlb_players():
    try:
        players = player_search.table
        players_list = players[players['mlb_played_last'] == 2024.0].to_dict('records')
        return jsonify(players_list)
    except Exception as e:
        return jsonify({'error': str(e)}), 500