# Park Factor: MLB Companion App

Are you a die-hard baseball fan looking for more than just scores and standings? Imagine an app that doesn't simply keep you updated but immerses you in the game. Whether you're a stats enthusiast, a visual learner, or just someone who loves to follow your favorite team, Park Factor is here to deliver. This app combines cutting-edge technology, in-depth player and team data, and an intuitive user interface to create the ultimate MLB fan experience.

Park Factor offers a personalized and interactive way to stay connected with Major League Baseball. From visualizing the movement of your favorite pitcher’s slider to exploring spray charts that reveal a hitter’s swing tendencies, every feature is crafted to enhance your understanding and appreciation of the game. Dive into detailed player stats, track live game updates, and get exclusive insights—this app is designed to bring you closer to the action, whether you’re on the go or watching from home. Welcome to Park Factor, your new go-to baseball companion.

## Features

### Account Functionality

- User Accounts: Sign up, log in, and managing profile preferences
- User Favorites: Follow your favorite teams and players for personalized updates

### News Feature

- Team News:
  - View news filtered by favorites or "Around the League"
  - Use of a MLB news API

### Data Visualizations

- Player Statistics:
  - View season and historical stats for current MLB players
  - Analyze player performance with advanced metrics
- Pitch Visualizations:
  - Explore pitch shapes
  - View pitch arsenal and individual pitch stats
- Spray Charts:
  - Spray Charts for where a hitter tends to hit the ball

## Tech Stack

### Frontend

- Language: Swift
- Frameworks: SwiftUI
- Tools: Xcode

### Backend

- Server: Node.js, Express
- Database: DynamoDB
- Python Microservice: PyBaseball library for up-to-date player stats and historical data

### APIs

- Sports News API: Delivers the latest MLB news
- PyBaseball Integration: Fetches advanced player stats and performance metrics

## Steps to Download and Run

### Node

- Must have Node installed
- Start the node server from the backend directory
   - `node app.js`
 
### Flask

- Have Python installed
- Install venv
- Install pybaseball package if not currently in venv profile
- Activate venv with
    - `source venv/bin/activate`
- Start Flask
    - `python app.py`
 
### SwiftUI

- Open up XCode
- Either use `cmd-r` to start the simulator or go to ContentView.swift for the preview version

## Updates to pybaseball Library

- Changed return for player_bios function
```
player_info_data = {
  'Position': fv[1],
  'Bats': fv[3],
  'Throws': fv[5],
  'Height': fv[6].split(' ')[0]+"' "+fv[6].split(' ')[1], # Commented out because I determined that Pablo Sandoval has some weird formatting that ruins this. Uncomment for ht, wt of most players. 
  'Weight': fv[7][0:3]+" lbs",
  'Born': fv[14],
  'Origin': fv[16]
}
```

- Added Pitcher functions that showed pitch movement and spin (__init__.py)
'''
statcast_pitcher_active_spin,
statcast_pitcher_pitch_movement,
'''
