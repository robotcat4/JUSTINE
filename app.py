from flask import Flask, render_template, request, redirect
import sqlite3

app = Flask(__name__)

# --- DATABASE SETUP ---
def init_db():
    conn = sqlite3.connect('observations.db')
    cursor = conn.cursor()
    # Create the table if it doesn't exist yet
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS observations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            team_number INTEGER,
            intake_status TEXT
        )
    ''')
    conn.commit()
    conn.close()

# Run the setup function immediately
init_db()

# --- ROUTES ---

@app.route('/')
def index():
    # This just shows the entry form
    return render_template('index.html')

@app.route('/submit', methods=['POST'])
def submit():
    # 1. Get data from the HTML form
    team = request.form.get('team_number')
    status = request.form.get('intake_status')

    # 2. Save it to the SQL database
    conn = sqlite3.connect('observations.db')
    cursor = conn.cursor()
    cursor.execute('INSERT INTO observations (team_number, intake_status) VALUES (?, ?)',
                   (team, status))
    conn.commit()
    conn.close()

    # 3. Go back to the home page so we can enter another match
    print(f"Saved: Team {team}, Intake {status}") # Helps you debug in PyCharm
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)