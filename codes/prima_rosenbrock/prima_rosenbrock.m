function results = prima_rosenbrock(dims)
    if nargin < 1 || isempty(dims)
        dims = 2:20;
    end

    dims = dims(:)';
    case_names = {'unconstrained', 'bound_constrained', ...
        'linearly_constrained', 'nonlinearly_constrained'};
    case_labels = {'Unconstrained', 'Bound constrained', ...
        'Linearly constrained', 'Nonlinearly constrained'};

    n_dims = numel(dims);
    fx_matrix = NaN(n_dims, numel(case_names));
    func_count_matrix = NaN(n_dims, numel(case_names));
    results = struct();

    for i_dim = 1:n_dims
        n = dims(i_dim);
        x0 = -ones(n, 1);
        fprintf('\n========== Dimension n = %d ==========\n', n);

        fprintf('\n========== Case 1: no constraints ==========\n');
        [x, fx, exitflag, output] = prima(@rosenbrock_eg, x0);
        [case_result, fx_matrix(i_dim, 1), func_count_matrix(i_dim, 1)] = ...
            pack_result(n, x, fx, exitflag, output);
        results.unconstrained(i_dim) = case_result;

        fprintf('\n========== Case 2: bound constraints ==========\n');
        fprintf('\nBound constraints: x <= 0\n');
        problem = struct();
        problem.objective = @rosenbrock_eg;
        problem.x0 = x0;
        problem.ub = zeros(n, 1);
        [x, fx, exitflag, output] = prima(problem);
        [case_result, fx_matrix(i_dim, 2), func_count_matrix(i_dim, 2)] = ...
            pack_result(n, x, fx, exitflag, output);
        results.bound_constrained(i_dim) = case_result;

        fprintf('\n========== Case 3: linear constraints ==========\n');
        fprintf('\nLinear constraints: sum(x) <= 1, x >= 0\n');
        problem = struct();
        problem.objective = @rosenbrock_eg;
        problem.x0 = x0;
        problem.lb = zeros(n, 1);
        problem.Aineq = ones(1, n);
        problem.bineq = 1;
        [x, fx, exitflag, output] = prima(problem);
        [case_result, fx_matrix(i_dim, 3), func_count_matrix(i_dim, 3)] = ...
            pack_result(n, x, fx, exitflag, output);
        results.linearly_constrained(i_dim) = case_result;

        fprintf('\n========== Case 4: nonlinear constraints ==========\n');
        fprintf('\nNonlinear constraints: sum(x^2) <= 1, x >= 0\n');
        problem = struct();
        problem.objective = @rosenbrock_eg;
        problem.x0 = x0;
        problem.lb = zeros(n, 1);
        problem.nonlcon = @nlc;
        [x, fx, exitflag, output] = prima(problem);
        [case_result, fx_matrix(i_dim, 4), func_count_matrix(i_dim, 4)] = ...
            pack_result(n, x, fx, exitflag, output);
        results.nonlinearly_constrained(i_dim) = case_result;
    end

    output_dir = fileparts(mfilename('fullpath'));
    result_file = fullfile(output_dir, 'prima_rosenbrock_results.mat');
    save(result_file, 'dims', 'case_names', 'case_labels', ...
        'results', 'fx_matrix', 'func_count_matrix');

    plot_comparison(dims, fx_matrix, case_labels, ...
        'Dimension', 'Final function value', ...
        'Final function value vs dimension', ...
        fullfile(output_dir, 'prima_rosenbrock_final_values.pdf'));

    plot_comparison(dims, func_count_matrix, case_labels, ...
        'Dimension', 'Number of function evaluations', ...
        'Function evaluations vs dimension', ...
        fullfile(output_dir, 'prima_rosenbrock_func_counts.pdf'));
end

function [result, fx_value, func_count] = pack_result(n, x, fx, exitflag, output)
    result = struct();
    result.n = n;
    result.x = x;
    result.fx = fx;
    result.exitflag = exitflag;
    result.output = output;

    fx_value = fx;
    func_count = NaN;
    if isstruct(output) && isfield(output, 'funcCount')
        func_count = output.funcCount;
    end
end

function f = rosenbrock_eg(x)
    f = sum((x(1:end-1) - 1).^2 + 4 * (x(2:end) - x(1:end-1).^2).^2);
end

function [cineq, ceq] = nlc(x)
    cineq = sum(x.^2) - 1;
    ceq = [];
end

function plot_comparison(dims, values, labels, x_label, y_label, title_text, output_file)
    figure_handle = figure('Visible', 'off');
    plot(dims, values, '-o', 'LineWidth', 1.2, 'MarkerSize', 4);
    grid on;
    xlabel(x_label);
    ylabel(y_label);
    title(title_text);
    legend(labels, 'Location', 'best');
    set(gca, 'XTick', dims);
    exportgraphics(figure_handle, output_file, 'ContentType', 'vector');
    close(figure_handle);
end
