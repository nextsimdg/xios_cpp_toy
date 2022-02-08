
include make.macro

# Following ARCH-specific variables should be given into `make.macro` (look in `arch/` directory for templates)
#CC  = mpiicc
#CXX = mpiicpc
#FC  = mpiifort

#NCDF_DIR = /opt/hdf5_netcdf4_intel_par
#HDF5_DIR = /opt/hdf5_netcdf4_intel_par
#XIOS_DIR = /home/laurent/src/xios_trunk

#CFLAGS   = -std=c++11 -xHost -O2
#CXXFLAGS = -std=c++11 -xHost -O2

# Would be `-lgfortran` with gfortran:
#LIB_FC = -lifcore
#
#

INC = -I./inc -I$(XIOS_DIR)/inc -I$(XIOS_DIR)/extern/boost/include -I$(XIOS_DIR)/extern/blitz -I$(XIOS_DIR)/extern/rapidxml/include

ALL: test_cpp.x

obj/test_tp3.o: src/test_tp3.cpp
	@mkdir -p obj
	$(CXX) -w $(CXXFLAGS) -c src/test_tp3.cpp $(INC) -o obj/test_tp3.o


test_cpp.x: obj/test_tp3.o
	$(CXX) obj/test_tp3.o -o test_cpp.x  -L$(XIOS_DIR)/lib -lxios -L$(NCDF_DIR)/lib -lnetcdf  -L$(HDF5_DIR)/lib -lhdf5_hl -lhdf5 -lhdf5 $(LIB_FC)



clean:
	rm -rf obj
	rm -f test_cpp.x *.nc *.out *.err

