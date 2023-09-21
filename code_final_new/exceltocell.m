path='C:\\Promo\\von+Martina\\Outcome_SlipLines'
%%
file_list=dir(fullfile([path '\\**\\*.xlsx']))
%%
excel=readcell([file_list(1).folder, '\' , file_list(1).name],'ExpectedNumVariables',6,'NumHeaderLines',1)
% fnmae=excel(:,'Var1')