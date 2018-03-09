function value=rosenbrock(x,nvar)
value=sum((100*(((x+nvar)-(x.^2))^2))+((x-1)^2));
end
