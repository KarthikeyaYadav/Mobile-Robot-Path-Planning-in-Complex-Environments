
clc;
clear;
close all;

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

%% DE Parameters
MaxIt = 3000;         % Maximum Number of Iterations

nPop=150;           % Population Size (Swarm Size)
       % Population Size
f = 0.5;  % Upper Bound of Scaling Factor

pCR=0.5;        % Crossover Probability

%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.Sol = [];
BestSol.Cost=inf;

pop=repmat(empty_individual,nPop,1);

for i=1:nPop

    if i > 1
        pop(i).Position=CreateRandomSolution(model);
    else
        % Straight line from source to destination
        xx = linspace(model.xs, model.xt, model.n+2);
        yy = linspace(model.ys, model.yt, model.n+2);
        pop(i).Position.x = xx(2:end-1);
        pop(i).Position.y = yy(2:end-1);
    end
    
   [ pop(i).Cost, pop(i).Sol ]=CostFunction(pop(i).Position);
    
    if pop(i).Cost<BestSol.Cost
        BestSol=pop(i);
    end
    
end

BestCost=zeros(MaxIt,1);

%% DE Main Loop

for it=1:MaxIt/2;
    
    for i=1:nPop
        
     target.x=pop(i).Position.x;
     target.y=pop(i).Position.y;
        
        A=randperm(nPop);
        
        A(A==i)=[];
        
        a=A(1);
        b=A(2);
        c=A(3);
        
        % Mutation
        %beta=unifrnd(beta_min,beta_max);
        noisy.x=pop(a).Position.x+f.*(pop(b).Position.x-pop(c).Position.x);
        noisy.x = max(noisy.x, VarMin.x);
		noisy.x = min(noisy.x, VarMax.x);
          
        A=randperm(nPop);
        
        A(A==i)=[];
        
        a=A(1);
        b=A(2);
        c=A(3);
        
        noisy.y=pop(a).Position.y+f.*(pop(b).Position.y-pop(c).Position.y);
        noisy.y = max(noisy.y, VarMin.y);
		noisy.y = min(noisy.y, VarMax.y);
        
        
		
        % Crossover
        z.x=zeros(size(target.x));z.y = zeros(size(target.y));
        jx=randi([1 numel(target.x)]);
        for j=1:numel(target.x)
            if j==jx || rand<=pCR
                z.x(j)=noisy.x(j);
               
            else
                z.x(j)=target.x(j);
            
            end
        end
        
         for jy=1:numel(target.y)
            if j==jy || rand<=pCR
                z.y(j)=noisy.y(j);
               
            else
                z.y(j)=target.y(j);
            
            end
        end
        
        NewSol.Position.x=z.x;
        NewSol.Position.y=z.y;

        
       [ NewSol.Cost, NewSol.Sol]=CostFunction(NewSol.Position);
        
        if NewSol.Cost<pop(i).Cost
            pop(i)=NewSol;
            
            if pop(i).Cost<BestSol.Cost
               BestSol=pop(i);
            end
        end
        
    end
    
    % Update Best Cost
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    if BestSol.Sol.IsFeasible
        Flag=' *';
    else
        Flag=[', Violation = ' num2str(BestSol.Sol.Violation)];
    end
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) Flag]);
    
    % Plot Solution
    figure(1);
    PlotSolution(BestSol.Sol,model); 
    pause(0.01);
    
end
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


%% Problem Definition





%% PSO Parameters

     % Population Size (Swarm Size)

w=1;                % Inertia Weight
wdamp=0.98;         % Inertia Weight Damping Ratio
c1=1.5;             % Personal Learning Coefficient
c2=1.5;             % Global Learning Coefficient

% % Constriction Coefficient
% phi1=2.05;
% phi2=2.05;
% phi=phi1+phi2;
% chi=2/(phi-2+sqrt(phi^2-4*phi));
% w=chi;               % Inertia Weight
% wdamp=1;             % Inertia Weight Damping Ratio
% c1=chi*phi1;         % Personal Learning Coefficient
% c2=chi*phi2;         % Global Learning Coefficient

