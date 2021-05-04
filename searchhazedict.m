function [shiftMeans,shiftSigmas] = searchhazedict(means, sigmas, dict)
%SEARCHHAZEDICT Summary of this function goes here
%   Detailed explanation goes here
distances = vecnorm(means-cat(1,dict.hazy_means),2,2) + ...
            vecnorm(sigmas-cat(1,dict.hazy_sigmas),2,2);
best_match = dict(distances==min(distances));
shiftMeans = best_match.truth_means;
shiftSigmas = best_match.truth_sigmas;

end

