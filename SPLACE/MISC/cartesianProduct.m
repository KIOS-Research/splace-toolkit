%{
  Copyright: Amro, 2010 (http://stackoverflow.com/users/97160/amro)
  Stack Overflow, Creative Commons Attribution-ShareAlike 3.0 Unported License
  http://stackoverflow.com/questions/4165859  
%}

function result = cartesianProduct(sets)
    c = cell(1, numel(sets));
    [c{:}] = ndgrid( sets{:} );
    result = cell2mat( cellfun(@(v)v(:), c, 'UniformOutput',false) );
end