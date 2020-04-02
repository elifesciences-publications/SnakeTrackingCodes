classdef b_Splines_Class < handle
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  properties
    % control parameters
    num_Basis = 2;           % number of basis functions
    type = 'a-periodic';     % b-spline type, periodic, a-periodic, or a-periodic approx
    order = 2;               % order, higher order, leads to closer fits, my lead to overfitting
    res = 10;                % resolution per basis function, # of pts output = res*num_Basis + 1
    extra = 0;
    init_Flag = 1;
    
    % b-spline blocks
    b_spline = a_periodic(); % parametric basis
    basis_Eval = [];         % basis approx
    basis_Coeff = [];        % basis approx
    num_Basis_Act = [];
    
    % inherent parameters
    reg_Term = [];           % regulariztion penalty (can be vector = rows or scalar)
    reg_Matrix = [];
    states = [1 1];          % can represent any number of states, rows: states
    
    % columns: observations of state being interpolated
    weight = eye(2);
    num_States = 1;          % number of states
    num_Obs = 2;             % number of division basis region is divided into = states column
    
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods
    %%%%%%%%%%%%%%%%%%%%%%%%% constructor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function obj = b_Splines_Class(b_Spline_Func, debug)
      if nargin<2
        debug = 0;
      end
      % b_Spline_Func is a struct
      if nargin > 0
        obj.process_Input(b_Spline_Func, debug);
        clear b_Spline_Func debug
      else
        obj.update_B_Func(obj, debug);
      end
      obj.init_Flag = 0;
    end
    
    % process input
    function  process_Input(obj, b_Spline_Func, debug)
      if nargin < 3
        debug = 0;
      end
      
      if debug
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
      end
      % create flags
      flag_Infra = 0;
      flag_Extern = 0;
      tag_Basis = 0;
      
      % updating number of basis type
      if check_Properties( b_Spline_Func, 'type')
        flag_Infra = 1;
        obj.type = b_Spline_Func.type;
        if debug
          disp('Updated b-Spline type.')
        end
      end
      
      % updating number of basis functions
      if check_Properties( b_Spline_Func, 'num_Basis')
        flag_Infra = 1;
        
        sts = obj.num_Basis;
        
        obj.num_Basis = b_Spline_Func.num_Basis;
        
        if sts == obj.num_Basis && ~obj.init_Flag;
          tag_Basis = 0;
        else
          tag_Basis = 1;
        end
        
        if debug
          disp('Updated number of basis.')
        end
      end
      
      % updating basis order
      if check_Properties( b_Spline_Func, 'order')
        flag_Infra = 1;
        obj.order = b_Spline_Func.order;
        if debug
          disp('Updated b-Spline order.')
        end
      end
      
      % updating basis resolution
      if check_Properties( b_Spline_Func, 'res')
        flag_Infra = 1;
        obj.res = b_Spline_Func.res;
        if debug
          disp('Updated b-Spline resolution, remember # of samples, is 1+res*num_Basis.')
        end
      end
      
      % updating basis order
      if check_Properties( b_Spline_Func, 'states')
        flag_Extern = 1;
        obj.states     = b_Spline_Func.states;
        
        obs = obj.num_Obs;
        [obj.num_States, obj.num_Obs]    = size(obj.states);
        
        %                 if obs == obj.num_Obs && ~obj.init_Flag;
        %                     tag_Obs = 0;
        %                 else
        %                     tag_Obs = 1;
        %                 end
        
        if debug
          disp('Updated b-Spline states,observations, and div.')
        end
      end
      
      % updating basis regularization term
      if check_Properties( b_Spline_Func, 'reg_Term')
        flag_Extern = 1;
        obj.reg_Term = b_Spline_Func.reg_Term;
        
        if debug
          disp('Updated b-Spline regularization term.')
        end
      end
      
      % updating weights
      if check_Properties( b_Spline_Func, 'weight')
        
        flag_Extern = 1;
        
        if size(obj.weight,1) == obj.num_Obs
          if size(b_Spline_Func.weight,1) == size(b_Spline_Func.weight,2)
            obj.weight = b_Spline_Func.weight;
          else
            obj.weight = diag(b_Spline_Func.weight.^-1);
          end
        else
          obj.weight = eye(obj.num_Obs);
        end
        
        if debug
          disp('Updated b-Spline weights term.')
        end
      else
        obj.weight = 1;
      end
      
      
      % apply safety smoothing term
      if strcmp( obj.type, 'a-periodic-approx')
        if isempty(obj.reg_Term)
          obj.reg_Term = .0001;
          if debug
            disp('placing back up reg term.')
          end
        end
      end
      
      % apply updates to the structure
      % % update basis function
      if flag_Infra
        obj.update_B_Func(debug)
      end
      % % update least squares solution
      if flag_Infra || flag_Extern
        obj.update_B_Func_Solution(  tag_Basis, debug);
      end
      
      if debug
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
      end
    end
    
    % update b_Spline basis
    function update_B_Func(obj, debug)
      switch obj.type
        case 'a-periodic-approx'
          obj.b_spline = a_periodic_approx(obj, debug);
        case 'periodic'
          obj.b_spline = periodic(obj, debug);
        otherwise
          obj.b_spline = a_periodic(obj, debug);
      end
      obj.num_Basis_Act = size(obj.b_spline.M,1);
    end
    
    % update b_Spline basis
    function update_B_Func_Solution(obj,  tag_Basis, debug)
      
      % eval basis function
      %             if tag_Obs
      if strcmp(obj.type, 'a-periodic-approx') || strcmp(obj.type, 'periodic')
        obj.basis_Eval  = interp1(obj.b_spline.x, obj.b_spline.M', ((linspace(0,(obj.num_Obs),obj.num_Obs)))/(obj.num_Obs));
      else
        obj.basis_Eval  = interp1(obj.b_spline.x, obj.b_spline.M', ((1:(obj.num_Obs))-1)/(obj.num_Obs-1));
      end
      %             end
      
      % construct 2nd order difference matrix
      %             if tag_Basis
      if ~isempty( obj.reg_Term )
%         switch obj.type
%           case 'a-periodic'
%             
%             %             obj.reg_Matrix = zeros(obj.num_Basis_Act);
%             %             obj.reg_Matrix = obj.reg_Matrix + diag(-2*ones(1,obj.num_Basis_Act))+...
%             %               diag(1*ones(1,obj.num_Basis_Act-1),1)...
%             %               + diag(1*ones(1,obj.num_Basis_Act-1),-1);
%             %             obj.reg_Matrix([1 end]) = -1;
%             obj.reg_Matrix =  diag(-2*ones(1,obj.num_Basis_Act))+...
%               diag(1*ones(1,obj.num_Basis_Act-1),1)...
%               + diag(1*ones(1,obj.num_Basis_Act-1),-1);
%           otherwise
            obj.reg_Matrix =  diag(-2*ones(1,obj.num_Basis_Act))+...
              diag(1*ones(1,obj.num_Basis_Act-1),1)...
              + diag(1*ones(1,obj.num_Basis_Act-1),-1);
            obj.reg_Matrix(end,1) = 1;
            obj.reg_Matrix(1,end) = 1;
%         end
        
      end
      %             end
      
      % solve least squares problem
      if ~isempty( obj.reg_Term )
        A = (-(obj.reg_Term * obj.reg_Matrix  - (obj.weight * obj.basis_Eval)'*...
          (obj.weight * obj.basis_Eval))^-1 * ...
          (obj.weight * obj.basis_Eval)'* obj.weight);
        
        obj.basis_Coeff = (A(:, ~isnan(obj.states(1,:))) * obj.states(:,~isnan(obj.states(1,:)))')';
      else
        obj.basis_Coeff = (((obj.weight * obj.basis_Eval)'*(obj.weight * obj.basis_Eval))^-1 *...
          (obj.weight * obj.basis_Eval)' * obj.weight * obj.states')';
      end
      
      if debug
        c = 'rgbckym';
        figure(2)
        for m = 1:obj.num_States
          plot(obj.b_spline.x, obj.basis_Coeff(m,:)*obj.b_spline.M, ['.' c(m)]);
          if m == 1
            hold on
          end
          
          if strcmp(obj.type, 'a-periodic-approx') || strcmp(obj.type, 'periodic')
            plot( [((linspace(0,(obj.num_Obs),obj.num_Obs)))/(obj.num_Obs) obj.b_spline.x(end)], [obj.states(m,:) obj.states(m,1)], ['o' c(m)]);
          else
            plot( ((1:obj.num_Obs)-1)/(obj.num_Obs-1) , obj.states(m,:), ['o' c(m)]);
          end
          
          if m == obj.num_States
            hold off
          end
          
        end
        title 'parametric representation'
      end
    end
    
    % evaluate parameters
    function V = eval_X(obj, X)
      V = interp1(obj.b_spline.x, obj.b_spline.M', X);
      if strcmp(obj.type, 'periodic')
        V = V(1:end-1,:);
      end
    end
    
    % evaluate prediction
    function V = eval_Pred(obj, X, dt)
      
      V = interp1(obj.b_spline.x,...
        obj.b_spline.M', ...
        mod(X + dt, max(obj.b_spline.x)));
      
    end
    
  end
end
