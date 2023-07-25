import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
import mysql.connector


# Connect to MySQL server and fetch data
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="aviroxy2j",
    database="games_portal_db"
)

# Function to fetch data from MySQL and convert it to a Pandas DataFrame
def fetch_data_as_dataframe(query):
    cursor = db.cursor()
    cursor.execute(query)
    columns = [desc[0] for desc in cursor.description]
    data = cursor.fetchall()
    return pd.DataFrame(data, columns=columns)

# Fetch data from all the tables
user_data = fetch_data_as_dataframe("SELECT * FROM User")
game_data = fetch_data_as_dataframe("SELECT * FROM Game")
purchase_data = fetch_data_as_dataframe("SELECT * FROM Purchase")

# Merge user_data, game_data, and purchase_data to create a user-game interaction matrix
user_game_matrix = pd.merge(purchase_data, user_data, on='user_id', how='left')
user_game_matrix = pd.merge(user_game_matrix, game_data, on='game_id', how='left')

# Create a user-game interaction matrix using pivot_table with 'price' as 'rating'
interaction_matrix = user_game_matrix.pivot_table(index='user_id', columns='game_id', values='price', fill_value=0)

# Calculate the similarity between users based on their interactions (cosine similarity)
user_similarity = cosine_similarity(interaction_matrix)

# Function to recommend games to a user
def recommend_games_to_user(user_id, num_recommendations=5):
    user_index = user_id - 1  # Indexing starts from 0
    user_similarities = user_similarity[user_index]
    similar_users_indices = user_similarities.argsort()[::-1][1:]  # Exclude the user itself and sort in descending order

    recommendations = []
    for similar_user_index in similar_users_indices:
        user_interactions = interaction_matrix.iloc[similar_user_index]
        user_unrated_games = user_interactions[user_interactions == 0]
        recommended_games = user_unrated_games.sort_values(ascending=False).iloc[:num_recommendations]
        recommendations.extend(recommended_games.index)
        if len(recommendations) >= num_recommendations:
            break

    recommended_game_details = game_data[game_data['game_id'].isin(recommendations)]
    return recommended_game_details[['game_id', 'game_name', 'game_type', 'description']]

# Example usage:
# Recommend 5 games for User with ID 3
user_id_to_recommend = 5
recommended_games = recommend_games_to_user(user_id_to_recommend, num_recommendations=5)
print(recommended_games)
first_recommended_game = recommended_games.iloc[0]  # Access the details of the first recommended game
print(first_recommended_game)





