CXX=g++
BAMTOOLS_ROOT=bamtools
VCFLIB_ROOT=vcflib
BAMTOOLS_LIB_DIR=bamtools/lib
CXXFLAGS=-O3
INCLUDES=-I$(BAMTOOLS_ROOT)/include -I$(VCFLIB_ROOT) -L./ -L$(VCFLIB_ROOT)/tabixpp -ltabix #-L$(BAMTOOLS_ROOT)/lib

all: uniqprimers

# builds vcflib
$(VCFLIB_ROOT)/Variant.o:
	cd vcflib && $(MAKE)

# builds bamtools static lib, and copies into root
libbamtools.a:
	cd $(BAMTOOLS_ROOT) && mkdir -p build && cd build && cmake .. && $(MAKE)
	cp bamtools/lib/libbamtools.a ./

# statically compiles bamaddrg against bamtools static lib
uniqprimers: uniqprimers.cpp libbamtools.a $(VCFLIB_ROOT)/Variant.o
	$(CXX) $(CXXFLAGS) $(VCFLIB_ROOT)/Variant.o $(VCFLIB_ROOT)/smithwaterman/SmithWatermanGotoh.o $(VCFLIB_ROOT)/tabixpp/tabix.o $(VCFLIB_ROOT)/tabixpp/bgzf.o $(VCFLIB_ROOT)/split.cpp uniqprimers.cpp -o uniqprimers $(INCLUDES) -lbamtools -lz -lm

clean:
	cd vcflib && $(MAKE) clean
	cd bamtools && $(MAKE) clean
	rm -f uniqprimers libbamtools.a *.o

.PHONY: clean
