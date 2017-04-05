% Path information
Home = getenv('HOME');
addpath(sprintf('%s/repos/pointbem',Home));
addpath(sprintf('%s/repos/panelbem',Home));
addpath(sprintf('%s/repos/testasymmetry',Home));
addpath(sprintf('%s/repos/testasymmetry/functions',Home));
addpath(sprintf('%s/repos/testasymmetry/mobley',Home));
addpath(sprintf('%s/repos/testasymmetry/born',Home));

% a bunch of useful variables and constants. also defining the global
% variable "ProblemSet" which we'll use to hold the BEM systems.
loadConstants
convertKJtoKcal = 1/joulesPerCalorie;

global UsefulConstants ProblemSet saveMemory writeLogfile logfileName
logfileName = 'acetonitrile.out';
epsOut = 35.6881;

x = [0.3680  -75.5129   -1.3212   -4.5069   -0.0096    2.0416];

[mol_list,dG_list,surfArea_list]=textread('mnsol/acetonitrile.csv',...
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