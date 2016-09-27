function L = logistic_fun(beta,x)


L = beta(1)*(0.5-1./(1+exp(beta(2)*(x-beta(3))))) + beta(4)*x+beta(5);


%%
