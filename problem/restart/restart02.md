
# enter the gdb environment

```bash
(moose) xia@xia-virtual-machine:~/projects/kunpeng/problem/restart/restart_over_01$ gdb --args ~/projects/kunpeng/kunpeng-dbg -i poly_grain_growth_2D_eldrforce_restart2.i
GNU gdb (Ubuntu 9.2-0ubuntu1~20.04) 9.2
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from /home/xia/projects/kunpeng/kunpeng-dbg...
(gdb) 
```

# Check where you can set breakpoints

```bash
(gdb) l
8       //* https://www.gnu.org/licenses/lgpl-2.1.html
9
10      #include "kunpengTestApp.h"
11      #include "MooseInit.h"
12      #include "Moose.h"
13      #include "MooseApp.h"
14      #include "AppFactory.h"
15
16      // Create a performance log
17      PerfLog Moose::perf_log("kunpeng");
(gdb) l
18
19      // Begin the main program.
20      int
21      main(int argc, char * argv[])
22      {
23        // Initialize MPI, solvers and MOOSE
24        MooseInit init(argc, argv);
25
26        // Register this application's MooseApp and any it depends on
27        kunpengTestApp::registerApps();
(gdb) l
28
29        // Create an instance of the application and store it in a smart pointer for easy cleanup
30        std::shared_ptr<MooseApp> app = AppFactory::createAppShared("kunpengTestApp", argc, argv);
31
32        // Execute the application
33        app->run();
34
35        return 0;
36      }
(gdb) 

```

# Set breakpoint

Please forgive me for being a rookie for using the moose debugging environment, and I can only set these 5 breakpoints in the mian function.

```bash
(gdb) b 21
Breakpoint 1 at 0x14298: file /home/xia/projects/kunpeng/src/main.C, line 22.
(gdb) b 24
Breakpoint 2 at 0x142a7: file /home/xia/projects/kunpeng/src/main.C, line 24.
(gdb) b 27
Breakpoint 3 at 0x142c6: file /home/xia/projects/kunpeng/src/main.C, line 27.
(gdb) b 30
Breakpoint 4 at 0x142cc: file /home/xia/projects/kunpeng/src/main.C, line 30.
(gdb) b 33
Breakpoint 5 at 0x1432f: file /home/xia/projects/kunpeng/src/main.C, line 33.
(gdb) 
```

# Start the simulation and output a "back-trace"

```bash
(gdb) r
Starting program: /home/xia/projects/kunpeng/kunpeng-dbg -i poly_grain_growth_2D_eldrforce_restart2.i
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 1, main (argc=3, argv=0x7fffffffc158) at /home/xia/projects/kunpeng/src/main.C:22
22      {
(gdb) bt
#0  main (argc=3, argv=0x7fffffffc158) at /home/xia/projects/kunpeng/src/main.C:22
(gdb) c
Continuing.

Breakpoint 2, main (argc=3, argv=0x7fffffffc158) at /home/xia/projects/kunpeng/src/main.C:24
24        MooseInit init(argc, argv);
(gdb) bt
#0  main (argc=3, argv=0x7fffffffc158) at /home/xia/projects/kunpeng/src/main.C:24
(gdb) c
Continuing.

Breakpoint 3, main (argc=3, argv=0x7fffffffc158) at /home/xia/projects/kunpeng/src/main.C:27
27        kunpengTestApp::registerApps();
(gdb) bt
#0  main (argc=3, argv=0x7fffffffc158) at /home/xia/projects/kunpeng/src/main.C:27
(gdb) c
Continuing.

Breakpoint 4, main (argc=3, argv=0x7fffffffc158) at /home/xia/projects/kunpeng/src/main.C:30
30        std::shared_ptr<MooseApp> app = AppFactory::createAppShared("kunpengTestApp", argc, argv);
(gdb) bt
#0  main (argc=3, argv=0x7fffffffc158) at /home/xia/projects/kunpeng/src/main.C:30
(gdb) c
Continuing.

Breakpoint 5, main (argc=3, argv=0x7fffffffc158) at /home/xia/projects/kunpeng/src/main.C:33
33        app->run();
(gdb) bt
#0  main (argc=3, argv=0x7fffffffc158) at /home/xia/projects/kunpeng/src/main.C:33
(gdb)

```

# continue

