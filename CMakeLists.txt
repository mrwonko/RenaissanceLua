cmake_minimum_required(VERSION 2.8)

project("RenaissanceLua")

# User options
option(BUILD_SHARED_LIB "Whether to build the shared library" TRUE)
option(BUILD_STATIC_LIB "Whether to build the static library" TRUE)
option(BUILD_INTERPRETER "Whether to build the interpreter" TRUE)
option(BUILD_COMPILER "Whether to build the compiler" TRUE)
if(WIN32)
	# Windows uses native functions as setup in luaconf.h based on the _WIN32 define
	set(USE_DLOPEN FALSE)
elseif(WIN32)
	option(USE_DLOPEN "Whether to use dlfcn functions for library loading" TRUE)
endif(WIN32)
option(USE_POSIX "Whether to use Posix libraries, enabling is advised if they're available" FALSE)
option(ANSI_ONLY "Whether to avoid the use of any non-ansi feature of library (prevents using e.g. Posix libraries or dlfcn)" FALSE)

# Target names
set(STATIC_LIB_TARGET rlua_s)
set(SHARED_LIB_TARGET rlua)
set(INTERPRETER_TARGET rluai)
set(COMPILER_TARGET rluac)

# The interpreter and compiler use the static library.
if(BUILD_INTERPRETER OR BUILD_COMPILER)
	set(BUILD_STATIC_LIB TRUE)
endif(BUILD_INTERPRETER OR BUILD_COMPILER)

# Set up definitions
set(COMMON_DEFINITIONS "")
if(USE_DLOPEN)
	set(COMMON_DEFINITIONS ${COMMON_DEFINITIONS} LUA_USE_DLOPEN)
endif(USE_DLOPEN)
if(USE_POSIX)
	set(COMMON_DEFINITIONS ${COMMON_DEFINITIONS} LUA_USE_POSIX)
endif(USE_POSIX)
if(ANSI_ONLY)
	set(COMMON_DEFINITIONS ${COMMON_DEFINITIONS} LUA_ANSI)
endif(ANSI_ONLY)

# Libraries
set(COMMON_LIBRARIES "")
if(UNIX)
	# math library
	set(COMMON_LIBRARIES ${COMMON_LIBRARIES} "m")
endif(UNIX)

# File names
set(SRC_DIR src)
set(MAN_DIR doc)
set(CORE_FILES
	${SRC_DIR}/lapi.c ${SRC_DIR}/lcode.c ${SRC_DIR}/ldebug.c ${SRC_DIR}/ldo.c ${SRC_DIR}/ldump.c ${SRC_DIR}/lfunc.c ${SRC_DIR}/lgc.c ${SRC_DIR}/llex.c ${SRC_DIR}/lmem.c ${SRC_DIR}/lobject.c ${SRC_DIR}/lopcodes.c ${SRC_DIR}/lparser.c ${SRC_DIR}/lstate.c ${SRC_DIR}/lstring.c ${SRC_DIR}/ltable.c ${SRC_DIR}/ltm.c ${SRC_DIR}/lundump.c ${SRC_DIR}/lvm.c ${SRC_DIR}/lzio.c
	
	${SRC_DIR}/lua.h ${SRC_DIR}/luaconf.h ${SRC_DIR}/lapi.h ${SRC_DIR}/lobject.h ${SRC_DIR}/llimits.h ${SRC_DIR}/ldebug.h ${SRC_DIR}/lstate.h ${SRC_DIR}/ltm.h ${SRC_DIR}/lzio.h ${SRC_DIR}/lmem.h ${SRC_DIR}/ldo.h ${SRC_DIR}/lfunc.h ${SRC_DIR}/lgc.h ${SRC_DIR}/lstring.h ${SRC_DIR}/ltable.h ${SRC_DIR}/lundump.h ${SRC_DIR}/lvm.h ${SRC_DIR}/lcode.h ${SRC_DIR}/llex.h ${SRC_DIR}/lopcodes.h ${SRC_DIR}/lparser.h
	)
set(LIB_FILES
	${SRC_DIR}/lauxlib.c ${SRC_DIR}/lbaselib.c ${SRC_DIR}/ldblib.c ${SRC_DIR}/liolib.c ${SRC_DIR}/lmathlib.c ${SRC_DIR}/loslib.c ${SRC_DIR}/ltablib.c ${SRC_DIR}/lstrlib.c ${SRC_DIR}/loadlib.c ${SRC_DIR}/linit.c
	
	${SRC_DIR}/lua.h ${SRC_DIR}/luaconf.h ${SRC_DIR}/lauxlib.h ${SRC_DIR}/lualib.h
	)
set(INTERPRETER_FILES
	${SRC_DIR}/lua.c
	
	${SRC_DIR}/lua.h ${SRC_DIR}/luaconf.h ${SRC_DIR}/lauxlib.h ${SRC_DIR}/lualib.h
	)
