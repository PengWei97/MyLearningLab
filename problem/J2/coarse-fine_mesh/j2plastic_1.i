my_filename = 'test001'
my_xnum_element = 6
my_ynum_element = 6
my_xmax = 3e3
my_ymax = 1e3
my_function = 't' # 0.001
my_end_time = 100

[Mesh]
  displacements = 'disp_x disp_y'
  [./generated_mesh]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${my_xnum_element}
    ny = ${my_ynum_element}
    xmax = ${my_xmax}
    ymax = ${my_ymax}
    elem_type = QUAD4
    block = 0
  [../]
  [cnode]
    type = ExtraNodesetGenerator
    coord = '0.0 0.0'
    new_boundary = 6
    input = generated_mesh
  []
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[BCs]
  [./x]
    type = DirichletBC
    variable = disp_x
    boundary = 'left'
    value = 0.0
  [../]
  [./y]
    type = DirichletBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0
  [../]
  [./corner1]
    type = DirichletBC
    variable = disp_x
    boundary = 6
    value = 0.0
  [../]
  [./corner2]
    type = DirichletBC
    variable = disp_y
    boundary = 6
    value = 0.0
  [../]
  [./top]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = top
    function = ${my_function}
  [../]
[]

[AuxVariables]
  [./strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./elastic_strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./VMstress]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./strain_yy]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_yy
    index_i = 1
    index_j = 1
  [../]
  [./plastic_strain_yy]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = plastic_strain_yy
    index_i = 1
    index_j = 1
  [../]
  [./elastic_strain_yy]
    type = RankTwoAux
    rank_two_tensor = elastic_strain
    variable = elastic_strain_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./VMstress]
    type = MaterialRealAux
    variable = VMstress
    property = von_mises_stress  
  [../]
[]



[Postprocessors]
  [./epsilon_yy]
    type = PointValue
    point = '0 0 0'
    variable = strain_yy
  [../]
  [./epsilon_yy_av]
    type = ElementAverageValue
    variable = strain_yy
  [../]
  [./epsilon_p_yy]
    type = PointValue
    point = '0 0 0'
    variable = plastic_strain_yy
  [../]
  [./epsilon_e_yy]
    type = PointValue
    point = '0 0 0'
    variable = elastic_strain_yy
  [../]
  [./sigma_yy]
    type = PointValue
    point = '0 0 0'
    variable = stress_yy
  [../]
  [./VMstress]
    type = PointValue
    point = '0 0 0'
    variable = VMstress
  [../]
  [./VMstress_av]
    type = ElementAverageValue
    variable = VMstress
  [../]
  [./run_time]
    type = PerfGraphData
    section_name = "Root"
    data_type = total
  [../]
  [./dt]
    type = TimestepSize
  [../]
[]

[UserObjects]
  [./str]
    type = TensorMechanicsHardeningConstant
    value = 400 # MPa
  [../]
  [./j2]
    type = GGTensorMechanicsPlasticJ2
    yield_strength = str
    yield_function_tolerance = 1E-5
    internal_constraint_tolerance = 1E-9
    max_iterations = 10
  [../]
[]

[Modules/TensorMechanics/Master]
  [./all]
    # strain = FINITE     
    # use_displaced_mesh = true
    strain = FINITE # FINITE
  [../]
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    fill_method = symmetric9
    C_ijkl = '1.27e5 0.708e5 0.708e5 1.27e5 0.708e5 1.27e5 0.7355e5 0.7355e5 0.7355e5'
    # use_displaced_mesh = true
  [../]
  [./mc]
    type = GGComputeMultiPlasticityStress
    block = 0
    ep_plastic_tolerance = 1E-9
    plastic_models = j2
    debug_fspb = crash
    # tangent_operator = elastic
    # perform_finite_strain_rotations = false
  [../]
[]

[Executioner]
  type = Transient

  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre boomeramg 31 0.7'

  dtmin = 2.0e-6 # The minimum timestep size in an adaptive run
  l_max_its = 30
  l_tol = 1e-4
  nl_max_its = 30
  nl_rel_tol = 1e-9

  end_time = ${my_end_time}
  dt = 0.05

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.2
    growth_factor = 1.2
    cutback_factor = 0.8
    optimal_iterations = 8
  [../]
[]

# [Executioner]
#   type = Transient

#   #Preconditioned JFNK (default)
#   solve_type = 'PJFNK'

#   petsc_options = '-snes_ksp_ew'
#   petsc_options_iname = '-ksp_gmres_restart'
#   petsc_options_value = '101'

#   line_search = 'none'
#   dtmin = 2.0e-6 # The minimum timestep size in an adaptive run
#   l_max_its = 100
#   nl_max_its = 100
#   nl_rel_tol = 1e-6
#   nl_abs_tol = 1e-10
#   l_tol = 1e-4
#   end_time = ${my_end_time}
#   dt = 0.05

#   [./TimeStepper]
#     type = IterationAdaptiveDT
#     dt = 0.2
#     growth_factor = 1.2
#     cutback_factor = 0.8
#     optimal_iterations = 8
#   [../]
# []


[Outputs]
  file_base = ./${my_filename}/out_${my_filename} 
  [./my_exodus]
    type = Exodus
  [../]
  [./csv]
    type = CSV
  [../]
[]
