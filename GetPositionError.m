function [maxError accError] = GetPositionError(realPath, obserPath)
maxError = max(sum(abs(realPath - obserPath).^2, 2).^(1/2));
accError = sum(sum(abs(realPath - obserPath).^2, 2).^(1/2));
end