```bash
Continuing.

[New Thread 0x7fffe5d77700 (LWP 293669)]
[Thread 0x7fffe5d77700 (LWP 293669) exited]
[New Thread 0x7fffe5d77700 (LWP 293670)]
[New Thread 0x7fffe5d77700 (LWP 293671)]
[Thread 0x7fffe5d77700 (LWP 293670) exited]
[Thread 0x7fffe5d77700 (LWP 293671) exited]
[New Thread 0x7fffe5d77700 (LWP 293672)]
[Thread 0x7fffe5d77700 (LWP 293672) exited]
[New Thread 0x7fffe5d77700 (LWP 293673)]
[Thread 0x7fffe5d77700 (LWP 293673) exited]


*** Info ***
Using /home/xia/projects/kunpeng/problem/restart/restart_over_01/poly36_grtracker_cp/0011 for restart.
[New Thread 0x7fffe5d77700 (LWP 293696)]
[Thread 0x7fffe5d77700 (LWP 293696) exited]
Inside the PolycrystalElasticDrivingForceAction Object
var name base:gr[New Thread 0x7fffe5d77700 (LWP 293703)]
[Thread 0x7fffe5d77700 (LWP 293703) exited]
[New Thread 0x7fffe5d77700 (LWP 293706)]
[Thread 0x7fffe5d77700 (LWP 293706) exited]
[New Thread 0x7fffe5d77700 (LWP 293707)]
[Thread 0x7fffe5d77700 (LWP 293707) exited]
[New Thread 0x7fffe5d77700 (LWP 293708)]
[Thread 0x7fffe5d77700 (LWP 293708) exited]
[New Thread 0x7fffe5d77700 (LWP 293726)]
[Thread 0x7fffe5d77700 (LWP 293726) exited]
[New Thread 0x7fffe5d77700 (LWP 293727)]
[New Thread 0x7fffe5d77700 (LWP 293728)]
[Thread 0x7fffe5d77700 (LWP 293727) exited]
[Thread 0x7fffe5d77700 (LWP 293728) exited]
[New Thread 0x7fffe5d77700 (LWP 293729)]
[Thread 0x7fffe5d77700 (LWP 293729) exited]
[New Thread 0x7fffe5d77700 (LWP 293730)]
[Thread 0x7fffe5d77700 (LWP 293730) exited]
[New Thread 0x7fffe5d77700 (LWP 293731)]

Framework Information:
MOOSE Version:           git commit fcafd43481 on 2021-04-09
LibMesh Version:         
  Num Processors:          1
  Num Threads:             1

Mesh: 
  Parallel Type:           replicated
  Mesh Dimension:          2
  Spatial Dimension:       2
  Nodes:                   
    Total:                 6561
    Local:                 6561
  Elems:                   
    Total:                 6400
    Local:                 6400
  Num Subdomains:          1
  Num Partitions:          1

Nonlinear System:
  Num DOFs:                65610
  Num Local DOFs:          65610
  Variables:               { "gr0" "gr1" "gr2" "gr3" "gr4" "gr5" "gr6" "gr7" "disp_x" "disp_y" } 
  Finite Element Types:    "LAGRANGE" 
  Approximation Orders:    "FIRST" 

Auxiliary System:
  Num DOFs:                57761
  Num Local DOFs:          57761
  Variables:               "bnds" { "elastic_strain11" "elastic_strain22" "elastic_strain12" "unique_grains" 
                             "var_indices" "vonmises_stress" "C1111" "euler_angle" } 
  Finite Element Types:    "LAGRANGE" "MONOMIAL" 
  Approximation Orders:    "FIRST" "CONSTANT" 

Execution Information:
  Executioner:             Transient
  TimeStepper:             IterationAdaptiveDT
  Solver Mode:             Preconditioned JFNK
  MOOSE Preconditioner:    SMP

[New Thread 0x7fffe5d77700 (LWP 294452)]
Computing Polycrystal Initial Condition                                                    [  1.03 s]
[Thread 0x7fffe5d77700 (LWP 294452) exited]
[New Thread 0x7fffe5d77700 (LWP 294478)]


*** Info ***
/home/xia/projects/kunpeng/problem/restart/restart_over_01/poly_grain_growth_2D_eldrforce_restart2.i:40: (UserObjects/voronoi/coloring_algorithm):
    The backtracking algorithm has exponential complexity. If you are using very few order parameters,
    or you have several hundred grains or more, you should use one of the PETSc coloring algorithms such as "jp".
[Thread 0x7fffe5d77700 (LWP 294478) exited]
[New Thread 0x7fffe5d77700 (LWP 294479)]
Projecting initial condition ..................................                            [ 35.77 s]
[Thread 0x7fffe5d77700 (LWP 294479) exited]
[New Thread 0x7fffe5d77700 (LWP 295311)]
Computing initial stateful property values .                                               [  2.77 s]
[Thread 0x7fffe5d77700 (LWP 295311) exited]
[New Thread 0x7fffe5d77700 (LWP 295365)]
Initial adaptivity step 1 of 2 ...........................................................
....................    ......................................................................
..........................................................................................
.................................................................                          [305.67 s]
[New Thread 0x7fffe5d77700 (LWP 302475)]
[Thread 0x7fffe5d77700 (LWP 295365) exited]
Initial adaptivity step 2 of 2 ...........................................................
..........................................................................................
..........................................................................................
..................................                                                         [274.39 s]
[Thread 0x7fffe5d77700 (LWP 327665) exited]
[New Thread 0x7fffe5d77700 (LWP 334054)]
[New Thread 0x7fffe5d77700 (LWP 334055)]
[Thread 0x7fffe5d77700 (LWP 334054) exited]
[Thread 0x7fffe5d77700 (LWP 334055) exited]
[New Thread 0x7fffe5d77700 (LWP 334056)]
[Thread 0x7fffe5d77700 (LWP 334056) exited]
[New Thread 0x7fffe5d77700 (LWP 334057)]
[New Thread 0x7fffe5d77700 (LWP 334058)]
[Thread 0x7fffe5d77700 (LWP 334057) exited]
[Thread 0x7fffe5d77700 (LWP 334058) exited]
[New Thread 0x7fffe5d77700 (LWP 334059)]
[Thread 0x7fffe5d77700 (LWP 334059) exited]
[New Thread 0x7fffe5d77700 (LWP 334060)]
[Thread 0x7fffe5d77700 (LWP 334060) exited]
[New Thread 0x7fffe5d77700 (LWP 334061)]
Reprojecting initial conditions after restoring restart data .............................
......................................................................................     [116.87 s]
[Thread 0x7fffe5d77700 (LWP 334061) exited]
[New Thread 0x7fffe5d77700 (LWP 336789)]
Computing Polycrystal Initial Condition ..                                                 [  3.23 s]
[Thread 0x7fffe5d77700 (LWP 336789) exited]
[New Thread 0x7fffe5d77700 (LWP 336881)]
[Thread 0x7fffe5d77700 (LWP 336881) exited]
[New Thread 0x7fffe5d77700 (LWP 336882)]
Flooding Features ........................................................................
........                                                                                   [ 81.32 s]
[Thread 0x7fffe5d77700 (LWP 336882) exited]

Grain Tracker Status:
Grains active index 0: 5 -> 5
Grains active index 1: 5 -> 5
Grains active index 2: 7 -> 7
Grains active index 3: 4 -> 4
Grains active index 4: 5 -> 5
Grains active index 5: 3 -> 3
Grains active index 6: 4 -> 4
Grains active index 7: 3 -> 3
Finished inside of GrainTracker



Assertion `grain_id < _grain_data.size()' failed
Requested data for invalid grain index.
at /home/xia/projects/moose/modules/phase_field/build/header_symlinks/GrainDataTracker.h, line 46
Stack frames: 22
0: libMesh::print_trace(std::ostream&)
1: GrainDataTracker<RankFourTensorTempl<double> >::getData(unsigned int) const
2: ComputePolycrystalElasticityTensor::computeQpElasticityTensor()
3: ComputeElasticityTensorBaseTempl<false>::computeQpProperties()
4: Material::computeProperties()
5: MaterialData::reinit(std::__debug::vector<std::shared_ptr<MaterialBase>, std::allocator<std::shared_ptr<MaterialBase> > > const&, bool)
6: FEProblemBase::reinitMaterials(unsigned short, unsigned int, bool)
7: ComputeElemAuxVarsThread<AuxKernelTempl<double> >::onElement(libMesh::Elem const*)
8: ThreadedElementLoopBase<libMesh::StoredRange<libMesh::MeshBase::const_element_iterator, libMesh::Elem const*> >::operator()(libMesh::StoredRange<libMesh::MeshBase::const_element_iterator, libMesh::Elem const*> const&, bool)
9: /home/xia/projects/moose/framework/libmoose-dbg.so.0(+0x3ab1c4e) [0x7ffff605dc4e]
10: void AuxiliarySystem::computeElementalVarsHelper<AuxKernelTempl<double> >(MooseObjectWarehouse<AuxKernelTempl<double> > const&, std::__debug::vector<std::__debug::vector<MooseVariableFieldBase*, std::allocator<MooseVariableFieldBase*> >, std::allocator<std::__debug::vector<MooseVariableFieldBase*, std::allocator<MooseVariableFieldBase*> > > > const&, unsigned int)
11: AuxiliarySystem::computeElementalVars(MooseEnumItem)
12: AuxiliarySystem::compute(MooseEnumItem)
13: FEProblemBase::computeAuxiliaryKernels(MooseEnumItem const&)
14: FEProblemBase::execute(MooseEnumItem const&)
15: FEProblemBase::initialSetup()
16: Transient::init()
17: MooseApp::executeExecutioner()
18: MooseApp::run()
19: /home/xia/projects/kunpeng/kunpeng-dbg(+0x1434b) [0x55555556834b]
20: __libc_start_main
21: /home/xia/projects/kunpeng/kunpeng-dbg(+0x13189) [0x555555567189]
[0] /home/xia/projects/moose/modules/phase_field/build/header_symlinks/GrainDataTracker.h, line 46, compiled May  7 2021 at 17:40:01
application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0
[unset]: write_line error; fd=-1 buf=:cmd=abort exitcode=1
:
system msg for write_line failure : Bad file descriptor
---------------------------------------------------------------------------------
| Time:           Fri May  7 20:02:09 2021                                        |
| OS:             Linux                                                           |
| HostName:       xia-virtual-machine                                             |
| OS Release:     5.8.0-50-generic                                                |
| OS Version:     #56~20.04.1-Ubuntu SMP Mon Apr 12 21:46:35 UTC 2021             |
| Machine:        x86_64                                                          |
| Username:       xia                                                             |
| Configuration:  ../configure  '--enable-silent-rules'                           |
|  '--enable-unique-id'                                                           |
|  '--disable-warnings'                                                           |
|  '--enable-glibcxx-debugging'                                                   |
|  '--with-thread-model=openmp'                                                   |
|  '--disable-maintainer-mode'                                                    |
|  '--enable-petsc-hypre-required'                                                |
|  '--enable-metaphysicl-required'                                                |
|  '--prefix=/home/xia/miniconda3/envs/moose/libmesh'                             |
|  '--with-vtk-lib=/home/xia/miniconda3/envs/moose/libmesh-vtk/lib'               |
|  '--with-vtk-include=/home/xia/miniconda3/envs/moose/libmesh-vtk/include/vtk-6.3'|
|  '--with-methods=opt oprof devel dbg'                                           |
|  '--without-gdb-command'                                                        |
|  'build_alias=x86_64-conda-linux-gnu'                                           |
|  'host_alias=x86_64-conda-linux-gnu'                                            |
|  'PETSC_DIR=/home/xia/miniconda3/envs/moose'                                    |
|  'CC=mpicc'                                                                     |
|  'CFLAGS=-march=nocona -mtune=haswell'                                          |
|  'LDFLAGS=-Wl,-S'                                                               |
|  'FC=mpifort'                                                                   |
|  'F77=mpifort'                                                                  |
|  'CXX=mpicxx'                                                                   |
|  'CXXFLAGS=-march=nocona -mtune=haswell'                                        |
|  'CPP=/home/xia/miniconda3/envs/moose/bin/x86_64-conda-linux-gnu-cpp'           |
 ---------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------
| kunpeng Performance: Alive time=868.405, Active time=0.000206                                              |
 ------------------------------------------------------------------------------------------------------------
| Event                         nCalls     Total Time  Avg Time    Total Time  Avg Time    % of Active Time  |
|                                          w/o Sub     w/o Sub     With Sub    With Sub    w/o S    With S   |
|------------------------------------------------------------------------------------------------------------|
|                                                                                                            |
|                                                                                                            |
| PolycrystalICTools                                                                                         |
|   assignOpsToGrains()         1          0.0002      0.000206    0.0002      0.000206    100.00   100.00   |
 ------------------------------------------------------------------------------------------------------------
| Totals:                       1          0.0002                                          100.00            |
 ------------------------------------------------------------------------------------------------------------

--Type <RET> for more, q to quit, c to continue without paging--


```