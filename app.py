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