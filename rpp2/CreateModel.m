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

function model=CreateModel()

    % Source
    xs=0;
    ys=0;
    
    % Target (Destination)
    xt=10;
    yt=10;
    
    xobs=[1.5 4.0 1.2 5.5  7 7.5 4.5 8.5  0.5 1.5 2.5 3.5];
    yobs=[4.5 3.0 1.5 7.5  3 7.5 6   5.5 8.5 8.5 8.5 8.5];
    robs=[1.5 1.0 0.8 sqrt(2)/2  sqrt(1) sqrt(2)/2 sqrt(1.25)  sqrt(2)/2 sqrt(2)/2 sqrt(2)/2 sqrt(2)/2 sqrt(2)/2];
    
    n=12;
    
    xmin=0;
    xmax= 10;
    
    ymin=0;
    ymax= 10;
    
    model.xs=xs;
    model.ys=ys;
    model.xt=xt;
    model.yt=yt;
    model.xobs=xobs;
    model.yobs=yobs;
    model.robs=robs;
    model.n=n;
    model.xmin=xmin;
    model.xmax=xmax;
    model.ymin=ymin;
    model.ymax=ymax;
    
end