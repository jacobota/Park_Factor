from flask import Flask, jsonify
from flask_cors import CORS
from routes.players import player_route
from routes.hitters import hitter_route

app = Flask(__name__)
CORS(app)

@app.route('/')
def home():
    return jsonify( {'message': 'Welcome to the MLB Stats API'} )

# Register Blueprint Routes
app.register_blueprint(player_route, url_prefix='/players')
app.register_blueprint(hitter_route, url_prefix='/hitters')

if __name__ == '__main__':
    app.run(debug=True, port=5000)