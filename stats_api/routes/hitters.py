from flask import Blueprint, jsonify, request
import pybaseball as pb

# Set up Blueprint for player_route
hitter_route = Blueprint('hitter_route', __name__)

@hitter_route.route('/')
def home():
    return jsonify( {'message': 'Hitter API'} )

@hitter_route.route('/api/hitter-stats/current-season')
def get_hitter_stats_this_season():
    try:
        # Get hitter id from query parameters
        key_fangraphs = request.args.get('fg-id')

        # Check if key_fangraphs is given or convert to int
        if not key_fangraphs:
            return jsonify({'error': 'Fangraph ID required'}), 400
        else:
            key_fangraphs = int(key_fangraphs)
        
        # Get Fangraphs batting stats for the current season and filter by playerid
        fg_hitter_data = pb.batting_stats(2024, qual=1);
        fg_hitter_record = fg_hitter_data[fg_hitter_data['IDfg'] == key_fangraphs].to_dict('records')
        
        if not fg_hitter_record:
            return jsonify({'playerid': key_fangraphs, 'hitter_stats': None})
        
        # Select specific attributes to return
        selected_attributes = ['Name', 'G', 'AVG', 'OBP', 'SLG', 'OPS', 'HR', 'R', 'H', 'RBI', 'SB', 'wOBA', 'xwOBA', 'xBA', 'xSLG', 'EV', 'maxEV', 'Barrel%', 'HardHit%', 'Swing%', 'Z-Swing%', 'Contact%', 'WPA', 'BB%', 'K%', 'BB/K', 'BsR', 'SB% (pi)', 'wSB', 'ISO', 'BABIP']
        fg_selected_attribute_record = [
            {attr: hitter[attr] for attr in selected_attributes if attr in hitter}
            for hitter in fg_hitter_record
        ]
        
        return jsonify({'player_id': key_fangraphs, 'hitter_stats': fg_selected_attribute_record})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

