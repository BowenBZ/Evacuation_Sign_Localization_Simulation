function stepErr = GetPositionError(realPath, obserPath)
disSqua = sum((realPath - obserPath).^2, 2);
stepErr = disSqua.^(1/2);
end