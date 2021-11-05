Yeah, I modified my input file, GG_Custom_Indicators.i based on the webpage you shared and GrandPotentialPlanarGrowth.i. The code that contains the adaptation is as, 
```bash
[Adaptivity]
 initial_steps = ${my_number_adaptivity}
 max_h_level = ${my_number_adaptivity}
 initial_marker = err_eta
 marker = err_bnds
[./Markers]
   [./err_eta]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.5
     indicator = ind_eta
   [../]
   [./err_bnds]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.5
     indicator = ind_bnds
   [../]
 [../]
 [./Indicators]
   [./ind_eta]
     type = GradientJumpIndicator
     variable = gr0
    [../]
    [./ind_bnds]
      type = GradientJumpIndicator
      variable = bnds
   [../]
 [../]
[]
```
Howover， 
In addition, I also created the GG_default_adaptive.i using the default adaptive technolohy. The code that contains the adaptation is as follows,
```bash
  [./Adaptivity]
    initial_adaptivity = ${my_number_adaptivity} # 5
    cycles_per_step = 2 # The number of adaptivity cycles per step
    refine_fraction = 0.5 # The fraction of elements or error to refine.
    coarsen_fraction = 0.05
    max_h_level = 8
  [../]
[]
```
Then, the mesh results of the two adaptive mesh setting are shown below,
![image](https://user-images.githubusercontent.com/56183775/140469852-6087c1a2-2c00-4fdd-afd3-ca2a53f435dc.png)

By comparing the two adaptive grid methods, I think that the custom adaptive grid division (fig.1) is not as perfect as the default grid adaptive method (fig.2). Although the first calculation only took 4.29 minutes, the second calculation took 15.45 minutes. Moreover, the circular grian-time curve of the two simultion outputs is the same,
![image](https://user-images.githubusercontent.com/56183775/140471392-edefadc1-8877-4e9c-a21e-64ff7953dc24.png)

So my final question is how to modify my GG_Custom_Indicators.i to make the quality of the adaptive grid better without spending as much time as GG_default_adaptive.i.

Wei
