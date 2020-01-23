function plotpotential(range)
        x=0:0.02:range(1);
        y=0:0.02:range(2);
	n=length(x);
	m=length(y);
        [xx yy]=meshgrid(x,y);
        E=potential(xx, yy);
       
        figure;
        contourf(xx,yy,E,10,'LineColor','none');
	colormap(jet)
           
end
