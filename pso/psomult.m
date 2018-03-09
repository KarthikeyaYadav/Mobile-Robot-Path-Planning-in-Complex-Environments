clc;
clear all;
close all;
%%problem definition
costfunction=@(x) spheree(x);
nvar=5;
varsize=[1,nvar];
varmin=-10;
varmax=10;
VelMax=0.1*(varmax-varmin);
VelMin=-VelMax;

%%parameters of algorithm
maxit=100;
npop=50;
w=1;
wdamp=0.99;
c1=2;
c2=2;
%%initialization
empty_particle.position=[];
empty_particle.velocity=[];
empty_particle.cost=[];
empty_particle.best.position=[];
empty_particle.best.cost=[];
partcle=repmat(empty_particle,npop,1);
%inititalize global best
globalbest.cost=inf;
for i=1:npop
particle(i).position=unifrnd(varmin,varmax,varsize);
particle(i).velocity=zeros(varsize);
particle(i).cost=costfunction(particle(i).position);
particle(i).best.position=particle(i).position;
particle(i).best.cost=particle(i).cost;
if particle(i).best.cost<globalbest.cost
    globalbest=particle(i).best;
end
end
bestcosts=zeros(maxit,1);
%%main loop of pso
for it=1:maxit
    for i=1:npop
        particle(i).velocity=(w*particle(i).velocity)+(c1*(rand(varsize)).*(particle(i).best.position-particle(i).position))+(c2*rand(varsize).*(globalbest.position-particle(i).position));
        particle(i).velocity = max(particle(i).velocity,VelMin);
        particle(i).velocity = min(particle(i).velocity,VelMax);
        
        particle(i).positon=particle(i).position+particle(i).velocity;
        % Velocity Mirror Effect
        IsOutside=(particle(i).position<varmin | particle(i).position>varmax);
        particle(i).velocity(IsOutside)=-particle(i).velocity(IsOutside);
        
        particle(i).cost=costfunction(particle(i).position);
        if particle(i).cost<particle(i).best.cost
            particle(i).best.position=particle(i).position;
            particle(i).best.cost=particle(i).cost;
            if particle(i).best.cost<globalbest.cost
                globalbest=particle(i).best;
            end
        end
    end
    bestcost(it)=globalbest.cost;
    disp(['iteration', num2str(it), ':bestcost', num2str(bestcost(it))]);
    w=w*wdamp;
end

%%results
semilogx(bestcosts,'linewidth',2);
xlabel('iteration');
ylabel('bestcost');
grid on;