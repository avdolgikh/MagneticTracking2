% https://www.mathworks.com/matlabcentral/fileexchange/37004-suite-of-functions-to-perform-uniform-sampling-of-a-sphere

clear all;
clc;

[V,~,~,~] = ParticleSampleSphere('N',24);
    
figure('Name', 'Receivers', 'NumberTitle', 'off');
plot3(V(:,1), V(:,2), V(:,3), 'o');
set(gca,'DataAspectRatioMode','Manual');
grid on;
hold on;
axis equal;
