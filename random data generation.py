import pandas as pd
import numpy as np
import random
from faker import Faker
from collections import defaultdict

# Setting random seed and initializing Faker
np.random.seed(0)
fake = Faker()

# Initialize user and game ids
user_ids = range(1, 1001)
game_ids = range(1, 16)

# Generate synthetic data for the users table
users_data = {'id': [], 'username': [], 'email': [], 'fullname': [], 'password': [], 'is_active': [], 'is_superuser': [], 'datejoined': [], 'lastlogin': [], 'group_id': []}
for user_id in user_ids:
    users_data['id'].append(user_id)
    users_data['username'].append(fake.user_name())
    users_data['email'].append(fake.email())
    users_data['fullname'].append(fake.name())
    users_data['password'].append('123')
    users_data['is_active'].append(random.randint(0, 1))
    users_data['is_superuser'].append(random.randint(0, 1))
    users_data['datejoined'].append(fake.date_time())
    users_data['lastlogin'].append(fake.date_time())
    users_data['group_id'].append(random.randint(1, 5))  # Assuming 5 groups

# Generate synthetic data for the games table
games_data = {'id': [], 'gamename': [], 'gameimage': [], 'price': [], 'description': []}
for game_id in game_ids:
    games_data['id'].append(game_id)
    games_data['gamename'].append('game'+str(game_id))
    games_data['gameimage'].append('game'+str(game_id)+'.jpg')
    games_data['price'].append(random.randint(10, 100)*10)
    games_data['description'].append('Game ' + str(game_id))

# Convert dictionaries to pandas dataframes
users_df = pd.DataFrame(users_data)
games_df = pd.DataFrame(games_data)

print(users_df)
print(games_df)


# Generate synthetic data for the feedback table
feedback_data = {'id': [], 'userid': [], 'game_id': [], 'Rating': [], 'Feedback': [], 'feedback_date': []}
for id in range(1, 1001):
    feedback_data['id'].append(id)
    feedback_data['userid'].append(random.choice(user_ids))
    feedback_data['game_id'].append(random.choice(game_ids))
    feedback_data['Rating'].append(random.randint(1, 5))
    feedback_data['Feedback'].append(fake.sentence())
    feedback_data['feedback_date'].append(fake.date_time())

# Convert dictionary to pandas dataframe
feedback_df = pd.DataFrame(feedback_data)

# Generate synthetic data for the game order table
gameorder_data = {'id': [], 'userid': [], 'game_id': [], 'ticket_number': []}
for id in range(1, 3001):
    gameorder_data['id'].append(id)
    gameorder_data['userid'].append(random.choice(user_ids))
    gameorder_data['game_id'].append(random.choice(game_ids))
    gameorder_data['ticket_number'].append(fake.random_number(digits=10, fix_len=True))

# Convert dictionary to pandas dataframe
gameorder_df = pd.DataFrame(gameorder_data)

print(feedback_df)
print(gameorder_df)

# Calculate the frequency of game play
games_order_frequency = gameorder_df.groupby(['userid', 'game_id']).size().reset_index(name='frequency')

# Combine ratings and frequency
user_game_interaction = pd.merge(feedback_df, games_order_frequency, how='outer', on=['userid', 'game_id'])

# Handling duplicate values: Calculate mean ratings and frequency
user_game_interaction = user_game_interaction.groupby(['userid', 'game_id']).mean().reset_index()

# Fill NaN values with mean rating and frequency
user_game_interaction['Rating'].fillna(user_game_interaction['Rating'].mean(), inplace=True)
user_game_interaction['frequency'].fillna(user_game_interaction['frequency'].mean(), inplace=True)

# Create the interaction matrix
interaction_matrix = user_game_interaction.pivot(index='userid', columns='game_id', values=['Rating', 'frequency']).fillna(0)

# Normalizing the values
from sklearn.preprocessing import MinMaxScaler
scaler = MinMaxScaler()
interaction_matrix = scaler.fit_transform(interaction_matrix)
print(interaction_matrix,"interaction matrix")

import numpy as np

