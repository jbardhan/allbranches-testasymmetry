function addProblemSA3(name1, name2, pqrData1, pqrData2, srfFile1,srfFile2,srfFile3, chargeDistribution1, chargeDistribution2, ...
		      reference , surfArea)
global ProblemSet3

% check to make sure that the test charge distributions are the
% right length
if (size(chargeDistribution1,1) ~= length(pqrData1.q)) || (size(chargeDistribution2,1) ~= length(pqrData2.q))
  fprintf('Error in createProblem: number of charges in at least one of the chargeDistributions is not equal to the number the corrresponding atom(s)!\n');
  keyboard
end

% then define a variable numTests that says, how many tests (charge
% distributions) do we have.  
numTests1 = size(chargeDistribution1,2);
numTests2 = size(chargeDistribution2,2);

true = 1;  %  just to keep the boolean nature of "uninitialized"
           %  clear in this function
	   
% when we first say "global ProblemSet" at the uppermost level of
% Matlab, it defines it as a zero-length vector of floats, which
% means I can't say "ProblemSet(1) = struct( ... ).  Try this for
% yourself if it's not clear what the issue is.

newIndex = length(ProblemSet3)+1;
newproblem = struct('index',newIndex,...
		    'name1',name1,'name2',name2,...
		    'pqrData1',pqrData1,'pqrData2',pqrData2,...
		    'reference', reference,...
		    'srfFile1', srfFile1,'srfFile2', srfFile2,'srfFile3', srfFile3,...
		    'uninitialized',true,...
		    'numTests1InProblem',numTests1,'numTests2InProblem',numTests2,...
		    'chargeDistribution1',chargeDistribution1,'chargeDistribution2',chargeDistribution2,...
		    'bemYoonStern',[],...
		    'asymBemPcm1',[],...
		    'asymBemPcm2',[],...
		    'bemPcm1',[],...
		    'bemPcm2',[],...
		    'srf1SternData',[],...
		    'srf2SternData',[],...
		    'surfArea',surfArea);

if newIndex == 1
  ProblemSet3 = newproblem;
else
  ProblemSet3(newIndex) = newproblem;
end

