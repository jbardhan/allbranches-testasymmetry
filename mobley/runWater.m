% Path information
addpath('/Users/jbardhan/repos/pointbem');
addpath('/Users/jbardhan/repos/panelbem');
addpath('/Users/jbardhan/repos/testasymmetry');
addpath('/Users/jbardhan/repos/testasymmetry/functions');
addpath('/Users/jbardhan/repos/testasymmetry/mobley');
addpath('/Users/jbardhan/repos/testasymmetry/born/');

% a bunch of useful variables and constants. also defining the global
% variable "ProblemSet" which we'll use to hold the BEM systems.
loadConstants
convertKJtoKcal = 1/joulesPerCalorie;

global UsefulConstants ProblemSet saveMemory writeLogfile logfileName
logfileName = 'water.out';
epsOut = 78.36;

x = [  1.8570  -75.6855   -2.9884    8.7302    0.0113    0.4098];

[mol_list,dG_list,surfArea_list]=textread('mnsol/water.csv',...
					  '%s %f %f','delimiter',',');

saveMemory = 1;
writeLogfile = 1;
epsIn  =  1;
Tbase = 300; mytemp=Tbase;

KelvinOffset = 273.15;
conv_factor = 332.112;
staticpotential = 0.0; % this only affects charged molecules;

kappa = 0.0;  % should be zero, meaning non-ionic solutions!
UsefulConstants = struct('epsIn',epsIn,'epsOut',epsOut,'kappa', ...
			 kappa,'conv_factor',conv_factor,...
			 'staticpotential',staticpotential);

% here we define the actual params for the NLBC test

     

curdir = pwd;
for i=1:length(mol_list)
  dir=sprintf('%s/Dropbox/lab/projects/slic-jctc-mnsol/nlbc-mobley/nlbc_test/%s',getenv('HOME'),mol_list{i});
  chdir(dir);
  pqrData = loadPqr('test.pqr');
  pqrAll{i} = pqrData;
  srfFile{i} = sprintf('%s/test_2.srf',dir);
  chargeDist{i} = pqrData.q;
  referenceData{i} = dG_list(i);
  surfArea{i} = surfArea_list(i);
  chdir(curdir);
  addProblemSA(mol_list{i},pqrAll{i},srfFile{i},chargeDist{i},referenceData{i},surfArea{i});
end

[errfinal,calcE,refE,es,np]=ObjectiveFromBEMSA(x);