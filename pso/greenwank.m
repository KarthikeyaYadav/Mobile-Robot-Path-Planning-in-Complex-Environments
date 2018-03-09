function value=greenwank(x,nvar)
value=(1/4000*(sum(x.^2)))-prod(cos((x)/(sqrt(nvar))))+1;
end
