import mysql.connector
from mysql.connector import Error
from faker import Faker
import random
import datetime

# Connect to MySQL server
try:
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="aviroxy2j",
        database="test2"
    )
    if connection.is_connected():
        cursor = connection.cursor(buffered=True)
        print("Successfully connected to database")
        
except Error as e:
    print("Error while connecting to MySQL", e)

# Create a cursor to execute queries
cursor = connection.cursor(buffered=True)

# Drop tables if they exist
cursor.execute("DROP TABLE IF EXISTS User, Game, Purchase, Bet, GamePlay, GameEventData, Feedback, UserClick, SearchQuery;")

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
cursor.execute(user_table_query)

# Create Game table
game_table_query = """
CREATE TABLE IF NOT EXISTS Game (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    game_name VARCHAR(100) NOT NULL,
    prize_money DECIMAL(10, 2),
    min_betting_amount DECIMAL(10, 2),
    max_betting_amount DECIMAL(10, 2),
    game_type ENUM('lottery','betting','lottery and betting'),
    description TEXT,
    release_date DATE,
    stakes ENUM('low', 'medium', 'high')
);
"""
cursor.execute(game_table_query)

# Create Purchase table
purchase_table_query = """
CREATE TABLE IF NOT EXISTS Purchase (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    game_id INT,
    purchase_date DATE,
    purchase_time TIME,
    price DECIMAL(10, 2),
    ticket_number INT,
    CONSTRAINT uc_ticket UNIQUE (game_id, purchase_date, ticket_number)
);
"""
cursor.execute(purchase_table_query)

# Create Bet table
bet_table_query = """
CREATE TABLE IF NOT EXISTS Bet (
    bet_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    game_id INT,
    bet_number INT,
    bet_amount DECIMAL(10, 2)
);
"""
cursor.execute(bet_table_query)

# Create Game Play table
game_play_table_query = """
CREATE TABLE IF NOT EXISTS GamePlay (
    gameplay_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    game_id INT,
    time_played_minutes INT,
    Win ENUM('win','lose'),
    session_date DATE,
    session_time TIME,
    CONSTRAINT uc_winner UNIQUE (game_id, session_date, Win)
);
"""
cursor.execute(game_play_table_query)

# Create Game Event Data table
game_event_data_table_query = """
CREATE TABLE IF NOT EXISTS GameEventData (
    game_event_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT,
    date DATE,
    winning_number INT
);
"""
cursor.execute(game_event_data_table_query)

# Create Feedback table
feedback_table_query = """
CREATE TABLE IF NOT EXISTS Feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT,
    user_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    text_feedback TEXT,
    fdate DATE,
    ftime TIME
);
"""
cursor.execute(feedback_table_query)

# Create User Click table
user_click_table_query = """
CREATE TABLE IF NOT EXISTS UserClick (
    click_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    game_id INT,
    click_date DATE
);
"""
cursor.execute(user_click_table_query)

# Create Search Query table
search_query_table_query = """
CREATE TABLE IF NOT EXISTS SearchQuery (
    query_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    search_query TEXT,
    search_date DATE
);
"""
cursor.execute(search_query_table_query)

# Commit the transaction
connection.commit()

# Generate random data using Faker
fake = Faker()

game_names = ['cashpop', 'cash4life', 'power ball', 'bingo', 'thunderball']
game_types = ['lottery', 'betting', 'lottery and betting']
game_description = ['A simple lottery game', 'A weekly game with life-changing prizes', 'Multi-state lottery game', 'Classic number matching game', 'Exciting game with lots of surprises']

# Insert random data into User table
for _ in range(100):  # Insert 100 users
    name = fake.name()
    email = fake.email()
    age = random.randint(18, 50)
    time_of_sign_up = fake.date_time_this_decade(before_now=True, after_now=False, tzinfo=None)
    cursor.execute("INSERT INTO User (name, email, age, time_of_sign_up) VALUES (%s, %s, %s, %s)", (name, email, age, time_of_sign_up))
    connection.commit()

