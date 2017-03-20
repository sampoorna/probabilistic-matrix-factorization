% Version 1.000
%
% Code provided by Ruslan Salakhutdinov
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.

rand('state',0); 
randn('state',0); 

if restart==1 
	fprintf('Initializing ......\n');
  restart=0;
  epsilon = 200; % Learning rate 
  lambda  = 0.1; % Regularization parameter 
  momentum=0; 

  epoch=1; 
  maxepoch=1600; 

  %load moviedata % Triplets: {user_id, movie_id, rating} 

  numbatches= 25; % Number of batches  
  num_m = MAX_ITEMS;  % Number of movies 
  num_p = MAX_USERS;  % Number of users 
  num_feat = NUM_FACTORS; % Rank of decomposition 

  w1_M1     = 0.1*randn(num_m, num_feat); % Movie feature vectors
  w1_P1     = 0.1*randn(num_p, num_feat); % User feature vecators
  w1_M1_inc = zeros(num_m, num_feat);
  w1_P1_inc = zeros(num_p, num_feat);
  
  mean_rating = mean(warm(:, 3));
  
  fprintf('Splitting data into training and validation......\n');
  
  % Split rest of data into training and validation
  num_points = size(warm, 1);
  split_point = round(num_points * 0.7);
  seq = randperm(num_points);
  train_vec = warm(seq(1:split_point), :);
  probe_vec = warm(seq(split_point+1:end), :);
  pairs_tr = length(train_vec); % training data 
  pairs_pr = length(probe_vec); % validation data
  fprintf('Splitting data into training and validation...... COMPLETE\n');

end

%for f = 1:NUM_FILES
  epoch=1;
  
  fprintf('Starting training .......\n');

for epoch = epoch:maxepoch
  rr = randperm(pairs_tr);
  train_vec = train_vec(rr,:);
  clear rr 

  for batch = 1:numbatches
    fprintf(1,'epoch %d batch %d \r',epoch,batch);
    N=floor(size(train_vec, 1)/(numbatches)); %% number training triplets per batch = total data points / number of batches

    aa_p   = double(train_vec((batch-1)*N+1:batch*N,2));
    aa_m   = double(train_vec((batch-1)*N+1:batch*N,1)); %repmat(movie, size(aa_p, 1), 1); %
    rating = double(train_vec((batch-1)*N+1:batch*N,3));

    rating = rating-mean_rating; % Default prediction is the mean rating. 

    %%%%%%%%%%%%%% Compute Predictions %%%%%%%%%%%%%%%%%

    pred_out = sum(w1_M1(aa_m,:).*w1_P1(aa_p,:),2);
    %fo = sum( (pred_out - rating).^2 + ...
     %   0.5*lambda*( sum( (w1_M1(aa_m,:).^2 + w1_P1(aa_p,:).^2),2)));

    %%%%%%%%%%%%%% Compute Gradients %%%%%%%%%%%%%%%%%%%
    IO = repmat(2*(pred_out - rating),1,num_feat);
    Ix_m=IO.*w1_P1(aa_p,:) + lambda*w1_M1(aa_m,:);
    Ix_p=IO.*w1_M1(aa_m,:) + lambda*w1_P1(aa_p,:);

    dw1_M1 = zeros(num_m,num_feat);
    dw1_P1 = zeros(num_p,num_feat);

    for ii=1:N
      dw1_M1(aa_m(ii),:) =  dw1_M1(aa_m(ii),:) +  Ix_m(ii,:);
      dw1_P1(aa_p(ii),:) =  dw1_P1(aa_p(ii),:) +  Ix_p(ii,:);
    end

    %%%% Update movie and user features %%%%%%%%%%%

    w1_M1_inc = momentum*w1_M1_inc + epsilon*dw1_M1/N;
    w1_M1 =  w1_M1 - w1_M1_inc;

    w1_P1_inc = momentum*w1_P1_inc + epsilon*dw1_P1/N;
    w1_P1 =  w1_P1 - w1_P1_inc;
  end 
  
  epsilon = 0.998 * epsilon; % Update epsilon
  
  %%%%%%%%%%%%%% Compute Predictions after Parameter Updates %%%%%%%%%%%%%%%%%
  pred_out = sum(w1_M1(aa_m,:).*w1_P1(aa_p,:),2);
  f_s = sum( (pred_out - rating).^2 + ...
        0.5*lambda*( sum( (w1_M1(aa_m,:).^2 + w1_P1(aa_p,:).^2),2)));
  err_train(epoch) = sqrt(f_s/N);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% Compute predictions on the validation set %%%%%%%%%%%%%%%%%%%%%% 
  NN=pairs_pr;

  aa_p = double(probe_vec(:,2));
  aa_m = double(probe_vec(:,1)); %repmat(movie, size(aa_p, 1), 1); 
  rating = double(probe_vec(:,3));

  pred_out = sum(w1_M1(aa_m,:).*w1_P1(aa_p,:),2) + mean_rating;
  ff = find(pred_out>MAX_RATING); pred_out(ff)=MAX_RATING; % Clip predictions 
  ff = find(pred_out<MIN_RATING); pred_out(ff)=MIN_RATING;

  err_valid(epoch) = sqrt(sum((pred_out- rating).^2)/NN);
  fprintf(1, 'epoch %4i batch %4i Training RMSE %6.4f  Test RMSE %6.4f  with learning step %f\n', ...
              epoch, batch, err_train(epoch), err_valid(epoch), epsilon);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if (rem(epoch,10))==0
     %save pmf_weight w1_M1 w1_P1
	 %save('../../../../../../research/connections/data/recsys/w1_M1_20.mat', 'w1_M1')
	 %save('../../../../../../research/connections/data/recsys/w1_P1_20.mat', 'w1_P1')
	 
	 save(strcat(origdirec, '/w1_M1_', num2str(NUM_FACTORS), '.mat'), 'w1_M1')
	 save(strcat(origdirec, '/w1_P1_', num2str(NUM_FACTORS), '.mat'), 'w1_P1')
  end

end 

%end 

