function [ receivers ] = BuildReceiversCoordinates( radius , number )

if (number < 6)
    error('"number" must be a positive interger greater than 5.');
end

if (number == 6)
    
    normal_position = ... 
    [ 1, 0, 0;
      0, 0, 1;
      -1, 0, 0;
      0, 0, -1;
      0, 1, 0;
      0, -1, 0];
  
elseif (number < 10)
    
    [normal_position,~,~,~] = ParticleSampleSphere('N', 10); 
    
    shufle_rowInd = randperm( 10 );
    normal_position = normal_position( shufle_rowInd( 1 : number), :);
    
else
    
    [normal_position,~,~,~] = ParticleSampleSphere('N', number);    

end

position = normal_position * radius;

orientation = rand(number, 2) * pi;

receivers = [position'; orientation']';

%{
figure('Name', 'Receivers', 'NumberTitle', 'off');
plot3(receivers(:, 1), receivers(:, 2), receivers(:, 3), 'o');
grid on;
hold on;
axis equal;
%}
  
end