class MatrixFactorization():
    def __init__(self, R, K, learning_rate, reg_param, epochs, verbose=False):
        """
        :param R: rating matrix
        :param K: latent parameter
        :param learning_rate: alpha on weight update
        :param reg_param: beta on weight update
        :param epochs: training epochs
        :param verbose: print status
        """

        self._R = R
        self._num_users, self._num_items = R.shape
        self._K = K
        self._learning_rate = learning_rate
        self._reg_param = reg_param
        self._epochs = epochs
        self._verbose = verbose

    def fit(self):
        """
        training Matrix Factorization : Update matrix latent weight and bias
        :return: training_process
        """

        # init latent features
        self._P = np.random.normal(size=(self._num_users, self._K))
        self._Q = np.random.normal(size=(self._num_items, self._K))

        # init biases
        self._b_P = np.zeros(self._num_users)
        self._b_Q = np.zeros(self._num_items)
        self._b = np.mean(self._R[np.where(self._R != 0)])

        # train while epochs
        self._training_process = []
        for epoch in range(self._epochs):
            # rating
            for i in range(self._num_users):
                for j in range(self._num_items):
                    if self._R[i, j] > 0:
                        self.gradient_descent(i, j, self._R[i, j])
            cost = self.cost()
            self._training_process.append((epoch, cost))

            # print status
            if self._verbose == True and ((epoch + 1) % 10 == 0):
                print("Iteration: %d ; cost = %.4f" % (epoch + 1, cost))


    def cost(self):
        """
        compute root mean square error
        :return: rmse cost
        """

        xi, yi = self._R.nonzero()
        predicted = self.get_complete_matrix()
        cost = 0
        for x, y in zip(xi, yi):
            cost += pow(self._R[x, y] - predicted[x, y], 2)
        return np.sqrt(cost/len(xi))


    def gradient(self, error, i, j):
        """
        gradient of latent feature for GD

        :param error: rating - prediction error
        :param i: user index
        :param j: item index
        :return: gradient of latent feature tuple
        """

        dp = (error * self._Q[j, :]) - (self._reg_param * self._P[i, :])
        dq = (error * self._P[i, :]) - (self._reg_param * self._Q[j, :])
        return dp, dq

    def gradient_descent(self, i, j, rating):
        """
        graident descent function

        :param i: user index of matrix
        :param j: item index of matrix
        :param rating: rating of (i,j)
        """

        # get error
        prediction = self.get_prediction(i, j)
        error = rating - prediction

        # update biases
        self._b_P[i] += self._learning_rate * (error - self._reg_param * self._b_P[i])
        self._b_Q[j] += self._learning_rate * (error - self._reg_param * self._b_Q[j])

        # update latent feature
        dp, dq = self.gradient(error, i, j)
        self._P[i, :] += self._learning_rate * dp
        self._Q[j, :] += self._learning_rate * dq

    def get_prediction(self, i, j):
        """
        get predicted rating: user_i, item_j
        :return: prediction of r_ij
        """
        return self._b + self._b_P[i] + self._b_Q[j] + self._P[i, :].dot(self._Q[j, :].T)

    def get_complete_matrix(self):
        
        return self._b + self._b_P[:, np.newaxis] + self._b_Q[np.newaxis:, ] + self._P.dot(self._Q.T)


# Declare MF model
mf = MatrixFactorization(interaction_matrix, K=10, learning_rate=0.01, reg_param=0.01, epochs=100, verbose=True)

# Fit the model
mf.fit()
predicted_matrix = mf.get_complete_matrix()
user_id = 15
user_ratings = predicted_matrix[user_id - 1, :]
top_game_ids = user_ratings.argsort()[-5:][::-1]
top_game_names = games_df.loc[games_df['id'].isin(top_game_ids + 1), 'gamename']
print(top_game_names)
from sklearn.metrics import mean_squared_error
from math import sqrt

def compute_rmse(y_pred, y_true):
    return sqrt(mean_squared_error(y_pred, y_true))

# extract the user-item pairs for which we have actual ratings
indices = ~np.isnan(interaction_matrix)

# compare RMSE
rmse = compute_rmse(predicted_matrix[indices], interaction_matrix[indices])
print(f"RMSE: {rmse}")


def precision_recall_at_k(predictions, k=10, threshold=3.5):
    # First map the predictions to each user.
    user_est_true = defaultdict(list)
    for i in range(predictions.shape[0]):
        for j in range(predictions.shape[1]):
            if interaction_matrix[i][j] > 0:  # only for actually rated items
                user_est_true[i].append((predictions[i][j], interaction_matrix[i][j]))

    precisions = dict()
    recalls = dict()
    for uid, user_ratings in user_est_true.items():

        # Sort user ratings by estimated value
        user_ratings.sort(key=lambda x: x[0], reverse=True)

        # Number of relevant items
        n_rel = sum((true_r >= threshold) for (_, true_r) in user_ratings)

        # Number of recommended items in top k
        n_rec_k = sum((est >= threshold) for (est, _) in user_ratings[:k])

        # Number of relevant and recommended items in top k
        n_rel_and_rec_k = sum(((true_r >= threshold) and (est >= threshold))
                              for (est, true_r) in user_ratings[:k])

        # Precision@K: Proportion of recommended items that are relevant
        precisions[uid] = n_rel_and_rec_k / n_rec_k if n_rec_k != 0 else 1

        # Recall@K: Proportion of relevant items that are recommended
        recalls[uid] = n_rel_and_rec_k / n_rel if n_rel != 0 else 1

    return precisions, recalls

# Run this code to get precision and recall at 10
precisions, recalls = precision_recall_at_k(predicted_matrix, k=10, threshold=3.5)

# Compute average precision and recall
avg_precision = sum(prec for prec in precisions.values()) / len(precisions)
avg_recall = sum(rec for rec in recalls.values()) / len(recalls)

print(f"Average Precision at 10: {avg_precision}")
print(f"Average Recall at 10: {avg_recall}")
