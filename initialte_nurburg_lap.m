data='nurburg_data.xlsx'
sheet=1
nurburg_speed=xlsread(data,sheet,'E11:E844')
nurburg_lap=[xlsread(data,sheet,'D11:E844'),xlsread(data,sheet,'I11:I844')];
filename = 'nurburg_lap.mat';
save(filename);
