1. Main file- mainGeneticAlgorithm.m

2. After the plots are obtained-
	figure 1 is bar graph for number of controllers vs fitness function for number of iterations = 50
		to change the number of iterations from 50 to any other value among (10,20,30,40,50,60,70,80,90,100)-
		go to line no 38 in mainGeneticAlgorithm.m
		there is 'bar (y (1:noc,5));'
		here '5' is for number of iterations = 50
		e.g. if '5' will be changed to '7', the number of iterations will become 70
	figure 2 is bar graph for number of controllers vs fitness function for number of iterations = 30 to 70
		to change the range of number of iterations
		go to line no 47 in mainGeneticAlgorithm.m
		there is 'bar (y (1:noc,3:7),1);'
		here '3:7' indicates 30 to 70 so it can be changed as per requirement

3. To change the maximum number of controllers-
	go to line no 13 in mainGeneticAlgorithm.m and change the value of noc (current value is 6)

4. To change the starting number of controllers-
	go to line no 21 in mainGeneticAlgorithm.m and change the value '1' to required value.
	Current value is '1' so the loop will run from 1 to 6 number of controllers

5. To change the network-
	go to line no 3 in mainGeneticAlgorithm.m and change fileName (current value is Agis.graphml)

6. To change the maximum number of iterations-
	go to line no 15 in mainGeneticAlgorithm.m and change the value of maxIterations (current value is 100)

7. To change the population size-
	go to line no 14 in mainGeneticAlgorithm.m and change the value of populationSize (current value is 20)

8. To change the iterations-
	go to line no 22 in mainGeneticAlgorithm.m and change accordingly
	20 : 10 : 50 means it will start from 20, increment by 10 and end at 50
	(current value is 10 : 10 : maxIterations)

9. To switch between random selection and roulette wheel selection-
	go to line no 50 and 51 in modifiedGeneticAlgorithmImpl.m
	line no 50 calls roulette wheel selection function
	line no 51 calls random selection function
	comment the line which is not required by putting a '%' sign at the beginning
	remove '%' sign from the beginning of the required line