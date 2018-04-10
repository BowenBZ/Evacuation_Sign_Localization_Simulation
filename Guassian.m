function y = Guassian(x, miu, var)
y = (1 / sqrt(var) / sqrt(2 * pi)) * exp(-(x - miu).^2 / 2 / var);
end