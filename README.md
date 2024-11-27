# Park Factor: MLB Companion App

Are you a die-hard baseball fan looking for more than just scores and standings? Imagine an app that doesn't simply keep you updated but immerses you in the game. Whether you're a stats enthusiast, a visual learner, or just someone who loves to follow your favorite team, Park Factor is here to deliver. This app combines cutting-edge technology, in-depth player and team data, and an intuitive user interface to create the ultimate MLB fan experience.

Park Factor offers a personalized and interactive way to stay connected with Major League Baseball. From visualizing the movement of your favorite pitcher’s slider in 3D to exploring heat maps that reveal a hitter’s swing tendencies, every feature is crafted to enhance your understanding and appreciation of the game. Dive into detailed player stats, track live game updates, and get exclusive insights—this app is designed to bring you closer to the action, whether you’re on the go or watching from home. Welcome to Park Factor, your new go-to baseball companion.

---

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
- 3D Pitch Visualizations:
  - Explore detailed pitch mechanics and shapes in 3D
  - View pitch arsenal and individual pitch animations

### Live Game Updates

- Real-time updates for ongoing games, including team performance and player stats
- Game widgets on the home screen for quick access

### Additional Features

- Heat Maps:
  - Strike zone and spray charts for hitters
  - Swing tendencies color-coded by frequency
- Team of the Week:
  - Highlight the best-performing team dynamically based on Win Probability %

---

## Tech Stack

### Frontend

- Language: Swift
- Frameworks: SwiftUI, SceneKit (for 3D visualizations)
- Tools: Xcode

### Backend

- Server: Node.js, Express
- Database: DynamoDB
- Python Microservice: PyBaseball library for up-to-date player stats and historical data

### APIs

- MLB Live Update API: Provides live game data
- Sports News API: Delivers the latest MLB news
- PyBaseball Integration: Fetches advanced player stats and performance metrics
