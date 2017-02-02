'''
Input: Filename consisting of columns of item IDs, user IDs, and ratings values. The file may use any delimiter, may have these values in any order, and may include other fields such as timestamps.
Output: .mat file splitting users randomly into cold and warm users, along with all their ratings in the order [itemid userid rating]. Other fields are discarded.
'''

import scipy.io as sio
import numpy as np
import random

### Dataset values for Movielens 1M
fileDir = "/ml-1m/"
numOfUsers = 6040
itemColumn = 1
userColumn = 0
ratingColumn = 2
delim = "::"
filename = "ratings.dat"

warm_data = []
cold_data = []
cold_users = []
warm_users = []

### cold_users_split is the fraction of all users that would be kept out of the PMF computation. Set value to 0 to use the entire dataset.
cold_users_split = 0.3
num_cold_users = int(cold_users_split*numOfUsers)

print "Initializing ..."
print "Reading file.............."
data = np.genfromtxt (fileDir+filename, delimiter=delim)
print "...............File reading complete!"

print "Processing users ..."
arr = np.array(data)
allUsers = arr[:, userColumn]
uniqueUsers = set(allUsers)

### Randomly select the user IDs that will be kept aside as cold users
if cold_users_split > 0:
	cold_users = np.random.choice(list(uniqueUsers), num_cold_users)
print "Processing users ... COMPLETE!"

for line in data:
	print line[itemColumn]
	if line[userColumn] in cold_users: # Known cold user
		cold_data.append([line[itemColumn], line[userColumn], line[ratingColumn]])
	else:
		warm_data.append([line[itemColumn], line[userColumn], line[ratingColumn]])
		warm_users.append(line[userColumn])
	print "Processed movie: ", (line[itemColumn])

sio.savemat(fileDir+'data_withoutrat_randcold2.mat', {'warm':warm_data, 'cold':cold_data})
print "Saved file as .mat ..........."
print len(set(cold_users))