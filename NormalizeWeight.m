function weight_norm = NormalizeWeight(weight)
if(sum(weight) ~= 0)
    weight_norm = weight / sum(weight);    
else
    weight_norm =  ones(1, length(weight)) * 1 / length(weight);
end
end