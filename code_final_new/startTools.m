function startTools(varargin)
warning off;
path=mfilename('fullpath');
addpath(path(1:end-11))
%path to mtex and Goniometer Tools
run([path(1:end-11)  '\mtex-5.3.1\startup_mtex.m']);

warning on;
