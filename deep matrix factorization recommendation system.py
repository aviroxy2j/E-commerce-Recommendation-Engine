import numpy as np
import random
from faker import Faker
import mysql.connector
from keras.models import Model
from keras.layers import Input, Embedding, Flatten, Dot, Concatenate, Dense
from keras.optimizers import Adam
from keras.callbacks import EarlyStopping

# Define constants
NUM_USERS = 10
NUM_GAMES = 5
EMBEDDING_DIM = 50
LEARNING_RATE = 0.001
BATCH_SIZE = 32
EPOCHS = 50

# Connect to MySQL server
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="aviroxy2j",
    database="games_portal_db"
)

# Create a cursor to execute queries
cursor = db.cursor()

# Generate random data using Faker
fake = Faker()

# Generate random data for GameEventData table
games = [i for i in range(1, NUM_GAMES + 1)]
for game_id in games:
    date = fake.date_between(start_date="-1y", end_date="today")
    winning_number = random.randint(1, 100)
    cursor.execute("INSERT INTO GameEventData (game_id, date, winning_number) VALUES (%s, %s, %s)", (game_id, date, winning_number))
    db.commit()

# Generate random data for Feedback table
users = [i for i in range(1, NUM_USERS + 1)]
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

# Close the database connection
db.close()

# Load data from the database for user-game interactions (purchases)
# and feedback (ratings)
# You need to modify this part based on your actual database structure.
# Assuming there are three tables - User, Purchase, and Feedback.
# You may need to adjust this based on your schema.
def load_data_from_database():
    user_interactions = []
    user_ratings = []

    # Connect to MySQL server
    db = mysql.connector.connect(
        host="localhost",
        user="root",
        password="aviroxy2j",
        database="games_portal_db"
    )

    # Create a cursor to execute queries
    cursor = db.cursor()

    # Fetch user interactions (purchases) from the database
    cursor.execute("SELECT user_id, game_id FROM Purchase")
    purchases = cursor.fetchall()
    for user_id, game_id in purchases:
        user_interactions.append((user_id, game_id))

    # Fetch user ratings from the database
    cursor.execute("SELECT user_id, game_id, rating FROM Feedback")
    ratings = cursor.fetchall()
    for user_id, game_id, rating in ratings:
        user_ratings.append((user_id, game_id, rating))

    # Close the database connection
    db.close()

    return user_interactions, user_ratings

# Load data from the database for games (to map game IDs to names)
def load_games_from_database():
    games_data = {}

    # Connect to MySQL server
    db = mysql.connector.connect(
        host="localhost",
        user="root",
        password="aviroxy2j",
        database="games_portal_db"
    )

    # Create a cursor to execute queries
    cursor = db.cursor()

    # Fetch game data from the database
    cursor.execute("SELECT game_id, game_name FROM Game")
    games = cursor.fetchall()
    for game_id, game_name in games:
        games_data[game_id] = game_name

    # Close the database connection
    db.close()

    return games_data

# Load game data from the database
games_data = load_games_from_database()


# Convert user interactions and ratings to numpy arrays
user_interactions, user_ratings = load_data_from_database()
user_interactions = np.array(user_interactions)
user_ratings = np.array(user_ratings)

# Map the game IDs in user_interactions to continuous integers starting from 1
game_id_mapping = {old_id: new_id for new_id, old_id in enumerate(np.unique(user_interactions[:, 1]), 1)}
user_interactions[:, 1] = np.vectorize(game_id_mapping.get)(user_interactions[:, 1])

# Get the number of users and games
num_users = np.max(user_interactions[:, 0])
num_games = np.max(user_interactions[:, 1])
# Create a neural network model for Deep Matrix Factorization
user_input = Input(shape=(1,))
user_embedding = Embedding(input_dim=num_users + 1, output_dim=EMBEDDING_DIM)(user_input)
user_vec = Flatten()(user_embedding)

game_input = Input(shape=(1,))
game_embedding = Embedding(input_dim=num_games + 1, output_dim=EMBEDDING_DIM)(game_input)
game_vec = Flatten()(game_embedding)

# Concatenate user and game embeddings
merged_vec = Concatenate()([user_vec, game_vec])

# Add hidden layers for deep matrix factorization
merged_vec = Dense(128, activation='relu')(merged_vec)
merged_vec = Dense(64, activation='relu')(merged_vec)

output = Dense(1)(merged_vec)

# Compile the model
model = Model(inputs=[user_input, game_input], outputs=output)
model.compile(optimizer=Adam(lr=LEARNING_RATE), loss='mse')

# Train the model
model.fit([user_interactions[:, 0], user_interactions[:, 1]], user_ratings[:, 2],
          batch_size=BATCH_SIZE, epochs=EPOCHS, callbacks=[EarlyStopping(patience=5)], validation_split=0.2)

# Get the learned user and game embeddings
user_embeddings = model.get_layer(index=2).get_weights()[0]
game_embeddings = model.get_layer(index=3).get_weights()[0]

# Function to get recommended games for a user with their names
def get_recommendations_with_names(user_id, top_n=5):
    user_id = user_id - 1  # Adjust user ID to match embedding index
    user_vec = user_embeddings[user_id]
    user_vec = user_vec.reshape(1, -1)

    # Calculate the dot product of the user embedding and all game embeddings
    dot_product = np.dot(user_vec, game_embeddings.T)

    # Get indices of top N recommended games
    top_indices = np.argsort(dot_product[0])[::-1][:top_n]

    # Convert game indices to actual game IDs and get their names
    recommended_games = [(game_id, games_data[game_id]) for game_id in top_indices + 1]

    return recommended_games

# Example usage:
# Get top 5 recommended games for user with ID 1
recommended_games = get_recommendations_with_names(1, top_n=5)
print("Recommended games for user 1:", recommended_games)