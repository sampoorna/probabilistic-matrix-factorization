restart=1;
MAX_USERS = 6040;
MAX_ITEMS = 3952;
NUM_FACTORS = 20;
fprintf(1,'Running Probabilistic Matrix Factorization (PMF) \n');
load '/ml-1m/data_withoutrat_randcold2.mat';
pmf

restart=1;
fprintf(1,'\nRunning Bayesian PMF\n');
bayespmf

