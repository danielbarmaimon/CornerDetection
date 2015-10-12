clear all;
clc;
im = imread('chessboard04.png');
im_orig = im;
if size(im,3)>1 
    im=rgb2gray(im); 
end
% Derivative masks
dx = [-1 0 1;
-1 0 1;
-1 0 1];
dy = dx';
% Image derivatives
Ix = conv2(double(im), dx, 'same');
Iy = conv2(double(im), dy, 'same');
sigma=2;
% Generate Gaussian filter of size 9x9 and std. dev. sigma.
g = fspecial('gaussian',9, sigma);
% Smoothed squared image derivatives
Ix2 = conv2(Ix.^2, g, 'same');
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');

%Part 1 - 
[n,m]=size(im);
Aux =ones(3); 
Ix2w = conv2(Ix2, Aux, 'same'); % Getting summatory of elements
Iy2w = conv2(Iy2, Aux, 'same'); % using the matrix and a 3x3
Ixyw = conv2(Ixy, Aux, 'same'); % mask of ones
E = zeros(n,m);
tic;
for i=1:n
    for j=1:m
       M = [Ix2w(i,j) Ixyw(i,j);
            Ixyw(i,j) Iy2w(i,j)];
       eigenvalues = eig(M);
       E(i,j)= min(eigenvalues);
    end
end
hold on;
time1 = toc;
subplot(1,2,1);
imshow(mat2gray(E));
title('Using matrix E');
hold on;
%Part 2 - 
R = zeros(n,m);
k = 0.04;
tic;
R = ((Ix2w.*Iy2w)-(Ixyw.*Ixyw)) - k*(Ix2w+Iy2w).^2;
time2 = toc;
subplot(1,2,2);
imshow(mat2gray(R));
title('Using matrix R');
% % Part 3 - 
vector = reshape(E,1,n*m);
[sortedValues,sortIndex] = sort(vector(:),'descend');  %# Sort the values in  descending order
maxIndex = sortIndex(1:81)  %# Get a linear index into 'vector' of the 81 largest values

[positionsC, positionsR]=ind2sub([n,m],maxIndex);
hold on;
subplot(1,2,1);
plot(positionsC,positionsR, 'r+','MarkerSize', 4);
hold on;

vector2 = reshape(R,1,n*m);
[sortedValues2,sortIndex2] = sort(vector2(:),'descend');  %# Sort the values in  descending order
maxIndex2 = sortIndex2(1:81)  %# Get a linear index into 'vector' of the 81 largest values

[positionsC2, positionsR2]=ind2sub([n,m],maxIndex2);
hold on;
subplot(1,2,2);
plot(positionsC2,positionsR2, 'g+','MarkerSize', 4);
hold on;

% % Part 4 -
points1 = nonMaxSuppression(E,sortedValues,n, m, 11);
points2 = nonMaxSuppression(R,sortedValues2,n, m, 11);
figure;
subplot(1,2,1)
imshow(im);
hold on;
scatter(points1(1,:), points1(2,:), 'r+');
title('Edge detection (E)');
subplot(1,2,2)
imshow(im);
hold on;
scatter(points2(1,:), points2(2,:), 'g+');
title('Edge detection (R)');



%% RPRADOS@EIA.UDG:EDU LAB 0.24
