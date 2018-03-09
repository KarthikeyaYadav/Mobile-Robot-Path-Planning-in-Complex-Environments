%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA111
% Project Title: Implementation of TLBO in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

clc;
clear;
close all;
tic;

%% Problem Definition

model=CreateModel();

model.n=13;  % number of Handle Points

CostFunction=@(x) MyCost(x,model);    % Cost Function

nVar=model.n;       % Number of Decision Variables

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin.x=model.xmin;           % Lower Bound of Variables
VarMax.x=model.xmax;           % Upper Bound of Variables
VarMin.y=model.ymin;           % Lower Bound of Variables
VarMax.y=model.ymax;           % Upper Bound of Variables


%% TLBO Parameters

MaxIt = 1000;        % Maximum Number of Iterations

nPop = 150;           % Population Size
alpha=0.1;
VelMax.x=alpha*(VarMax.x-VarMin.x);    % Maximum Velocity
VelMin.x=-VelMax.x;                    % Minimum Velocity
VelMax.y=alpha*(VarMax.y-VarMin.y);    % Maximum Velocity
VelMin.y=-VelMax.y;                    % Minimum Velocity

%% Initialization 

% Empty Structure for Individuals
empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Sol=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.Sol=[];
 newsol = empty_particle;

% Initialize Population Array
particle= repmat(empty_particle, nPop, 1);

% Initialize Best Solution
BestSol.Cost = inf;

% Initialize Population Members
for i=1:nPop
      
    % Initialize Position
    if i > 1
        particle(i).Position=CreateRandomSolution(model);
    else
        % Straight line from source to destination
        xx = linspace(model.xs, model.xt, model.n+2);
        yy = linspace(model.ys, model.yt, model.n+2);
        particle(i).Position.x = xx(2:end-1);
        particle(i).Position.y = yy(2:end-1);
    end
    [particle(i).Cost, particle(i).Sol]=CostFunction(particle(i).Position);
     if particle(i).Cost < BestSol.Cost
        BestSol = particle(i);
     end
end


% Initialize Best Cost Record
BestCosts = zeros(MaxIt,1);

%% TLBO Main Loop

for it=1:MaxIt
    
    % Calculate Population Mean
    Mean.x = 0;
    for i=1:nPop
        Mean.x = Mean.x + particle(i).Position.x  ;
    end
    Mean.x = Mean.x/nPop;
    
    Mean.y= 0;
    for i=1:nPop
        Mean.y = Mean.x + particle(i).Position.y  ;
    end
    Mean.y = Mean.y/nPop;
    
    
    
    % Select Teacher
    Teacher = particle(1);
    for i=2:nPop
        if particle(i).Cost < Teacher.Cost
            Teacher = particle(i);
        end
    end
    
    % Teacher Phase
    for i=1:nPop
        % Create Empty Solution
       
        
        % Teaching Factor
        TF = randi([1 2]);
        
        % Teaching (moving towards teacher)
        newsol.Position.x = particle(i).Position.x ...
            + rand(VarSize).*(Teacher.Position.x - TF*Mean.x);
        newsol.Position.y= particle(i).Position.y ...
            + rand(VarSize).*(Teacher.Position.y - TF*Mean.y);
        
        % Clipping
        newsol.Position.x= max(newsol.Position.x, VarMin.x);
        newsol.Position.x = min(newsol.Position.x, VarMax.x);
         newsol.Position.y= max(newsol.Position.y, VarMin.y);
        newsol.Position.y = min(newsol.Position.y, VarMax.y);
        
        % Evaluation
        [newsol.Cost, newsol.Sol] = CostFunction(newsol.Position);
        
        % Comparision
        if newsol.Cost<particle(i).Cost
            particle(i) = newsol;
            if particle(i).Cost < BestSol.Cost
                BestSol = particle(i);
            end
        end
    end
    
    % Learner Phase
    for i=1:nPop
        
        A = 1:nPop;
        A(i)=[];
        j = A(randi(nPop-1));
        
        Step.x= particle(i).Position.x - particle(j).Position.x;
                Step.y= particle(i).Position.y - particle(j).Position.y;

        if particle(j).Cost < particle(i).Cost
            Step.x = -Step.x;
                        Step.y = -Step.y;

            
        end
        
        % Create Empty Solution
        
        
        % Teaching (moving towards teacher)
        newsol.Position.x = particle(i).Position.x + rand(VarSize).*Step.x;
         newsol.Position.y = particle(i).Position.y + rand(VarSize).*Step.y;

        
        
        % Clipping
        newsol.Position.x= max(newsol.Position.x, VarMin.x);
        newsol.Position.x = min(newsol.Position.x, VarMax.x);
         newsol.Position.y= max(newsol.Position.y, VarMin.y);
        newsol.Position.y = min(newsol.Position.y, VarMax.y);
        
        % Evaluation
        [newsol.Cost, newsol.Sol] = CostFunction(newsol.Position);
        
        % Comparision
        if newsol.Cost<particle(i).Cost
            particle(i) = newsol;
            if particle(i).Cost < BestSol.Cost
                BestSol = particle(i);
            end
        end
    end
    
    % Store Record for Current Iteration
    BestCosts(it) = BestSol.Cost;
    
    % Show Iteration Information
    if BestSol.Sol.IsFeasible
        Flag=' *';
    else
        Flag=[', Violation = ' num2str(BestSol.Sol.Violation)];
    end
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it)) Flag]);
    
    % Plot Solution
    figure(1);
    PlotSolution(BestSol.Sol,model); 
    pause(0.01);
    
end

%% Results


figure;
plot(BestCosts,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;