# Insert data into Game table
for i in range(5):  # Insert 5 games
    game_name = game_names[i]
    prize_money = round(random.uniform(1000, 10000), 2)
    min_betting_amount = round(random.uniform(1, 10), 2)
    max_betting_amount = round(random.uniform(min_betting_amount, min_betting_amount * 10), 2)
    game_type = game_types[random.randint(0, 2)]
    description = game_description[i]
    release_date = fake.date_between(start_date="-5y", end_date="-1y")
    stakes = random.choice(['low', 'medium', 'high'])
    cursor.execute("INSERT INTO Game (game_name, prize_money, min_betting_amount, max_betting_amount, game_type, description, release_date, stakes) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
                   (game_name, prize_money, min_betting_amount, max_betting_amount, game_type, description, release_date, stakes))
    connection.commit()

for i in range(1, 101):  # for each user
    for j in range(1, 6):  # for each game
        # Insert Purchase
        purchase_date = fake.date_between(start_date="-1y", end_date="today")
        purchase_time = fake.time_object()
        price = round(random.uniform(1, 100), 2)
        ticket_number = random.randint(1, 1000)
        cursor.execute("INSERT INTO Purchase (user_id, game_id, purchase_date, purchase_time, price, ticket_number) VALUES (%s, %s, %s, %s, %s, %s)",
                       (i, j, purchase_date, purchase_time, price, ticket_number))
        
        # Insert Bet
        bet_number = random.randint(1, 1000)
        bet_amount = round(random.uniform(1, 100), 2)
        cursor.execute("INSERT INTO Bet (user_id, game_id, bet_number, bet_amount) VALUES (%s, %s, %s, %s)",
                       (i, j, bet_number, bet_amount))

        # Insert GamePlay
        time_played_minutes = random.randint(1, 60)
        Win = random.choice(['win', 'lose'])
        session_date = fake.date_between(start_date=purchase_date, end_date="today")
        session_time = fake.time_object()
        cursor.execute("INSERT INTO GamePlay (user_id, game_id, time_played_minutes, Win, session_date, session_time) VALUES (%s, %s, %s, %s, %s, %s)",
                       (i, j, time_played_minutes, Win, session_date, session_time))

        # Insert GameEventData
        winning_number = random.randint(1, 1000)
        cursor.execute("INSERT INTO GameEventData (game_id, date, winning_number) VALUES (%s, %s, %s)",
                       (j, session_date, winning_number))
        
        # Insert GamePlay and GameEventData
for i in range(1, 101):  # for each user
    for j in range(1, 6):  # for each game
        # ...
        
        # Insert GamePlay
        time_played_minutes = random.randint(1, 60)
        session_date = fake.date_between(start_date=purchase_date, end_date="today")
        session_time = fake.time_object()

        game_date = (j, session_date)
        if game_date in winners:
            Win = 'lose'
        else:
            Win = 'win'
            winners[game_date] = i  # Mark user as winner for this game on this date

        cursor.execute("INSERT INTO GamePlay (user_id, game_id, time_played_minutes, Win, session_date, session_time) VALUES (%s, %s, %s, %s, %s, %s)",
                       (i, j, time_played_minutes, Win, session_date, session_time))

        # Insert GameEventData
        if Win == 'win':
            winning_number = ticket_number
        else:
            winning_number = random.randint(1, 1000)
        cursor.execute("INSERT INTO GameEventData (game_id, date, winning_number) VALUES (%s, %s, %s)",
                       (j, session_date, winning_number))

        # Insert Feedback
        rating = random.randint(1, 5)
        text_feedback = fake.text(max_nb_chars=100)
        fdate = fake.date_between(start_date=session_date, end_date="today")
        ftime = fake.time_object()
        cursor.execute("INSERT INTO Feedback (game_id, user_id, rating, text_feedback, fdate, ftime) VALUES (%s, %s, %s, %s, %s, %s)",
                       (j, i, rating, text_feedback, fdate, ftime))

        # Insert UserClick
        click_date = fake.date_between(start_date=session_date, end_date="today")
        cursor.execute("INSERT INTO UserClick (user_id, game_id, click_date) VALUES (%s, %s, %s)",
                       (i, j, click_date))

        # Insert SearchQuery
        search_query = fake.sentence(nb_words=6)
        search_date = fake.date_between(start_date=session_date, end_date="today")
        cursor.execute("INSERT INTO SearchQuery (user_id, search_query, search_date) VALUES (%s, %s, %s)",
                       (i, search_query, search_date))

    connection.commit()

# Close the cursor and connection
cursor.close()
connection.close()
