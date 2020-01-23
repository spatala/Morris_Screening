
function unm = unnormalize(vec)

unm = zeros(30,1);

unm(1) = vec(1)*(100-.1)+.1;
for i=2:22
    unm(i) = vec(i)*2 - 1;
end
unm(23) = vec(23)*4 + 1;
for i=24:26
    unm(i) = vec(i)*2 - 1;
end
unm(27) = vec(27)*4 + 1;
for i = 28:30
    unm(i) = vec(i)*2 - 1;
end


end