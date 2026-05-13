function scores = test1()
%TEST1 benchmarks PRIMA double precision against PRIMA single precision.
%
% This test uses problem types 'ubln', dimensions 2--20, and runs the
% 'plain' and 'noisy' features separately.

    fprintf('\nThis test benchmarks PRIMA with double and single precision on plain and noisy problems.\n');
    pause(1.5);
    fprintf('\nStart Test 1...\n\n');

    add_prima_path();

    solvers = {@prima_double, @prima_single};

    base_options.solver_names = {'prima_double', 'prima_single'};
    base_options.solver_isrand = [false, false];
    base_options.ptype = 'ubln';
    base_options.mindim = 2;
    base_options.maxdim = 20;
    base_options.max_eval_factor = 500;
    base_options.benchmark_id = 'out';
    %base_options.n_jobs = 4;
    %base_options.max_tol_order = 6;

    feature_names = {'plain', 'noisy'};
    scores = cell(1, numel(feature_names));

    for i_feature = 1:numel(feature_names)
        options = base_options;
        options.feature_name = feature_names{i_feature};
        options.feature_stamp = options.feature_name;

        if strcmp(options.feature_name, 'noisy')
            options.n_runs = 3;
        else
            options.n_runs = 1;
        end

        fprintf('\nRunning feature: %s\n\n', options.feature_name);
        scores{i_feature} = benchmark(solvers, options);
    end

    merge_test1_summary(fullfile(pwd, base_options.benchmark_id), feature_names);
end

function add_prima_path()
    prima_interfaces = fullfile(getenv('HOME'), 'github_repo', 'prima', 'matlab', 'interfaces');

    if exist(fullfile(prima_interfaces, 'prima.m'), 'file')
        addpath(prima_interfaces);
    elseif exist('prima', 'file') ~= 2
        error('test1:PrimaNotFound', ...
            'PRIMA was not found. Please add PRIMA to the MATLAB path first.');
    end
end

function x = prima_double(varargin)
    x = prima_with_precision('double', varargin{:});
end

function x = prima_single(varargin)
    x = prima_with_precision('single', varargin{:});
end

function x = prima_with_precision(precision, varargin)
    options = struct();
    options.precision = precision;
    options.quiet = true;
    options.iprint = 0;

    switch numel(varargin)
        case 2
            fun = varargin{1};
            x0 = varargin{2};
            x = prima(fun, x0, options);

        case 4
            fun = varargin{1};
            x0 = varargin{2};
            xl = varargin{3};
            xu = varargin{4};
            x = prima(fun, x0, [], [], [], [], xl, xu, [], options);

        case 8
            fun = varargin{1};
            x0 = varargin{2};
            xl = varargin{3};
            xu = varargin{4};
            aub = varargin{5};
            bub = varargin{6};
            aeq = varargin{7};
            beq = varargin{8};
            x = prima(fun, x0, aub, bub, aeq, beq, xl, xu, [], options);

        case 10
            fun = varargin{1};
            x0 = varargin{2};
            xl = varargin{3};
            xu = varargin{4};
            aub = varargin{5};
            bub = varargin{6};
            aeq = varargin{7};
            beq = varargin{8};
            cub = varargin{9};
            ceq = varargin{10};
            nonlcon = @(x) deal(cub(x), ceq(x));
            x = prima(fun, x0, aub, bub, aeq, beq, xl, xu, nonlcon, options);

        otherwise
            error('test1:InvalidSolverInput', ...
                'Unexpected number of solver inputs: %d.', numel(varargin));
    end
end

function merge_test1_summary(path_out, feature_names)
    if ~exist(path_out, 'dir')
        return
    end

    summary_files = {};
    for i_feature = 1:numel(feature_names)
        feature_name = feature_names{i_feature};
        files = dir(fullfile(path_out, '*', sprintf('summary_*_%s_*.pdf', feature_name)));
        if isempty(files)
            warning('test1:SummaryNotFound', ...
                'No summary PDF found for feature "%s" under %s.', feature_name, path_out);
            continue
        end

        time_stamps = arrayfun(@(f) datetime(f.name(end-18:end-4), ...
            'InputFormat', 'yyyyMMdd_HHmmss'), files);
        [~, idx] = max(time_stamps);
        summary_files{end+1} = fullfile(files(idx).folder, files(idx).name);
    end

    if isempty(summary_files)
        return
    end

    output_file = fullfile(path_out, 'summary.pdf');
    tmp_file = fullfile(path_out, sprintf('summary_tmp_%s.pdf', ...
        char(datetime('now', 'Format', 'yyyyMMdd_HHmmss'))));

    try
        mem_set = org.apache.pdfbox.io.MemoryUsageSetting.setupMainMemoryOnly();
        merger = org.apache.pdfbox.multipdf.PDFMergerUtility;
        cellfun(@(f) merger.addSource(f), summary_files);
        merger.setDestinationFileName(tmp_file);
        merger.mergeDocuments(mem_set);

        if exist(output_file, 'file')
            delete(output_file);
        end
        movefile(tmp_file, output_file);
        fprintf('\nMerged %d summary PDF files into %s.\n', numel(summary_files), output_file);
    catch exception
        if exist(tmp_file, 'file')
            delete(tmp_file);
        end
        warning('test1:SummaryMergeFailed', ...
            'Failed to merge summary PDF files into %s: %s', output_file, exception.message);
    end
end
