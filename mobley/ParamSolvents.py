import matlab.engine
import os

Home = os.environ['HOME']
os.chdir(Home+'/repos/testasymmetry/mobley')

Run_Type = 'run'

if Run_Type == 'param':
	Solvent_List = ['paramWater', 'paramOctanol', 'paramMethanol', 'paramAcetonitrile', 'paramPropanone', 'paramPropanol',
 		        'paramDichloroethane','paramDimethylsulfoxide', 'paramDimethylformamide', 'paramEthanol']
elif Run_Type == 'run':
	Solvent_List = ['runWater', 'runOctanol', 'runMethanol', 'runAcetonitrile', 'runPropanone', 'runPropanol',
 		        'runDichloroethane','runDimethylsulfoxide', 'runDimethylformamide', 'runEthanol']

Solvent_List = Solvent_List[4:]

if len(Solvent_List) <= 10:
	for solvent in Solvent_List:
		eng = matlab.engine.start_matlab()
		eng.eval(solvent,nargout=0)
		eng.quit()
else:
	eng = matlab.engine.start_matlab()
	eng.eval(Solvent_List,nargout=0)
	eng.quit()

