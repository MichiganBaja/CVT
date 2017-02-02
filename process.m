
size = 10;
mat = load('data/set1.mat');
init = mat.set1;
data = init;
data(2) = init;


for i = 1:size
    filename = strcat(strcat('data/set' , int2str(i)), '.mat');
    mat = load(filename);
    data(i) = mat.(filename);
end
