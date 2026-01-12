import os
from flask import Flask, render_template, request, redirect
import sqlite3

app = Flask(__name__)

# --- DATABASE PATHING ---
# This finds the folder where app.py lives and creates a path to observations.db there
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
DB_PATH = os.path.join(BASE_DIR, 'observations.db')

# --- DATABASE SETUP ---
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

init_db()

# --- ROUTES ---

@app.route('/')
def index():
    # Fetch all data to prove the DB is updating
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM observations ORDER BY id DESC')
    history = cursor.fetchall()
    conn.close()
    return render_template('index.html', history=history)

@app.route('/submit', methods=['POST'])
def submit():
    team = request.form.get('team_number')
    status = request.form.get('intake_status')

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute('INSERT INTO observations (team_number, intake_status) VALUES (?, ?)',
                   (team, status))
    conn.commit()
    conn.close()

    print(f"Saved: Team {team}, Intake {status}")
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)