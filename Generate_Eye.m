function [eye] = Generate_Eye(eyeSize, receptors, distribution)
%Generate_Eye takes in eyeSize, number of receptors, and distribution of
%receptors and returns a model of an eye.
eye = zeros(eyeSize, 1);
if(distribution == 0)
    indices = randperm(eyeSize);
    indices = indices(1:receptors);
    eye(indices) = 1;
elseif(distribution == 1)
    factor = eyeSize / receptors;
    rec = 1:receptors;
    rec = rec * factor;
    rec = round(rec);
    eye(rec) = 1;
else
    error("Distribution option not defined");
end

