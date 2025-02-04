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
        # Get hitter id from query parameters and most recent year from pybaseball
        key_fangraphs = request.args.get('fg-id')
        key_mlbam = request.args.get('mlbam-id')
        current_year = pb.utils.most_recent_season()

        # Check if key_fangraphs and another if key_mlbam is given or convert to int
        if not key_fangraphs:
            return jsonify({'error': 'Fangraph ID required'}), 400
        else:
            key_fangraphs = int(key_fangraphs)

        if not key_mlbam:
            return jsonify({'error': 'Savant ID required'}), 400
        else:
            key_mlbam = int(key_mlbam)
        
        # Get Fangraphs batting stats for the current season and filter by playerid
        fg_hitter_data = pb.batting_stats(current_year, qual=1);
        fg_hitter_record = fg_hitter_data[fg_hitter_data['IDfg'] == key_fangraphs].to_dict('records')
        
        if not fg_hitter_record:
            return jsonify({'playerid': key_fangraphs, 'hitter_stats': None})

        # Get statcast data for sprint speed
        statcast_sprint_speed_data = pb.statcast_sprint_speed(current_year)  
        statcast_sprint_speed_record = statcast_sprint_speed_data[statcast_sprint_speed_data['player_id'] == key_mlbam].to_dict('records')      

        # Get statcast data for fielding stats
        # TODO: Need to get position for player to filter by position
        statcast_oaa_data = pb.statcast_outs_above_average(current_year, 3)
        statcast_oaa_record = statcast_oaa_data[statcast_oaa_data['player_id'] == key_mlbam].to_dict('records')

         # Select specific attributes to return for batting, sprint speed, oaa stats
        fg_hitter_record_selected_attributes = ['G', 'AVG', 'OBP', 'SLG', 'OPS', 'WAR', 'HR', 'R', 'H', 'RBI', 'SB', 'wOBA', 'xwOBA', 'xBA', 'xSLG', 'EV', 'maxEV', 'Barrel%', 'HardHit%', 'Swing%', 'Z-Swing%', 'Contact%', 'WPA', 'BB%', 'K%', 'BB/K', 'BsR', 'SB% (pi)', 'wSB', 'ISO', 'BABIP']
        fg_selected_attribute_record = [
            {attr: hitter[attr] for attr in fg_hitter_record_selected_attributes if attr in hitter}
            for hitter in fg_hitter_record
        ]
        statcast_sprint_speed_selected_attributes = ['sprint_speed']
        statcast_sprint_speed_record = [
            {attr: sprint_speed[attr] for attr in statcast_sprint_speed_selected_attributes if attr in sprint_speed}
            for sprint_speed in statcast_sprint_speed_record
        ]
        statcast_oaa_selected_attributes = ['outs_above_average']
        statcast_oaa_record = [
            {attr: oaa[attr] for attr in statcast_oaa_selected_attributes if attr in oaa}
            for oaa in statcast_oaa_record
        ]

        #combine all stats into one
        hitter_stats = {}
        if fg_selected_attribute_record:
            hitter_stats.update(fg_selected_attribute_record[0])
        if statcast_sprint_speed_record:
            hitter_stats.update(statcast_sprint_speed_record[0])
        if statcast_oaa_record:
            hitter_stats.update(statcast_oaa_record[0])

        return jsonify({'player_id': key_fangraphs, 'hitter_stats': hitter_stats})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# TODO: Get Career Stats for Hitter

# TODO: Get Preview Stats for Hitter
