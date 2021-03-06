
%%% Note: run the 'GenerateTrainingPatches.m' to generate
%%% training data (clean images) first.
addpath('E:\matConvNet\matconvnet-1.0-beta25\matlab\mex');
addpath('E:\matConvNet\matconvnet-1.0-beta25\matlab\simplenn'); 
% addpath('E:\matConvNet\matconvnet-1.0-beta25\matlab'); 

rng('default')

global featureSize noLayer subRate blkSize isLearnMtx; %%% noise level

featureSize = 64;
noLayer = 5; 
subRate = 0.1;
blkSize = 32; 
isLearnMtx = [1 0]; 
batSize = 64;

%%%-------------------------------------------------------------------------
%%% Configuration
%%%-------------------------------------------------------------------------
opts.modelName        = ['CSNet' num2str(noLayer) '_' num2str(featureSize) '_r' num2str(subRate) ...
                          '_blk' num2str(blkSize) '_mBat' num2str(batSize) ...
                          '_' num2str(isLearnMtx(1)) '_' num2str(isLearnMtx(2)) ]; %%% model name
opts.learningRate     = [logspace(-3,-3,50) logspace(-4,-4,30) logspace(-5, -5, 20)];%%% you can change the learning rate
opts.batchSize        = batSize;
opts.gpus             = [1]; %%% this code can only support one GPU!

opts.numSubBatches    = 2;
opts.bnormLearningRate= 0;
           
%%% solver
opts.solver           = 'Adam';
opts.numberImdb       = 1;

opts.imdbDir          = ['../../../TrainingPatches/imdb_96_' num2str(batSize) '_stride32.mat'];

opts.gradientClipping = false; %%% set 'true' to prevent exploding gradients in the beginning.
opts.backPropDepth    = Inf;
%%%------------;-------------------------------------------------------------
%%%   Initialize model and load data
%%%-------------------------------------------------------------------------
%%%  model
net  = feval('CSNet_init');

%%%  load data
opts.expDir      = fullfile('data', opts.modelName);

%%%-------------------------------------------------------------------------
%%%   Train 
%%%-------------------------------------------------------------------------

[net, info] = CSNet_train(net,  ...
    'expDir', opts.expDir, ...
    'learningRate',opts.learningRate, ...
    'bnormLearningRate',opts.bnormLearningRate, ...
    'numSubBatches',opts.numSubBatches, ...
    'numberImdb',opts.numberImdb, ...
    'backPropDepth',opts.backPropDepth, ...
    'imdbDir',opts.imdbDir, ...
    'solver',opts.solver, ...
    'gradientClipping',opts.gradientClipping, ...
    'batchSize', opts.batchSize, ...
    'modelname', opts.modelName, ...
    'gpus',opts.gpus) ;






