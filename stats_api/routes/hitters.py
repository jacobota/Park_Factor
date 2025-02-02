from flask import Blueprint, jsonify, request
import pybaseball as pb

# Set up Blueprint for player_route
hitter_route = Blueprint('hitter_route', __name__)

@hitter_route.route('/')
def home():
    return jsonify( {'message': 'Hitter API'} )

@hitter_route.route('/api/hitter-stats')
def get_hitter_stats_this_season():
    try:
        # Get hitter first and last name from query parameters
        full_name = request.args.get('name')
        if full_name:
            full_name = full_name.replace('_', ' ').lower()
        else:
            return jsonify({'error': 'Name is required'}), 400
        
        # Get Fangraphs batting stats for the current season and filter by player name
        fg_data = pb.batting_stats(2024, qual=1);
        fg_data['Name'] = fg_data['Name'].str.lower()
        fg_record = fg_data[fg_data['Name'] == full_name].to_dict('records')
        
        if not fg_record:
            return jsonify({'full_name': full_name, 'player_stats': None})
        
        # Select specific attributes to return
        selected_attributes = ['Name', 'G', 'AVG', 'OBP', 'SLG', 'OPS', 'HR', 'R', 'H', 'RBI', 'SB', 'wOBA', 'xwOBA', 'xBA', 'xSLG', 'EV', 'maxEV', 'Barrel%', 'HardHit%', 'Swing%', 'Z-Swing%', 'Contact%', 'WPA', 'BB%', 'K%', 'BB/K', 'BsR', 'SB% (pi)', 'wSB', 'ISO', 'BABIP']
        fg_selected_attribute_record = [
            {attr: player[attr] for attr in selected_attributes if attr in player}
            for player in fg_record
        ]
        
        return jsonify({'player_stats': fg_selected_attribute_record})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

