import random
from faker import Faker
import mysql.connector

# Connect to MySQL server
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="aviroxy2j",
    database="games_portal_db"
)

# Create a cursor to execute queries
cursor = db.cursor()

# Create User table
user_table_query = """
CREATE TABLE IF NOT EXISTS User (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    age INT,
    time_of_sign_up TIMESTAMP
);
"""

# Create Game table
game_table_query = """
CREATE TABLE IF NOT EXISTS Game (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    game_name VARCHAR(100) NOT NULL,
    prize_money DECIMAL(10, 2),
    min_betting_amount DECIMAL(10, 2),
    max_betting_amount DECIMAL(10, 2),
    game_type VARCHAR(50),
    description TEXT,
    release_date DATE,
    stakes VARCHAR(100)
);
"""

# Create Purchase table
purchase_table_query = """
CREATE TABLE IF NOT EXISTS Purchase (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    game_id INT,
    purchase_date DATE,
    purchase_time TIME,
    price DECIMAL(10, 2),
    ticket_number VARCHAR(20)
);
"""

# Create Bet table
bet_table_query = """
CREATE TABLE IF NOT EXISTS Bet (
    user_id INT,
    game_id INT,
    bet_number INT,
    bet_amount DECIMAL(10, 2)
);
"""

# Create Game Play table
game_play_table_query = """
CREATE TABLE IF NOT EXISTS GamePlay (
    gameplay_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    game_id INT,
    time_played_minutes INT,
    Win BOOLEAN,
    session_date DATE,
    session_time TIME
);
"""

# Create Game Event Data table
game_event_data_table_query = """
CREATE TABLE IF NOT EXISTS GameEventData (
    game_id INT,
    date DATE,
    winning_number INT
);
"""

# Create Feedback table
feedback_table_query = """
CREATE TABLE IF NOT EXISTS Feedback (
    game_id INT,
    user_id INT,
    rating INT,
    text_feedback TEXT,
    fdate DATE,
    ftime TIME
);
"""

# Create User Click table
user_click_table_query = """
CREATE TABLE IF NOT EXISTS UserClick (
    click_id INT AUTO_INCREMENT PRIMARY KEY,
    click_user_id INT,
    game_id INT,
    click_date DATE
);
"""

# Create Search Query table
search_query_table_query = """
CREATE TABLE IF NOT EXISTS SearchQuery (
    query_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    search_query TEXT,
    search_date DATE
);
"""

# Execute queries to create tables
cursor.execute(user_table_query)
cursor.execute(game_table_query)
cursor.execute(purchase_table_query)
cursor.execute(bet_table_query)
cursor.execute(game_play_table_query)
cursor.execute(game_event_data_table_query)
cursor.execute(feedback_table_query)
cursor.execute(user_click_table_query)
cursor.execute(search_query_table_query)

# Generate random data using Faker
fake = Faker()

# Insert random data into User table
for _ in range(10):  # Insert 10 users
    name = fake.name()
    email = fake.email()
    age = random.randint(18, 50)
    time_of_sign_up = fake.date_time_this_decade(before_now=True, after_now=False)
    cursor.execute("INSERT INTO User (name, email, age, time_of_sign_up) VALUES (%s, %s, %s, %s)", (name, email, age, time_of_sign_up))
    db.commit()

# Insert random data into Game table
game_types = ['Action', 'Adventure', 'Strategy', 'Racing', 'Puzzle', 'Sports']
for _ in range(5):  # Insert 5 games
    game_name = fake.catch_phrase()
    prize_money = random.randint(1000, 100000)
    min_betting_amount = random.randint(10, 100)
    max_betting_amount = random.randint(min_betting_amount + 10, min_betting_amount + 100)
    game_type = random.choice(game_types)
    description = fake.text(max_nb_chars=200)
    release_date = fake.date_between(start_date="-2y", end_date="today")
    stakes = fake.sentence(nb_words=6)
    cursor.execute("INSERT INTO Game (game_name, prize_money, min_betting_amount, max_betting_amount, game_type, description, release_date, stakes) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
                   (game_name, prize_money, min_betting_amount, max_betting_amount, game_type, description, release_date, stakes))
    db.commit()

