

for i=1:62
    
    Y = hackathon_ode(xmat(i,:));
    file = sprintf('output/Y_%d',i);
    dlmwrite(file, Y);
    disp i
end