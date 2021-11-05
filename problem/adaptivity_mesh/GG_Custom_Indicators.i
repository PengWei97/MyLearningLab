my_GBmob0 = 2.5e-6
my_length_scale = 1.0e-9
my_time_scale = 1.0e-9 # miu s
my_wGB = 15 # nm
my_T = 500
my_number_adaptivity = 5
my_displacement = 0 #25.0e2 # 10 10 2% 500*5%
# my_GBMobility = 1.0e-12 # m^4/(Js) 1.0e-10
my_end_time = 4000
# my_interval = 2 

/home/pw-moose/projects/panda/grain_growth/bicrystal_model/GG_Custom_Indicators.i
cp GG_Custom_Indicators.i GG_default_adaptive.i 
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 64
  ny = 64
  nz = 0
  xmin = 0
  xmax = 64e1
  ymin = 0
  ymax = 64e1
  zmin = 0
  zmax = 0
  elem_type = QUAD4

  parallel_type = distributed
[]

[GlobalParams]
  op_num = 2
  var_name_base = gr
[]

[Variables]
  [./PolycrystalVariables]
  [../]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
    # scaling = 1.0e4 #Scales residual to improve convergence 
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
    # scaling = 1.0e4 #Scales residual to improve convergence 
  [../]
[]

[UserObjects]
  [./euler_angle_file]
    type = EulerAngleFileReader
    file_name = grn_2_rand_2D.tex
  [../]
  [./grain_tracker]
    type = GrainTrackerElasticity
    threshold = 0.2
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_begin'
    flood_entity_type = ELEMENTAL

    C_ijkl = '1.27e5 0.708e5 0.708e5 1.27e5 0.708e5 1.27e5 0.7355e5 0.7355e5 0.7355e5'
   
    fill_method = symmetric9
    euler_angle_provider = euler_angle_file
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./BicrystalCircleGrainIC]
      radius = 25e1
      x = 32e1
      y = 32e1
      int_width = 15
    [../]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
  [./elastic_strain11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./elastic_strain22]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./elastic_strain12]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress12]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress22]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vonmises_stress]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C1111]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./euler_angle]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./PolycrystalKernel]
  [../]
  [./PolycrystalElasticDrivingForce]
  [../]
  [./TensorMechanics]
    use_displaced_mesh = true
    displacements = 'disp_x disp_y'
  [../]
[]

[AuxKernels]
  [./BndsCalc]
    type = BndsCalcAux
    variable = bnds
    # execute_on = timestep_end
    v = 'gr0 gr1'
  [../]
  [./elastic_strain11]
    type = RankTwoAux
    variable = elastic_strain11
    rank_two_tensor = elastic_strain
    index_i = 0
    index_j = 0
    execute_on = timestep_end
  [../]
  [./elastic_strain22]
    type = RankTwoAux
    variable = elastic_strain22
    rank_two_tensor = elastic_strain
    index_i = 1
    index_j = 1
    execute_on = timestep_end
  [../]
  [./elastic_strain12]
    type = RankTwoAux
    variable = elastic_strain12
    rank_two_tensor = elastic_strain
    index_i = 0
    index_j = 1
    execute_on = timestep_end
  [../]
  [./stress11]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress11
    index_i = 0
    index_j = 0
  [../]
  [./stress12]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress12
    index_i = 0
    index_j = 1
  [../]
  [./stress22]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress22
    index_i = 1
    index_j = 1
  [../]
  [./C1111]
    type = RankFourAux
    variable = C1111
    rank_four_tensor = elasticity_tensor
    index_l = 0
    index_j = 0
    index_k = 0
    index_i = 0
    execute_on = timestep_end
  [../]
  [./vonmises_stress]
    type = RankTwoScalarAux
    variable = vonmises_stress
    rank_two_tensor = stress
    scalar_type = VonMisesStress
    execute_on = timestep_end
  [../]
  [./euler_angle]
    type = OutputEulerAngles
    variable = euler_angle
    euler_angle_provider = euler_angle_file
    grain_tracker = grain_tracker
    output_euler_angle = 'phi1'
    #  phi1, Phi, phi2
    execute_on = 'initial timestep_end'
  [../]
[]

[BCs]
  [./Periodic]
    [./All]
      auto_direction = 'x'
      variable = 'gr0 gr1'
    [../]
  [../]
  [./top_displacement]
    type = DirichletBC
    variable = disp_y
    boundary = top
    value = ${my_displacement} # 500
  [../]
  [./x_anchor]
    type = DirichletBC
    variable = disp_x
    boundary = 'left right'
    value = 0.0
  [../]
  [./y_anchor]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  [../]
[]

[Materials]
  [./Copper]
    type = GBEvolution
    block = 0
    T = ${my_T} # K
    wGB = ${my_wGB} # nm
    GBmob0 = ${my_GBmob0} # m^4/(Js) from Schoenfelder 1997
    Q = 0.23 # Migration energy in eV
    GBenergy = 0.708 # GB energy in J/m^2
    time_scale = ${my_time_scale}
    length_scale = ${my_length_scale}
  [../]
  [./ElasticityTensor]
    type = ComputePolycrystalElasticityTensor
    grain_tracker = grain_tracker
    length_scale = ${my_length_scale}
  [../]
  [./strain]
    type = ComputeSmallStrain
    block = 0
    displacements = 'disp_x disp_y'
  [../]
  [./stress]
    type = ComputeLinearElasticStress
    block = 0
  [../]
[]

[Postprocessors]
  [./dofs]
    type = NumDOFs
  [../]
  [./run_time]
    type = PerfGraphData
    section_name = "Root"
    data_type = total
  [../]
  [./gr0area]
    type = ElementIntegralVariablePostprocessor
    variable = gr0
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    coupled_groups = 'disp_x,disp_y'
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre boomeramg 31 0.7'
  l_tol = 1.0e-4
  l_max_its = 30
  nl_max_its = 25
  nl_rel_tol = 1.0e-7

  start_time = 0.0
  end_time = ${my_end_time}

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1.5
    growth_factor = 1.2
    cutback_factor = 0.8
    optimal_iterations = 8
  [../]
  # [./Adaptivity]
  #   initial_adaptivity = ${my_number_adaptivity} # 8 
  #   cycles_per_step = 2 # The number of adaptivity cycles per step
  #   refine_fraction = 0.5 # The fraction of elements or error to refine.
  #   coarsen_fraction = 0.05
  #   max_h_level = 8
  # [../]
[]

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

[Outputs]
  file_base = ./${my_filename}/out_${my_filename}
  csv = true
  [./my_checkpoint]
    type = Checkpoint
    num_files = 6
    interval = 2
  [../]
  [./my_exodus]
    type = Nemesis
  [../]
  [./pgraph]
    type = PerfGraphOutput
    execute_on = 'initial timestep_end final'  # Default is "final"
    level = 2                     # Default is 1
    heaviest_branch = true        # Default is false
    heaviest_sections = 7         # Default is 0
  [../]
[]
