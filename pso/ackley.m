function value = ackley(x,nvar)
value=-20*(exp(-0.2*(sqrt(sum(x.^2))/nvar)))-exp((sum(cos(2*pi*x)))/nvar)+20+exp(1);
end