function [d_train, P_train, d_val, P_val, d_test, P_test] = get_sets(d,P,d0,P0)
% Randomize the data 
idx = randperm(length(d));
            
d = d(idx);
P = P(idx);
            
% Data sets' sizes
train_end = ceil(0.7 * length(d));
val_end = ceil(0.85 * length(d));
             
% Training Data 
d_train = [d(1:train_end); d0];       
P_train = [P(1:train_end); P0];
                    
% Validation Data
d_val = [d(train_end + 1:val_end); d0];
P_val = [P(train_end + 1:val_end); P0];                   
      
% Test Data 
d_test = d(val_end + 1:end);        
P_test = P(val_end + 1:end);
            
end