alpha=0.1;
VelMax.x=alpha*(VarMax.x-VarMin.x);    % Maximum Velocity
VelMin.x=-VelMax.x;                    % Minimum Velocity
VelMax.y=alpha*(VarMax.y-VarMin.y);    % Maximum Velocity
VelMin.y=-VelMax.y;                    % Minimum Velocity

%% Initialization

% Create Empty Particle Structure
empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Sol=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.Sol=[];

% Initialize Global Be st
GlobalBest.Cost=inf;

% Create Particles Matrix
particle=repmat(empty_particle,nPop,1);
for i = 1:nPop
    particle(i).Position = pop(i).Position;
end

% Initialization Loop
for i=1:nPop
      
    % Initialize Position
    
    
    % Initialize Velocity
    particle(i).Velocity.x=zeros(VarSize);
    particle(i).Velocity.y=zeros(VarSize);
    
    % Evaluation
    [particle(i).Cost, particle(i).Sol]=CostFunction(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Sol=particle(i).Sol;
    
    % Update Global Best
    if particle(i).Best.Cost<GlobalBest.Cost
        
        GlobalBest=particle(i).Best;
        
    end
    
end

% Array to Hold Best Cost Values at Each Iteration


%% PSO Main Loop

for it=(MaxIt/2)+1 : MaxIt
    
    for i=1:nPop
        
        % x Part
        
        % Update Velocity
        particle(i).Velocity.x = w*particle(i).Velocity.x ...
            + c1*rand(VarSize).*(particle(i).Best.Position.x-particle(i).Position.x) ...
            + c2*rand(VarSize).*(GlobalBest.Position.x-particle(i).Position.x);
        
        % Update Velocity Bounds
        particle(i).Velocity.x = max(particle(i).Velocity.x,VelMin.x);
        particle(i).Velocity.x = min(particle(i).Velocity.x,VelMax.x);
        
        % Update Position
        particle(i).Position.x = particle(i).Position.x + particle(i).Velocity.x;
        
        % Velocity Mirroring
        OutOfTheRange=(particle(i).Position.x<VarMin.x | particle(i).Position.x>VarMax.x);
        particle(i).Velocity.x(OutOfTheRange)=-particle(i).Velocity.x(OutOfTheRange);
        
        % Update Position Bounds
        particle(i).Position.x = max(particle(i).Position.x,VarMin.x);
        particle(i).Position.x = min(particle(i).Position.x,VarMax.x);
        
        % y Part
        
        % Update Velocity
        particle(i).Velocity.y = w*particle(i).Velocity.y ...
            + c1*rand(VarSize).*(particle(i).Best.Position.y-particle(i).Position.y) ...
            + c2*rand(VarSize).*(GlobalBest.Position.y-particle(i).Position.y);
        
        % Update Velocity Bounds
        particle(i).Velocity.y = max(particle(i).Velocity.y,VelMin.y);
        particle(i).Velocity.y = min(particle(i).Velocity.y,VelMax.y);
        
        % Update Position
        particle(i).Position.y = particle(i).Position.y + particle(i).Velocity.y;
        
        % Velocity Mirroring
        OutOfTheRange=(particle(i).Position.y<VarMin.y | particle(i).Position.y>VarMax.y);
        particle(i).Velocity.y(OutOfTheRange)=-particle(i).Velocity.y(OutOfTheRange);
        
        % Update Position Bounds
        particle(i).Position.y = max(particle(i).Position.y,VarMin.y);
        particle(i).Position.y = min(particle(i).Position.y,VarMax.y);
        
        % Evaluation
        [particle(i).Cost, particle(i).Sol]=CostFunction(particle(i).Position);
        
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.Sol=particle(i).Sol;
            
            % Update Global Best
            if particle(i).Best.Cost<GlobalBest.Cost
                GlobalBest=particle(i).Best;
            end
            
        end
        
        
    end
    
    % Update Best Cost Ever Found
    BestCost(it)=GlobalBest.Cost;
    
    % Inertia Weight Damping
    w=w*wdamp;

    % Show Iteration Information
    if GlobalBest.Sol.IsFeasible
        Flag=' *';
    else
        Flag=[', Violation = ' num2str(GlobalBest.Sol.Violation)];
    end
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) Flag]);
    
    % Plot Solution
    figure(1);
    PlotSolution(GlobalBest.Sol,model); 
    pause(0.01);
    
end

%% Results

figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;



