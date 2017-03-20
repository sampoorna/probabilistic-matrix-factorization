
Recommend
=========

Adapted PMF code to include linearly decreasing step size.

Current model:
--------------
- Probabilistic Matrix Factorization

Reference:
----------
- "Probabilistic Matrix Factorization", R. Salakhutdinov and A.Mnih., Neural Information Processing Systems 21 (NIPS 2008). Jan. 2008.
- "Bayesian Probabilistic Matrix Factorization using MCMC", R. Salakhutdinov and A.Mnih., 25th International Conference on Machine Learning (ICML-2008) 
- Matlab code: http://www.cs.toronto.edu/~rsalakhu/BPMF.html
- Sample dataset MovieLens 1M: https://grouplens.org/datasets/movielens/1m/

Getting started:
----------------

To run PMF with MovieLens 1M dataset:

- Download MovieLens 1M dataset into the same directory and unzip it (data will be in `ml-1m` folder)
- Run process.py to pre-process the dataset into .mat format. Can also split data by users to keep ratings by a randomly selected set of users hidden from PMF. Useful for simulating cold start users for experiments.
 - Input: Any file with columns of item IDs, user IDs, and ratings values. The file may use any delimiter, may have these values in any order, and may include other fields such as timestamps.
 - Fill out values for the number of users, the delimiter, and the values of the column indices in the order that they appear in the original dataset. For example, `userColumn = 0` means that the first column in the dataset contains IDs of the users. Note that the order of the user column, item column and rating column can change from dataset to dataset.
 - Fill out the filename that contains the user IDs, item IDs and ratings
 - Output: .mat file splitting users randomly into cold and warm users, along with all their ratings in the order [itemid userid rating]. Other fields are discarded.
 - Set `cold_users_split = 0` to use the entire dataset, default value = 0.3, to keep ratings from 30% of the users hidden from the PMF computation
- Run demo.m