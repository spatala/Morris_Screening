function [y]=test_func(x)
   y(1)=x(1)+2*x(2)+x(3)+2*x(4)+x(3)^2*x(4);
   y(2)=(x(1)-x(2))*x(4);
end 
