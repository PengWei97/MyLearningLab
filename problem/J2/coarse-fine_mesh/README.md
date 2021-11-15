Dear MOOSE experts,

Recently, I conducted two uniaxial stretching simulations based on J2 plasticity. The first one (test1) has a relatively coarse mesh. Both the stretching curve and the calculation running time are very nice, as shown in Fig.1. However, the second one (test2) has a finer grid , and the calculated curve is correct, but `dt` gets smaller and smaller after 10s as the simulation progresses, until it reaches the set `dtmin = 2e-6 `, the final solution failed, as shown in Figure 2. 

![image](https://user-images.githubusercontent.com/56183775/141799356-ae3555c6-c152-461c-9804-ce7422a6ad37.png)
![image](https://user-images.githubusercontent.com/56183775/141799355-883cd341-5df9-467e-9f1b-db06e034c26b.png)

So, what is the root cause of this bug in my question? And I want to emphasize that the two tests are only different in the number of grids. Finally, what aspects should be taken to solve this problem?

Any suggestions or recommendations to fix the problem would be greatly appreciated.

Thank you
Wei
