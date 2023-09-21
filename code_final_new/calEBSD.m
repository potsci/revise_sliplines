function ebsd=calEBSD(fname,cs)
    %% options
    %upped angular threshold (MAD, Fit...)
    opts.maxMAD = 1.3;
    opts.minCI=0.1;
    opts.maxiQ=1150;
    %segmentation angle for grain (including subgrain) detection
    opts.segAngle = 2;
    %Number of Measurement Points to filter (min points per grain)
    opts.nFilter = 5;
    opts.iter=3;
    %iterations for grain smoothing routine (0 for no smoothing)
    opts.sm = 5;
    %define HAGB and LAGB
    opts.hagb=10;
    opts.lagb=2;
    % plot properties
    opts.linewidth=0.5;
    opts.cbOffset = 200;
    opts.fontSize = 11;
    opts.dpi ='-m6';
    opts.drawLine='true';
    %% load ebsd data
    % [ebsd_set,opts.interface,~] = loadEBSD(fname,...
    %     'convertEuler2SpatialReferenceFrame');
       ebsd_set = EBSD.load(fname,cs,'interface','osc','convertEuler2SpatialReferenceFrame','setting 2');
    %% ebsd filter with ci>0.1 or mad<1.3
    ebsd=ebsdfilter(ebsd_set,opts);
    %% grain correction
    ebsd =  ebsdcorrectionMulti(ebsd,opts);
end