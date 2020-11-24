function nn = vecnorm(V,power,dim)
nn = sqrt(sum(V.^power,dim));
end
