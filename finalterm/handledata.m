'signweight\n'
for cnt = 1: 8
   cnt
   mean(data((cnt-1) * 100 + 1: cnt * 100, :))
   std(data((cnt-1) * 100 + 1: cnt * 100, :))
end

%{
'detectability'
for cnt = 1: 11
   cnt
   mean(data2((cnt-1) * 100 + 1: cnt * 100, :))
   std(data2((cnt-1) * 100 + 1: cnt * 100, :))
end
%}