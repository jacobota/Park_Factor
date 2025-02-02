from flask import Blueprint, jsonify, request
from pybaseball.playerid_lookup import _get_client
import pybaseball as pb
import pylahman as lahman

# Get an instance of PlayerSearchClient using _get_client
player_search = _get_client()

# Set up Blueprint for player_route
player_route = Blueprint('player_route', __name__)

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
        players_list = players[players['mlb_played_last'] == 2024.0].to_dict('records')
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
        return jsonify(player_info)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@player_route.route('/api/player-bio')
def test():
    try:
        # Get player-id from query parameters
        player_id = request.args.get('player-id')
        
        # Player biographical info based on bbref id
        people_df = lahman.people()
        people_record = people_df[people_df['bbrefID'] == player_id].to_dict('records')
        people_record_selected_attributes = ['nameFirst', 'nameLast', 'birthYear', 'birthMonth', 'birthDay', 'birthCountry',  'weight', 'height', 'bats', 'throws']
        people_selected_attribute_record = [
            {attr: hitter[attr] for attr in people_record_selected_attributes if attr in hitter}
            for hitter in people_record
        ]

        # Player award info based on bbref id
        awards_df = lahman.awards_players()
        awards_record = awards_df[awards_df['playerID'] == player_id].to_dict('records')

        df, pb_bio = pb.get_splits(player_id, player_info=True)

        position = pb_bio['Position'] 
        for person in people_selected_attribute_record:
            person['Position'] = position

        # TODO: Find Team

        return jsonify({'player_bio': people_selected_attribute_record, 'awards': awards_record})
    except Exception as e:
        return jsonify({'error': str(e)}), 500