function [maxErr accErr] = GetPositionError(realPath, obserPath)
disSqua = sum((realPath - obserPath).^2, 2);
maxErr = max(disSqua.^(1/2));
accErr = sum(disSqua.^(1/2)) / length(realPath);
end