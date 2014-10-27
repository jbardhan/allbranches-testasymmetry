addpath('../pointbem');
loadConstants
symParams  = struct('alpha',0.0, 'beta',  0.0, 'EfieldOffset', 0.0);
asymParams = struct('alpha',0.5, 'beta', -60.0,'EfieldOffset',-0.5);

origin = [0 0 0];
R = 2.0;
sternLayerThickness = 2.0;
Rstern = R + sternLayerThickness;
chargeLocation = [0 0 0];
q_list = [1 -1];
epsIn  =  1;
epsOut = 80;
kappa  = 0.125;
conv_factor = 332.112;

densities = 0.5:1:8;

for i=1:length(densities)
  density = densities(i);
  numDielPoints(i)  = ceil(4 * pi * density * R^2);
  dielSurfData   = makeSphereSurface(origin, R, numDielPoints(i));
  numSternPoints(i) = ceil(4 * pi * density * Rstern^2);
  sternSurfData  = makeSphereSurface(origin, Rstern, numSternPoints(i));
  numTotalPoints(i) = numDielPoints(i) + numSternPoints(i);
  
  for j=1:length(q_list)
    q = q_list(j);
    pqr = struct('xyz',chargeLocation,'q',q,'R',R);
    
    bemEcfAsym      = makeBemEcfQualMatrices(dielSurfData, pqr,  epsIn, epsOut);
    bemYoonDielAsym = makeBemYoonDielMatrices(dielSurfData, pqr,  epsIn, epsOut);
    bemYoonLPB   = makeBemYoonLPBMatrices(dielSurfData, pqr, epsIn, ...
					     epsOut, kappa);
    bemStern        = makeBemSternMatrices(dielSurfData, sternSurfData, pqr, ...
				   epsIn, epsOut, kappa);

    [phiReacYoonDielAsym, phiBndy,dPhiBndy] = ...
	solveConsistentYoonNoSternAsym(dielSurfData, bemYoonDielAsym, epsIn, ...
				       epsOut, conv_factor, pqr, ...
				       asymParams); % asymParams!!

    [phiReacYoonLPBsym, phiBndy,dPhiBndy] = ...
	solveConsistentYoonNoSternAsym(dielSurfData, bemYoonLPB, epsIn, ...
				       epsOut, conv_factor, pqr, ...
				       symParams); % symParams!!

    [phiReacYoonLPBAsym, phiBndy,dPhiBndy] = ...
	solveConsistentYoonNoSternAsym(dielSurfData, bemYoonLPB, epsIn, ...
				       epsOut, conv_factor, pqr, ...
				       asymParams); % symParams!!
    [phiReacSternSym, phiBndy,dPhiBndy] = ...
	solveConsistentSternAsym(dielSurfData, sternSurfData, pqr, ...
				 bemStern, epsIn, epsOut, kappa, ...
				 conv_factor, symParams); % symParams!!

    [phiReacSternAsym, phiBndy,dPhiBndy] = ...
	solveConsistentSternAsym(dielSurfData, sternSurfData, pqr, ...
				 bemStern, epsIn, epsOut, kappa, ...
				 conv_factor, asymParams); % symParams!!

    E_yoondiel(i,j) = 0.5 * q'*phiReacYoonDielAsym;
    E_LPBs(i,j) = 0.5 * q'*phiReacYoonLPBsym;
    E_LPBa(i,j) = 0.5 * q'*phiReacYoonLPBAsym;
    E_sternSym(i,j) = 0.5 * q'*phiReacSternSym;
    E_sternAsym(i,j) = 0.5 * q'*phiReacSternAsym;
    fprintf('numDielPoints = %d,YL = %f, LPB_s = %f, LPB_a = %f, Stern_s = %f, Stern_a = %f\n',...
	    numDielPoints(i), ...
	    E_yoondiel(i), E_LPBs(i), E_LPBa(i),...
	    E_sternSym(i), E_sternAsym(i));

  end
end

if length(densities) < 5
  fprintf('Error: not enough densities to do Richardson extrapolation\n');
  return
end

expectedOrder = -0.5; % with respect to the number of points
index1 = length(densities) - 4; 
index2 = length(densities);

for j=1:length(q_list)
E_ecf_richardson_extrap(j) = RichardsonExtrapolation(index1, index2, ...
						  numDielPoints, E_ecf(:,j), ...
						  expectedOrder);
E_yoondiel_richardson_extrap(j) = RichardsonExtrapolation(index1, index2,...
						  numDielPoints, E_yoondiel(:,j),...
						  expectedOrder);
E_lpbs_richardson_extrap(j) = RichardsonExtrapolation(index1, index2, ...
						  numDielPoints, E_LPBs(:,j), ...
						  expectedOrder);
E_lpba_richardson_extrap(j) = RichardsonExtrapolation(index1, index2,...
						  numDielPoints, E_LPBa(:,j),...
						  expectedOrder);
E_sternSym_richardson_extrap(j) = RichardsonExtrapolation(index1, index2,...
						  numTotalPoints, E_sternSym(:,j),...
						  expectedOrder);
E_sternAsym_richardson_extrap(j) = RichardsonExtrapolation(index1, index2,...
						  numTotalPoints, E_sternAsym(:,j),...
						  expectedOrder);
end
