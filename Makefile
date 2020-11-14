CC=g++

# Flag for debugging runs
# CFLAGS=-O0 -g -std=c++11 -pthread -mrtm -msse4.1 -mavx2

# Flag for test runs
CFLAGS=-O3 -std=c++11 -pthread -mrtm -msse4.1 -mavx2
#CFLAGS_LBTREE=-O3 -std=c++11 -pthread -mrtm -msse4.1 -mavx2 -fpic
CFLAGS_LBTREE=-O0 -g -std=c++11 -pthread -mrtm -msse4.1 -mavx2 -fpic

INCLUDE=-I./common
PIBENCH_WRAPPER_INCLUDE=-I${PIBENCH_DIR}/include

LIB=-lpmem
PIBENCH_WRAPPER_LIB=-L./ -llbtree

COMMON_DEPENDS= ./common/tree.h ./common/tree.cc ./common/keyinput.h ./common/mempool.h ./common/mempool.cc ./common/nodepref.h ./common/nvm-common.h ./common/nvm-common.cc ./common/performance.h
COMMON_SOURCES= ./common/tree.cc ./common/mempool.cc ./common/nvm-common.cc

# -----------------------------------------------------------------------------
TARGETS=liblbtree_pibench_wrapper.so

#wbtree fptree

all: ${TARGETS}

# -----------------------------------------------------------------------------

liblbtree.so: lbtree-src/lbtree.h lbtree-src/lbtree.cc ${COMMON_DEPENDS}
	${CC} -shared -o $@ ${CFLAGS_LBTREE} ${INCLUDE} lbtree-src/lbtree.cc ${COMMON_SOURCES} ${LIB}

liblbtree_pibench_wrapper.so: liblbtree.so pibench-wrapper/wrapper.h pibench-wrapper/wrapper.cc
	${CC} -shared -o $@ ${CFLAGS_LBTREE} ${INCLUDE} ${PIBENCH_WRAPPER_INCLUDE} pibench-wrapper/wrapper.cc ${PIBENCH_WRAPPER_LIB}

fptree: fptree-src/fptree.h fptree-src/fptree.cc ${COMMON_DEPENDS}
	${CC} -o $@ ${CFLAGS} ${INCLUDE} fptree-src/fptree.cc ${COMMON_SOURCES} ${LIB}

wbtree: wbtree-src/wbtree.h wbtree-src/wbtree.cc ${COMMON_DEPENDS}
	${CC} -o $@ ${CFLAGS} ${INCLUDE} wbtree-src/wbtree.cc ${COMMON_SOURCES} ${LIB}

# -----------------------------------------------------------------------------
clean:
	-rm -rf a.out core *.s *.so
