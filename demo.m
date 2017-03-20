restart=1;
NUM_FACTORS = 20; % Dimension of latent vectors
origdirec = '/ml-1m/'; 
fprintf(1,'Running Probabilistic Matrix Factorization (PMF) \n');
load(strcat(origdirec, 'data_withoutrat_randcold2.mat'));
MAX_USERS = max(warm(:, 2));
MAX_ITEMS = max(warm(:, 1));
MIN_RATING = min(warm(:, 3));
MAX_RATING = max(warm(:, 3));
pmf_modified

restart=1;
fprintf(1,'\nRunning Bayesian PMF\n');
bayespmf

