function varargout = getOutput(func,outputNo,varargin)
% A function that selectively chooses the output of another function.
% func - function handle
% Outputnp - is the output index of interest
% varargin - the inputs to the function
    varargout = cell(max(outputNo),1);
    [varargout{:}] = func(varargin{:});
    varargout = varargout(outputNo);
end