classdef a_periodic_approx < handle
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  properties
    % control parameters
    num_Basis = 2;  % number of basis functions
    order     = 2;  % order, higher order, leads to closer fits, my lead to overfitting
    res       = 10; % resolution per basis function, # of pts output = res*num_Basis + 1
    extra     = 0;  % additional basis functions concatinated to the end
    
    % basis struct
    x   = []; % parameterizing term ofter time or index of observation
    M   = []; % basis funtion
    ind = []; % notch point indeces
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods
    %%%%%%%%%%%%%%%%%%%%%%%%% constructor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function obj = a_periodic_approx( b_Spline_Func, debug)
      if nargin<2
        debug = 0 ;
      end
      % b_Spline_Func is a struct
      if nargin > 0
        process_Input(obj, b_Spline_Func, debug);
        clear b_Spline_Func debug
      end
    end
    
    function obj = process_Input(obj, b_Spline_Func, debug)
      if nargin<3
        debug = 0 ;
      end
      
      if debug
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
      end
      
      % updating number of basis functions
      if check_Properties(b_Spline_Func, 'num_Basis')
        obj.num_Basis = b_Spline_Func.num_Basis;
        if debug
          disp('Updated number of basis.')
        end
      end
      
      % updating basis order
      if check_Properties(b_Spline_Func, 'order')
        obj.order = b_Spline_Func.order;
        if debug
          disp('Updated b-Spline order.')
        end
      end
      
      
      % updating basis order
      if check_Properties(b_Spline_Func, 'extra')
        obj.extra= b_Spline_Func.extra;
        if debug
          disp('Updated b-Spline extra.')
        end
      end
      
      % updating basis resolution
      if check_Properties(b_Spline_Func, 'res')
        obj.res = b_Spline_Func.res;
        if debug
          disp('Updated b-Spline resolution, remember # of samples, is 1+res*num_Basis.')
        end
      end
      
      % construct updated basis functions
      [obj.x, obj.M, obj.ind] = obj.setup_Signal(obj.num_Basis, obj.order, obj.extra, obj.res, debug);
      if debug
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
      end
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%% private functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods (Static)
    
    %  basis generator periodic b-spline function
    function [x_p, M, ind_Real] = setup_Signal(num_Basis, order, extra, res, debug)
      order = order + 1;
      % real index
      ind_Real = (0:(num_Basis+order+1+extra))/num_Basis ;
      t_ind = 0:order+1;  % t_i
      
      % basis construction
      [y,t] = b_spline_func(t_ind, order, res);
      
      %center shift
      t =  t - (order+1+extra)/2;
      
      % indexings
      N = floor((length(t)-1)*(num_Basis+order+1+extra)/(order+1));
      x_p = linspace(0, num_Basis+order+1+extra, N+1);
      x_p(end) = [];
      y_p = zeros(size(x_p));
      y_p(1:length(find(t>=0))) = y(t>=0);
      y_p(end-length(find(t<0))+1:end) = y(t<0);
      
      % construction of circular
      M = zeros(num_Basis+order+1, length(x_p));
      for m = 1:num_Basis+order+1+extra
        M(m,:) = [y_p(1,end-((m-1)*res-1):end)...
          y_p(1,1:(end-((m-1)*res)))];
      end
      
      
      % shift the basis
      M = [M(:,find(x_p <= .5, 1, 'last'):end) ...
        M(:,1:(find(x_p <= .5, 1, 'last')-1)) ];
      %             M(:,end) = M(:,1);
      
      % figure display
      if  debug
        figure(1)
        for m = 1:size(M,1)
          plot(x_p,M(m,:))
          if m == 1
            hold on
          end
        end
        plot(x_p,sum(M,1),'r') % convex hull property
        stem([0 num_Basis],[1 1])
        axis tight
        hold off
        axis equal
        title 'Basis Representation'
      end
      
      % normalize x index
      M(:,end+1) = M(:,1);
      x_p(end+1) = num_Basis+order+1+extra;
      x_p = x_p/(num_Basis);
    end
    
    
  end
end
