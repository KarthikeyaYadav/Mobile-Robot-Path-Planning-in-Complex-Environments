
clc;
clear;
close all;

%% Problem Definition

model=CreateModel();

model.n=13 ;  % number of Handle Points

CostFunction=@(x) MyCost(x,model);    % Cost Function

nVar=model.n;       % Number of Decision Variables

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin.x=model.xmin;           % Lower Bound of Variables
VarMax.x=model.xmax;           % Upper Bound of Variables
VarMin.y=model.ymin;           % Lower Bound of Variables
VarMax.y=model.ymax;           % Upper Bound of Variables

%% DE Parameters
MaxIt = 1000;         % Maximum Number of Iterations

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

for it=1:MaxIt
    
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
                 z.x(j)=max(noisy.x(j),VarMin.x);
                 z.x(j) = min(noisy.x(j),VarMax.x);
               
            else
                z.x(j)=target.x(j);
            
            end
        end
        
         for jy=1:numel(target.y)
            if j==jy || rand<=pCR
                z.y(j)=noisy.y(j);
                 z.y(j)=max(noisy.y(j),VarMin.y);
                 z.y(j) = min(noisy.y(j),VarMax.y);
               
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

%% Show Results

figure;
%plot(BestCost);
semilogy(BestCost, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
