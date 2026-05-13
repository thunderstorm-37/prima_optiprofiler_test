function prima_rosenbrock(n)
    x0=-1*ones(n,1);
    % init point: x_0 = (-1, -1,..., -1)

    
    fprintf('\n==========Case 1: no constraints==========\n')
    [x_no_constraints,fx_no_constraints,exitflag_no_constraints,output_no_constraints] = prima(@rosenbrock_eg,x0)

    fprintf('\n==========Case 2: bound constraints==========\n')
    fprintf('\nBound constraints: x <=0 \n')
    % x <= 0
    % lb = Inf, ub = (0, 0,..., 0)
    lb=zeros(n,1);
    ub=zeros(n,1);
    problem_bound=struct();
    problem_bound.objective=@rosenbrock_eg;
    problem_bound.x0=x0;
    %problem_bound.lb=lb;
    problem_bound.ub=ub;
    [x_bound,fx_bound,exitflag_bound,output_bound]=prima(problem_bound)

    fprintf('\n==========Case 3: linear constraints==========\n ')
    fprintf('\nLinear constraints: sum(x) <= 1, x >= 0\n')
    % sum(x) <= 1, x >= 0
    % lb = Inf, ub = (0, 0,..., 0) 
    % Alineq = (1, 1,..., 1), Blineq = 1

    problem_linear=struct();
    problem_linear.objective=@rosenbrock_eg;
    problem_linear.x0=x0;
    problem_linear.lb=zeros(n,1);
    problem_linear.Aineq=ones(1,n);
    problem_linear.bineq=ones(1,1);
    [x_linear,fx_linear,exitflag_linear,output_linear]=prima(problem_linear)

    fprintf('\n==========Case 4: nonlinear constraints========== ')
    fprintf('\nNonlinear constraints: sum(x^2) <= 1, x >= 0\n')
    % sum(x^2) <= 1, x >= 0
    % lb = Inf, ub = (0, 0,..., 0)
    % cineq = x^2 - 1 
    problem_nonlinear=struct();
    problem_nonlinear.objective=@rosenbrock_eg;
    problem_nonlinear.x0=x0;
    problem_nonlinear.lb=lb;
    problem_nonlinear.nonlcon=@nlc;
    [x_nonlinear,fx_nonlinear,exitflag_nonlinear,output_nonlinear]=prima(problem_nonlinear)

        save(fullfile(fileparts(mfilename('fullpath')), 'prima_rosenbrock_results.mat'), ...
        'n', ...
        'x_no_constraints', 'fx_no_constraints', 'exitflag_no_constraints', 'output_no_constraints', ...
        'x_bound', 'fx_bound', 'exitflag_bound', 'output_bound', ...
        'x_linear', 'fx_linear', 'exitflag_linear', 'output_linear', ...
        'x_nonlinear', 'fx_nonlinear', 'exitflag_nonlinear', 'output_nonlinear');


return

function f=rosenbrock_eg(x)   % calculating the value of the Rosenbrock function
    f = sum((x(1:end-1)-1).^2 + 4*(x(2:end)-x(1:end-1).^2).^2);
return

function [cineq,ceq] = nlc(x)  % the subroutine defining the nonlinear constraints
% The same as fmincon, nonlinear constraints cineq(x) <= 0 and ceq(x) = 0 are specified
% by a function with two returns, the first being cineq and the second being ceq.
%cineq=x'*x-1;
cineq=sum(x.^2)-1;
ceq=[];
return


