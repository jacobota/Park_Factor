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
        if not player_info:
            return jsonify({'error': 'No player found'}), 404
        return jsonify(player_info)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

"""Gather player biographical information based on bbref id and mlbam id. This pulls player
biographical information from Lahman and Statcast data.

Return: 
    JSON: The player's biographical information
Throws:
    Exception: If an error occurs while getting player biographical information
"""
   
@player_route.route('/api/player-bio')
def test():
    try:
        # Get player-id from query parameters
        bbref_id = request.args.get('bbref-id')
        mlbam_id = request.args.get('mlbam-id')

        if not mlbam_id:
            return jsonify({'error': 'Savant ID required'}), 400
        else:
            mlbam_id = int(mlbam_id)

        current_year = pb.utils.most_recent_season()
        
        # Player biographical info based on bbref id
        people_df = lahman.people()
        people_record = people_df[people_df['bbrefID'] == bbref_id].to_dict('records')
        people_record_selected_attributes = ['birthYear', 'birthCountry',  'weight', 'height', 'bats', 'throws']
        people_selected_attribute_record = [
            {attr: hitter[attr] for attr in people_record_selected_attributes if attr in hitter}
            for hitter in people_record
        ]

        #Grab team, position, age and team_id from statcast (out above average)
        statcast_hitter_bio_data = pb.statcast_sprint_speed(current_year)  
        statcast_hitter_bio_record = statcast_hitter_bio_data[statcast_hitter_bio_data['player_id'] == mlbam_id].to_dict('records')      

        statcast_hitter_bio_selected_attributes = ['last_name, first_name', 'age', 'team', 'position']
        statcast_hitter_bio_record = [
            {attr: sprint_speed[attr] for attr in statcast_hitter_bio_selected_attributes if attr in sprint_speed}
            for sprint_speed in statcast_hitter_bio_record
        ]

        # Get Pitcher Pitch Types and Average speeds
        statcast_pitcher_speed_data = pb.statcast_pitcher_pitch_arsenal(current_year, minP=1)
        statcast_pitcher_speed_record = statcast_pitcher_speed_data[statcast_pitcher_speed_data['pitcher'] == mlbam_id].to_dict('records')
        
        statcast_pitcher_speed_selected_attributes = ['ch_avg_speed', 'cu_avg_speed', 'fc_avg_speed', 'ff_avg_speed', 'fs_avg_speed', 'kn_avg_speed', 'si_avg_speed', 'sl_avg_speed', 'st_avg_speed', 'sv_avg_speed']
        statcast_pitcher_speed_record = [
            {attr: pitch_speed[attr] for attr in statcast_pitcher_speed_selected_attributes if attr in pitch_speed}
            for pitch_speed in statcast_pitcher_speed_record
        ]

        statcast_pitcher_bio_data = pb.statcast_pitcher_arsenal_stats(current_year, minPA=1)
        statcast_pitcher_bio_record = statcast_pitcher_bio_data[statcast_pitcher_bio_data['player_id'] == mlbam_id].to_dict('records')

        statcast_pitcher_bio_selected_attributes = ['last_name, first_name', 'team_name_alt']
        statcast_pitcher_bio_record = [
            {attr: pitch_arsenal[attr] for attr in statcast_pitcher_bio_selected_attributes if attr in pitch_arsenal}
            for pitch_arsenal in statcast_pitcher_bio_record
        ]

        # Add position for pitcher (LHP or RHP)
        if statcast_pitcher_bio_record:
            throws = people_selected_attribute_record[0].get('throws')
            if throws == 'L':
                statcast_pitcher_bio_record[0]['pitcher_position'] = 'LHP'
            elif throws == 'R':
                statcast_pitcher_bio_record[0]['pitcher_position'] = 'RHP'

        player_bio = {}
        if people_selected_attribute_record:
            player_bio.update(people_selected_attribute_record[0])
        if statcast_hitter_bio_record:
            player_bio.update(statcast_hitter_bio_record[0])
        if statcast_pitcher_speed_record:
            player_bio.update(statcast_pitcher_speed_record[0])
        if statcast_pitcher_bio_record:
            player_bio.update(statcast_pitcher_bio_record[0])

        # Player award info based on bbref id
        awards_df = lahman.awards_players()
        awards_record = awards_df[awards_df['playerID'] == bbref_id].to_dict('records')

        return jsonify({'player_bio': player_bio, 'awards': awards_record})
    except Exception as e:
        return jsonify({'error': str(e)}), 500