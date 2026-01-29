import os
import sqlite3
import requests
from dotenv import load_dotenv
from flask import Flask, render_template, request, redirect

app = Flask(__name__) # Create Flask instance

# --- DATABASE PATHING ---
# This finds the folder where app.py lives and creates a path to observations.db there
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
DB_PATH = os.path.join(BASE_DIR, 'observations.db')

# --- DATABASE SETUP ---
# Attempts to connect to existing observations.db, or creates
# it if the file doesn't exist in the correct location.
def init_db():
    print(f"DEBUG: Connecting to database at {DB_PATH}")
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS observations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            team_number INTEGER,
            intake_status TEXT
        )
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS schedule (
            match_key TEXT PRIMARY KEY,
            event_key TEXT NOT NULL,
            match_number INTEGER NOT NULL,
            red_1 TEXT,
            red_2 TEXT, 
            red_3 TEXT,
            blue_1 TEXT,
            blue_2 TEXT,
            blue_3 TEXT,
            scheduled_time INTEGER
        )
    ''')
    conn.commit()
    conn.close()
    print(f"DEBUG: Database initialized at {DB_PATH}")

init_db()
# --- .ENV initialisation ---
load_dotenv() # Load .env file
TBA_API_KEY = os.getenv('TBA_API_KEY') # Locate key in .env file and make usable here
if TBA_API_KEY:  # Verify key was located
    print(f"API Key loaded: {TBA_API_KEY[:10]}...")  # Prints first 10 characters
else:
    print("WARNING: TBA_API_KEY not found in .env file!")

# --- API Set Up ---
headers = {
    'X-TBA-Auth-Key': TBA_API_KEY,
    'User-Agent': 'JUSTINE:robotcat4:v0.1:github.com/robotcat4/JUSTINE'
}
tbaBaseURL = "https://www.thebluealliance.com/api/v3"

# --- ROUTES ---

@app.route('/') # Defines the location/URL of the app. In this case localhost:5000/
def index():
    """Fetch all data to prove the DB is updating"""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM observations ORDER BY id DESC')
    history = cursor.fetchall()
    conn.close()
    return render_template('index.html', history=history)


# noinspection DuplicatedCode
@app.route('/match-schedule/<event_key>')
def match_schedule(event_key):
    """Fetch match schedule from The Blue Alliance API, filter and save to DB"""
    # Define URL and make API request
    endpoint = f"/event/{event_key}/matches"
    event_matches_url = tbaBaseURL + endpoint
    print(f"DEBUG: Fetching from {event_matches_url}")
    response = requests.get(event_matches_url, headers=headers)

    # Status code check & error handling
    print(f"DEBUG: Response status code: {response.status_code}")
    if response.status_code != 200:
        return f"Error: Could not fetch schedule. Status code: {response.status_code}"

    # Parse JSON and filter to only qualification matches
    all_matches = response.json()
    qual_matches = []
    for match in all_matches:
        if match['comp_level'] == 'qm':
            qual_matches.append(match)
    print(f"DEBUG: Found {len(qual_matches)} qualification matches")

    # Extract required data
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    for match in qual_matches:
        match_key = match['key']
        match_number = match['match_number']
        match_time = match['time']
        # Get full set of teams on each alliance
        red_teams = match['alliances']['red']['team_keys']
        blue_teams = match['alliances']['blue']['team_keys']
        def extract_team_numbers(team_keys):
            """Strip 'frc' prefix from team keys and return as list."""
            team1 = team_keys[0].replace('frc', '') if len(team_keys) > 0 else None
            team2 = team_keys[1].replace('frc', '') if len(team_keys) > 1 else None
            team3 = team_keys[2].replace('frc', '') if len(team_keys) > 2 else None
            return team1, team2, team3
        red1, red2, red3 = extract_team_numbers(red_teams)
        blue1, blue2, blue3 = extract_team_numbers(blue_teams)
        # If the match key doesn't exist, add new row with match info.
        # else update the record with the new info
        cursor.execute('''
                    INSERT OR REPLACE INTO schedule 
                    (match_key, event_key, match_number, red_1, red_2, red_3, 
                     blue_1, blue_2, blue_3, scheduled_time)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ''', (match_key, event_key, match_number, red1, red2, red3,
                      blue1, blue2, blue3, match_time))
    print(f"DEBUG: Schedule for {event_key} complete")
    conn.commit()
    conn.close()
    return f"Successfully imported {len(qual_matches)} matches for {event_key}"


# Defines the location as only the /submit page and only when a submission has been posted.
@app.route('/submit', methods=['POST'])
def submit():
    """Handle form submission and save observation to database."""
    # Extract form data
    team = request.form.get('team_number')
    status = request.form.get('intake_status')
    # Save to database - using ? placeholders to prevent SQL injection
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute('INSERT INTO observations (team_number, intake_status) VALUES (?, ?)',
                   (team, status))
    conn.commit()
    conn.close()

    print(f"Saved: Team {team}, Intake {status}")
    return redirect('/') # Redirect to refresh with new data

if __name__ == '__main__':
    app.run(debug=True)