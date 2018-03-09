%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPAP115
% Project Title: Path Planning using PSO in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function PlotSolution(sol,model)

    xs=model.xs;
    ys=model.ys;
    xt=model.xt;
    yt=model.yt;
    xobs=model.xobs;
    yobs=model.yobs;
    robs=model.robs;
    
    XS=sol.XS;
    YS=sol.YS;
    xx=sol.xx;
    yy=sol.yy;
    
    theta=linspace(0,2*pi,100);
    for k=1:3
        fill(xobs(k)+robs(k)*cos(theta),yobs(k)+robs(k)*sin(theta),[0.5 0.7 0.4],'facecolor','b');
        hold on;
     end
%       
%     rectangle('position' ,[5, 7, 1, 1]);
%     rectangle('position', [6, 4, 1 ,1]);
%     rectangle('position' ,[7, 7, 1, 1]);
v = [5 7;6 7;6 8;5 8;7 7;8 7;8 8;7 8;0 8;4 8;4 9;0 9;7 2;8 3;7 4;6 3];
f = [1 2 3 4;
    5 6 7 8;
    9 10 11 12;
    13 14 15 16
   ];
patch('vertices',v,'faces',f,'facecolor','red');
v1 = [4 5 4];
v2 = [5 5 7];
patch(v1,v2,'r');
% v1 = [4 6 6];
% v2 = [0 0 2];
% patch(v1,v2,'r');

  
 
    plot(xx,yy,'k','LineWidth',2);
   
    plot(xs,ys,'bs','MarkerSize',12,'MarkerFaceColor','y');
    plot(xt,yt,'kp','MarkerSize',16,'MarkerFaceColor','g');
    hold off;
    grid on;

end