# Insert random data into Purchase table
users = [i for i in range(1, 11)]  # Assuming 10 users exist in the User table
games = [i for i in range(1, 6)]  # Assuming 5 games exist in the Game table
for _ in range(20):  # Insert 20 purchases
    user_id = random.choice(users)
    game_id = random.choice(games)
    purchase_date = fake.date_between(start_date="-1y", end_date="today")
    purchase_time = fake.time_object()
    price = random.uniform(10, 100)
    ticket_number = fake.random_int(min=0, max=9999)
    cursor.execute("INSERT INTO Purchase (user_id, game_id, purchase_date, purchase_time, price, ticket_number) VALUES (%s, %s, %s, %s, %s, %s)",
                   (user_id, game_id, purchase_date, purchase_time, price, ticket_number))
    db.commit()

# Insert random data into Bet table
for _ in range(30):  # Insert 30 bets
    user_id = random.choice(users)
    game_id = random.choice(games)
    bet_number = random.randint(1, 100)
    bet_amount = random.uniform(5, 50)
    cursor.execute("INSERT INTO Bet (user_id, game_id, bet_number, bet_amount) VALUES (%s, %s, %s, %s)", (user_id, game_id, bet_number, bet_amount))
    db.commit()

# Insert random data into Game Play table
for _ in range(50):  # Insert 50 game plays
    user_id = random.choice(users)
    game_id = random.choice(games)
    time_played_minutes = random.randint(10, 180)
    win = random.choice([True, False])
    session_date = fake.date_between(start_date="-1y", end_date="today")
    session_time = fake.time_object()
    cursor.execute("INSERT INTO GamePlay (user_id, game_id, time_played_minutes, Win, session_date, session_time) VALUES (%s, %s, %s, %s, %s, %s)",
                   (user_id, game_id, time_played_minutes, win, session_date, session_time))
    db.commit()

# Insert random data into Game Event Data table
for game_id in games:
    date = fake.date_between(start_date="-1y", end_date="today")
    winning_number = random.randint(1, 100)
    cursor.execute("INSERT INTO GameEventData (game_id, date, winning_number) VALUES (%s, %s, %s)", (game_id, date, winning_number))
    db.commit()

# Insert random data into Feedback table
for _ in range(10):  # Insert 10 feedbacks
    user_id = random.choice(users)
    game_id = random.choice(games)
    rating = random.randint(1, 5)
    text_feedback = fake.text(max_nb_chars=200)
    fdate = fake.date_between(start_date="-1y", end_date="today")
    ftime = fake.time_object()
    cursor.execute("INSERT INTO Feedback (game_id, user_id, rating, text_feedback, fdate, ftime) VALUES (%s, %s, %s, %s, %s, %s)",
                   (game_id, user_id, rating, text_feedback, fdate, ftime))
    db.commit()

# Insert random data into User Click table
for _ in range(20):  # Insert 20 user clicks
    click_user_id = random.choice(users)
    game_id = random.choice(games)
    click_date = fake.date_between(start_date="-1y", end_date="today")
    cursor.execute("INSERT INTO UserClick (click_user_id, game_id, click_date) VALUES (%s, %s, %s)", (click_user_id, game_id, click_date))
    db.commit()

# Insert random data into Search Query table
for _ in range(15):  # Insert 15 search queries
    user_id = random.choice(users)
    search_query = fake.words(nb=random.randint(1, 5), ext_word_list=None, unique=False)
    search_date = fake.date_between(start_date="-1y", end_date="today")
    cursor.execute("INSERT INTO SearchQuery (user_id, search_query, search_date) VALUES (%s, %s, %s)", (user_id, ' '.join(search_query), search_date))
    db.commit()

# Close the database connection
db.close()

