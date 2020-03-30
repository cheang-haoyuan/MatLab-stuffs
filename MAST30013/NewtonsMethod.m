 % MatLab function m-file NewtonsMethod.m
 %
 % Performs Newton's method for single variable cases,
 % iteratively calculating the 1st and 2nd derivatives of
 % a point a in [a,b] to estimate the minimum point x*.
 %
 % written by Hao Yuan Cheang, 939873, Mar 2020
 % with reference to FibonacciSearch.m on LMS
 %
 % Input:
 %
 % objFunc (str): a single variable function that we are trying to minimise.
 %                Taken as the name of the m-file of the objective function.
 % a, b (num) : the lower and upper bounds of the initial search interval.
 % epln (num) : a positive number epsilon. the algorithm stops when either
 %             the 1st OR 2nd derivatives of x is less than epln.
 % init (num) : the initial point to start evaluating g(x) and g'(x)
 %
 % Output:
 %
 % minX_e : the estimated minimum of objFunc, x*
 % devX_e : the 1st derivative at x*.

 function [ minX_e, devX_e ] = NewtonsMethod( objFunc, a, b, epln, init )
    % NEWTONSMETHOD performs Newton's method
    %    objFunc: single var function we are minimising
    %          a: lower bound
    %          b: upper bound
    %       epln: positive number
    %       init: starting point for first estimate

    % error checking

    if (nargin ~= 5)
      error('insufficient input (5 needed).');

    end

    if (a >= b)
      error('need b > a.');

    end

    if ((init < a) || (init > b))
      error('initial point must be between [a, b]');

    end

    if (epln <= 0)
      error('epsilon needs to be > 0');

    end

    % functions
    syms x
    f = str2func(['@(x)', objFunc]);
    g = matlabFunction(diff(f(x)));
    dev_g = matlabFunction(diff(g(x)));
    a = init;

    % counters
    k = 0;
    n_dev_g = 0;

    while (dev_g(a) >= epln)
      n_dev_g = n_dev_g + 1;

      if (abs(g(a)) < epln)
        k = k + 1;

        fprintf('Iteration %d \na = %f \n', k, a);
        fprintf('g(a) = %f\ng"(a) = %f \n\n', g(a), dev_g(a));
        % fprintf('g-calculations: %d \ng"-calculations: %d\n\n', k, n_dev_g);

        minX_e = a;
        devX_e = g(a);

        fprintf('===============\nx* = %f \n', minX_e);
        fprintf('g(x*) = %f\n', devX_e);
        % fprintf('g-calculations: %d \ng"-calculations: %d\n\n', k, n_dev_g);

        break;

      end

      k = k + 1;
      
      fprintf('Iteration %d \na = %f \n', k, a);
      % fprintf('g-calculations: %d \ng"-calculations: %d\n\n', k, n_dev_g);
      fprintf('g(a) = %f\ng"(a) = %f \n\n', g(a), dev_g(a));

      a = a - (g(a)/dev_g(a));

    end

    if (dev_g(a) < epln)
      % the estimate is diverging away :(

      minX_e = NaN;
      devX_e = NaN;
      fprintf('g"(a) < epsilon but |g(a)| > epsilon, \n');
      fprintf('therefore the estimate is diverging. \n');
      fprintf('Try another initial point please :)');

    end

 end
