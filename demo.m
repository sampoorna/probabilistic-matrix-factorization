restart=1;
NUM_FACTORS = 20; % Dimension of latent vectors
fprintf(1,'Running Probabilistic Matrix Factorization (PMF) \n');
load '/ml-1m/data_withoutrat_randcold2.mat';
MAX_USERS = max(warm(:, 1));
MAX_ITEMS = max(warm(:, 2));
pmf_modified

restart=1;
fprintf(1,'\nRunning Bayesian PMF\n');
bayespmf

