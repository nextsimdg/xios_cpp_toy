## Prerequisites

### netCDF-4 and HDF5 with parallel support

Make sure that the `netCDF/HDF5` headers/libraries paths you will be including from/linking to are compiled with PARALLEL support.
Note: this is very important, as it will allow `XIOS` to generate monolithic output netCDF files despite the fact that it runs on different parallel MPI instances... In case of no parallel support in netCDF4/HDF5, you would write `N` netCDF files, each corresponding to `1/Nth` of your horizontal model domain...
CPP, and Fortran interfaces of netCDF must be compiled as well.


### Compile XIOS (trunk)

Get the source code:

`>> svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/trunk xios_trunk`
    
`>> cd xios_trunk/`

In the `arch/` sub-directory of `xios_trunk` you will have to create/adapt 3 files according to your local architecture:
* `<MY_ARCH>.path`
* `<MY_ARCH>.env`
* `<MY_ARCH>.fcm`

In the case of `fram.sigma2.no`: `<MY_ARCH> = FRAM-intel-2018a`, these files are found here: [`templates/xios/arch/arch_FRAM-intel-2018a.*`](templates/xios/)...

You can now compile `xios`:

`>> ./make_xios --full --prod --arch <MY_ARCH> --netcdf_lib netcdf4_par --job 6`

Note the use of the `--netcdf_lib netcdf4_par` switch that tells we want the netCDF parallel support on (counterpart would be the `--netcdf_lib netcdf4_seq`).

Check that the following have been created:
* `lib/libxios.a`
* `bin/xios_server.exe`

### Get familiar with XIOS and the doc

The doc is mainly for the Fortran interface but the philosophy is there!
* A calendar must be defined
* Axes, grids, domains, contexts etc must be defined
* Control of what is going to be written in the output is done via XML files,
* ...

There are the `XIOS_user_guide.pdf` and `XIOS_reference_guide.pdf` that you can find in the `doc/` directory of the XIOS repo.

And of course tutorial, slides, etc found on the following page: `https://forge.ipsl.jussieu.fr/ioserver`

​ 
## The test

### What is the "test" made of

The test is a C++ version of one particular assignment that the XIOS teams organize during their "xios training" workshops, the original Fortran-based version can be accessed here:
`>> svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/xios_training/hands-on-3`

Julien Derouillat of the XIOS team was kind enough to adapt this test from Fortran to C++ for us.


#### `inc/my_xios.hpp`

As opposed to Fortran it is necessary to write such a header that contains the C interfaces.
That's the one for our test.

#### `src/test_tp3.cpp`

This is our test, written in C++. Julien left all the Fortran parts as comments, they might be useful as all the doc is written for the Fortran interface, so these Fortran lines may help to relate to the relevant info in the doc, or at least understand what is being done!

#### `iodef.xml`

That's the XML file that XIOS will read when starting. In this file the domain is defined (like its shape) and also tells XIOS what to save, and potential processing to apply to fields before writing them.

That's the simplest XML configuration field one can think of... In real-world GCMs that use XIOS you would have typically a small `iodef.xml` that sources many others sub XML files as the large amount of request would make `iodef.xml` unbearably big. Example of what I have for a typical NEMO-SI3 simulation:

    iodef.xml context_nemo.xml axis_def_nemo.xml domain_def_nemo.xml field_def_nemo-oce.xml file_def_nemo-oce.xml field_def_nemo-ice.xml file_def_nemo-ice.xml grid_def_nemo.xml

This particular "complex" example can be found here in `templates/xios/example_complex_iodef_xml`, it might give you a flavor of the real-world usage of XIOS as opposed to the present tiny example!

The good news is that the XML file design is independent from the XIOS interface used, so all official documentation attached to the Fortran interface is relevant here!


### Compile the test
 
Adapt a `make.macro` file to your architecture, templates are found in the `arch/` sub-directory.
For FRAM:
`>> ln -sf arch/make.macro_FRAM-intel-2018a make.macro`
 
`>> make`

Hopefully, `test_cpp.x` is there!

It's only funny if we run several MPI instances of `test_cpp.x`, so for example run:

`>> mpirun -n 5 ./test_cpp.x`

As defined in our `iodef.xml` this should have generated `output_gridA.nc` that contains only one field. This field is kind of stupid, as you might see in `src/test_tp3.cpp`, it's just the rank of the MPI process! So you should see a map with 5 different colors/values.


​ 
--
/laurent
