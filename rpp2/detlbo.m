
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
MaxIt = 200;         % Maximum Number of Iterations

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

for it=1:MaxIt/2
    
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
   particle(i).Position.x = pop(i).Position.x;
   particle(i).Position.y = pop(i).Position.y;
   
    [particle(i).Cost, particle(i).Sol]=CostFunction(particle(i).Position);
     if particle(i).Cost < BestSol.Cost
        BestSol = particle(i);
     end
end


% Initialize Best Cost Record
BestCosts = zeros(MaxIt,1);

%% TLBO Main Loop

for it=(MaxIt/2)+1 : MaxIt
    
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