set(COMPILER_FILES
	${SRC_DIR}/luac.c ${SRC_DIR}/print.c
	
	${SRC_DIR}/lua.h ${SRC_DIR}/luaconf.h ${SRC_DIR}/lauxlib.h ${SRC_DIR}/ldo.h ${SRC_DIR}/lobject.h ${SRC_DIR}/llimits.h ${SRC_DIR}/lstate.h ${SRC_DIR}/ltm.h ${SRC_DIR}/lzio.h ${SRC_DIR}/lmem.h ${SRC_DIR}/lfunc.h ${SRC_DIR}/lopcodes.h ${SRC_DIR}/lstring.h ${SRC_DIR}/lgc.h ${SRC_DIR}/lundump.h
	)
set(INSTALLED_INC_FILES
	${SRC_DIR}/lua.h ${SRC_DIR}/luaconf.h ${SRC_DIR}/lualib.h ${SRC_DIR}/lauxlib.h ${SRC_DIR}/../etc/lua.hpp
	)
set(INSTALLED_MAN_FILES
	${MAN_DIR}/rluai.1 ${MAN_DIR}/rluac.1
	)

set(COMMON_INCLUDE_DIRS ${SRC_DIR})

#    The targets

# static library
if(BUILD_STATIC_LIB)
	add_library(${STATIC_LIB_TARGET} ${CORE_FILES} ${LIB_FILES})
	target_link_libraries(${STATIC_LIB_TARGET} ${COMMON_LIBRARIES})
	set_target_properties(${STATIC_LIB_TARGET} PROPERTIES COMPILE_DEFINITIONS "${COMMON_DEFINITIONS}")
	set_target_properties(${STATIC_LIB_TARGET} PROPERTIES INCLUDE_DIRECTORIES "${COMMON_INCLUDE_DIRS}")
	install(TARGETS ${STATIC_LIB_TARGET}
		ARCHIVE DESTINATION "lib"
		)
endif(BUILD_STATIC_LIB)

# shared library
if(BUILD_SHARED_LIB)
	add_library(${SHARED_LIB_TARGET} SHARED ${CORE_FILES} ${LIB_FILES})
	target_link_libraries(${SHARED_LIB_TARGET} ${COMMON_LIBRARIES})
	# On windows, we need to define LUA_BUILD_AS_DLL
	if(WIN32)
		set(SHARED_LIBRARY_DEFINITIONS ${COMMON_DEFINITIONS} LUA_BUILD_AS_DLL)
	else(WIN32)
		set(SHARED_LIBRARY_DEFINITIONS ${COMMON_DEFINITIONS})
	endif(WIN32)
	set_target_properties(${SHARED_LIB_TARGET} PROPERTIES COMPILE_DEFINITIONS "${SHARED_LIBRARY_DEFINITIONS}")
	set_target_properties(${SHARED_LIB_TARGET} PROPERTIES INCLUDE_DIRECTORIES "${COMMON_INCLUDE_DIRS}")
	install(TARGETS ${SHARED_LIB_TARGET}
		RUNTIME DESTINATION "bin"
		ARCHIVE DESTINATION "lib"
		LIBRARY DESTINATION "lib"
		)
endif(BUILD_SHARED_LIB)

# library include files & manual
if(BUILD_STATIC_LIB OR BUILD_SHARED_LIB)
	install(FILES ${INSTALLED_INC_FILES}
		DESTINATION "include"
		)
	install(FILES ${INSTALLED_MAN_FILES}
		DESTINATION "man/man1"
		)
endif(BUILD_STATIC_LIB OR BUILD_SHARED_LIB)

# interpreter
if(BUILD_INTERPRETER)
	add_executable(${INTERPRETER_TARGET} ${INTERPRETER_FILES})
	target_link_libraries(${INTERPRETER_TARGET} ${STATIC_LIB_TARGET} ${COMMON_LIBRARIES})
	set_target_properties(${INTERPRETER_TARGET} PROPERTIES COMPILE_DEFINITIONS "${COMMON_DEFINITIONS}")
	set_target_properties(${INTERPRETER_TARGET} PROPERTIES INCLUDE_DIRECTORIES "${COMMON_INCLUDE_DIRS}")
	install(TARGETS ${INTERPRETER_TARGET}
		RUNTIME DESTINATION "bin"
		)
endif(BUILD_INTERPRETER)

# compiler
if(BUILD_INTERPRETER)
	add_executable(${COMPILER_TARGET} ${COMPILER_FILES})
	target_link_libraries(${COMPILER_TARGET} ${STATIC_LIB_TARGET} ${COMMON_LIBRARIES})
	set_target_properties(${COMPILER_TARGET} PROPERTIES COMPILE_DEFINITIONS "${COMMON_DEFINITIONS}")
	set_target_properties(${COMPILER_TARGET} PROPERTIES INCLUDE_DIRECTORIES "${COMMON_INCLUDE_DIRS}")
	install(TARGETS ${COMPILER_TARGET}
		RUNTIME DESTINATION "bin"
		)
endif(BUILD_INTERPRETER)