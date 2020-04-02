classdef a_periodic < handle
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  properties
    % control parameters
    num_Basis = 2;  % number of basis functions
    order     = 2;  % order, higher order, leads to closer fits, my lead to overfitting
    res       = 10; % resolution per basis function, # of pts output = res*num_Basis + 1
    
    % basis struct
    x   = []; % parameterizing term ofter time or index of observation
    M   = []; % basis funtion
    ind = []; % notch point indeces
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods
    %%%%%%%%%%%%%%%%%%%%%%%%% constructor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function obj = a_periodic( b_Spline_Func, debug)
      % b_Spline_Func is a struct
      if nargin > 0
        if nargin<2
          debug = 0;
        end
        process_Input(obj, b_Spline_Func, debug);
        clear b_Spline_Func debug
      end
    end
    
    function obj = process_Input(obj, b_Spline_Func, debug)
      if debug
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
      end
      
      
        % updating basis order
      if check_Properties(b_Spline_Func, 'order')
        obj.order = b_Spline_Func.order;
        if debug
          disp('Updated b-Spline order.')
        end
      end
      
      % updating number of basis functions
      if check_Properties(b_Spline_Func, 'num_Basis')
        obj.num_Basis = max(b_Spline_Func.num_Basis, ...
          b_Spline_Func.order+1);
        if debug
          disp('Updated number of basis.')
        end
      end
      
      
      % updating basis resolution
      if check_Properties(b_Spline_Func, 'res')
        obj.res = 2*floor(b_Spline_Func.res/2); % ensure resolution is even
        if debug
          disp('Updated b-Spline resolution, remember # of samples, is 1+res*num_Basis.')
        end
      end
      
      % construct updated basis functions
      [obj.x, obj.M, obj.ind] = obj.setup_Signal_ap(obj.num_Basis, obj.order, obj.res, debug);
      if debug
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
      end
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%% private functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods (Static)
    
    %  basis generator aperiodic b-spline function
    function [x, M, t_ind] = setup_Signal_ap(num_Basis, order, res, debug)
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % res: resolution
      % num_Basis: number of basis functions
      % order: order
      % debug: toggle for debug display
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      order = order+1; % order + 1
      t_ind= []; % placeholder
      count = 0; % instantiate count
      
      % construct basis function indexing
      for  m = 0:num_Basis-1
        if m<order
          t_ind = [t_ind 0];
          count = count + 1;
        elseif (order<=m) && (m<=num_Basis)
          t_ind = [t_ind m-order+1];
        end
      end
      t_ind = [t_ind repmat(num_Basis-order+1,[1,count])];
      
      % non-normalized parameterized t
      x = linspace(t_ind(1), t_ind(end), (num_Basis)*res+1);
      
      % basis function generation
      M = zeros(num_Basis, length(x));
      for m = 1:length(t_ind)-order
        % basis construction
        M(m,:) = b_spline_func(t_ind, order, res, m, x);
      end
      
      % figure display
      if debug
        figure(1)
        for m = 1:size(M,1)
          plot(x,M(m,:))
          if m == 1
            hold on
          end
        end
        plot(x,sum(M,1),'r') % convex hull property
        
        hold off
        title 'basis funcs'
        
        
        figure(2)
        x_Dom = linspace(0, 1, 1+size(M,2));
        x_Dom(end) = [];
        for m = 1:size(M,1)
          subplot(size(M,1),1,m)
          plot(x_Dom, M(m,:))
          axis tight
        end
      end
      
      % normalize x index
      x = x/max(t_ind);
    end
    
    
  end
end
