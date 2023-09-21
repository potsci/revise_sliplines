function [ebsd_correction]=ebsdfilter(ebsd,opts)

%% indexed percent
    indPerc = 100*ebsd('Indexed').size(1)/ebsd.size(1);
    fprintf('\nIndexed points: %1.1f%%\n',indPerc);
%% exclude low CI values
%     ebsd=empty2notIndexed(ebsd);
    ebsd(ebsd.confidenceindex<opts.minCI).phaseId=1;
    ebsd_correction= ebsd;
    fprintf('Mean %s value: %1.2f\n','ci', mean(ebsd_correction('indexed').confidenceindex));
% indexed percent after filtering
    indPercF = 100*ebsd_correction('indexed').size(1)/ebsd.size(1);
    fprintf('Indexed points after filtering: %1.1f%%\n',indPercF);

% disable reconstruction filtering if 100% indexed 
if indPercF == 100, opts.nFilter = 0; end