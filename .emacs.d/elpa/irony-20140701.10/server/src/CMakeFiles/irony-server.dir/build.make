# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server

# Include any dependencies generated for this target.
include src/CMakeFiles/irony-server.dir/depend.make

# Include the progress variables for this target.
include src/CMakeFiles/irony-server.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/irony-server.dir/flags.make

src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o: src/CMakeFiles/irony-server.dir/flags.make
src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o: src/support/CommandLineParser.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o -c /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/support/CommandLineParser.cpp

src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.i"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/support/CommandLineParser.cpp > CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.i

src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.s"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/support/CommandLineParser.cpp -o CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.s

src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o.requires:
.PHONY : src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o.requires

src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o.provides: src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o.requires
	$(MAKE) -f src/CMakeFiles/irony-server.dir/build.make src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o.provides.build
.PHONY : src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o.provides

src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o.provides.build: src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o

src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o: src/CMakeFiles/irony-server.dir/flags.make
src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o: src/support/TemporaryFile.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o -c /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/support/TemporaryFile.cpp

src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.i"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/support/TemporaryFile.cpp > CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.i

src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.s"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/support/TemporaryFile.cpp -o CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.s

src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o.requires:
.PHONY : src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o.requires

src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o.provides: src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o.requires
	$(MAKE) -f src/CMakeFiles/irony-server.dir/build.make src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o.provides.build
.PHONY : src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o.provides

src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o.provides.build: src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o

src/CMakeFiles/irony-server.dir/Command.cpp.o: src/CMakeFiles/irony-server.dir/flags.make
src/CMakeFiles/irony-server.dir/Command.cpp.o: src/Command.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/CMakeFiles $(CMAKE_PROGRESS_3)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/CMakeFiles/irony-server.dir/Command.cpp.o"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/irony-server.dir/Command.cpp.o -c /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/Command.cpp

src/CMakeFiles/irony-server.dir/Command.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/irony-server.dir/Command.cpp.i"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/Command.cpp > CMakeFiles/irony-server.dir/Command.cpp.i

src/CMakeFiles/irony-server.dir/Command.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/irony-server.dir/Command.cpp.s"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/Command.cpp -o CMakeFiles/irony-server.dir/Command.cpp.s

src/CMakeFiles/irony-server.dir/Command.cpp.o.requires:
.PHONY : src/CMakeFiles/irony-server.dir/Command.cpp.o.requires

src/CMakeFiles/irony-server.dir/Command.cpp.o.provides: src/CMakeFiles/irony-server.dir/Command.cpp.o.requires
	$(MAKE) -f src/CMakeFiles/irony-server.dir/build.make src/CMakeFiles/irony-server.dir/Command.cpp.o.provides.build
.PHONY : src/CMakeFiles/irony-server.dir/Command.cpp.o.provides

src/CMakeFiles/irony-server.dir/Command.cpp.o.provides.build: src/CMakeFiles/irony-server.dir/Command.cpp.o

src/CMakeFiles/irony-server.dir/Irony.cpp.o: src/CMakeFiles/irony-server.dir/flags.make
src/CMakeFiles/irony-server.dir/Irony.cpp.o: src/Irony.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/CMakeFiles $(CMAKE_PROGRESS_4)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/CMakeFiles/irony-server.dir/Irony.cpp.o"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/irony-server.dir/Irony.cpp.o -c /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/Irony.cpp

src/CMakeFiles/irony-server.dir/Irony.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/irony-server.dir/Irony.cpp.i"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/Irony.cpp > CMakeFiles/irony-server.dir/Irony.cpp.i

src/CMakeFiles/irony-server.dir/Irony.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/irony-server.dir/Irony.cpp.s"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/Irony.cpp -o CMakeFiles/irony-server.dir/Irony.cpp.s

src/CMakeFiles/irony-server.dir/Irony.cpp.o.requires:
.PHONY : src/CMakeFiles/irony-server.dir/Irony.cpp.o.requires

src/CMakeFiles/irony-server.dir/Irony.cpp.o.provides: src/CMakeFiles/irony-server.dir/Irony.cpp.o.requires
	$(MAKE) -f src/CMakeFiles/irony-server.dir/build.make src/CMakeFiles/irony-server.dir/Irony.cpp.o.provides.build
.PHONY : src/CMakeFiles/irony-server.dir/Irony.cpp.o.provides

src/CMakeFiles/irony-server.dir/Irony.cpp.o.provides.build: src/CMakeFiles/irony-server.dir/Irony.cpp.o

src/CMakeFiles/irony-server.dir/TUManager.cpp.o: src/CMakeFiles/irony-server.dir/flags.make
src/CMakeFiles/irony-server.dir/TUManager.cpp.o: src/TUManager.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/CMakeFiles $(CMAKE_PROGRESS_5)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/CMakeFiles/irony-server.dir/TUManager.cpp.o"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/irony-server.dir/TUManager.cpp.o -c /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/TUManager.cpp

src/CMakeFiles/irony-server.dir/TUManager.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/irony-server.dir/TUManager.cpp.i"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/TUManager.cpp > CMakeFiles/irony-server.dir/TUManager.cpp.i

src/CMakeFiles/irony-server.dir/TUManager.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/irony-server.dir/TUManager.cpp.s"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/TUManager.cpp -o CMakeFiles/irony-server.dir/TUManager.cpp.s

src/CMakeFiles/irony-server.dir/TUManager.cpp.o.requires:
.PHONY : src/CMakeFiles/irony-server.dir/TUManager.cpp.o.requires

src/CMakeFiles/irony-server.dir/TUManager.cpp.o.provides: src/CMakeFiles/irony-server.dir/TUManager.cpp.o.requires
	$(MAKE) -f src/CMakeFiles/irony-server.dir/build.make src/CMakeFiles/irony-server.dir/TUManager.cpp.o.provides.build
.PHONY : src/CMakeFiles/irony-server.dir/TUManager.cpp.o.provides

src/CMakeFiles/irony-server.dir/TUManager.cpp.o.provides.build: src/CMakeFiles/irony-server.dir/TUManager.cpp.o

src/CMakeFiles/irony-server.dir/main.cpp.o: src/CMakeFiles/irony-server.dir/flags.make
src/CMakeFiles/irony-server.dir/main.cpp.o: src/main.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/CMakeFiles $(CMAKE_PROGRESS_6)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/CMakeFiles/irony-server.dir/main.cpp.o"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++   $(CXX_DEFINES) -DIRONY_PACKAGE_VERSION=\"0.1.0\" $(CXX_FLAGS) -o CMakeFiles/irony-server.dir/main.cpp.o -c /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/main.cpp

src/CMakeFiles/irony-server.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/irony-server.dir/main.cpp.i"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) -DIRONY_PACKAGE_VERSION=\"0.1.0\" $(CXX_FLAGS) -E /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/main.cpp > CMakeFiles/irony-server.dir/main.cpp.i

src/CMakeFiles/irony-server.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/irony-server.dir/main.cpp.s"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && /home/lagrunge/bin/extra/c++  $(CXX_DEFINES) -DIRONY_PACKAGE_VERSION=\"0.1.0\" $(CXX_FLAGS) -S /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/main.cpp -o CMakeFiles/irony-server.dir/main.cpp.s

src/CMakeFiles/irony-server.dir/main.cpp.o.requires:
.PHONY : src/CMakeFiles/irony-server.dir/main.cpp.o.requires

src/CMakeFiles/irony-server.dir/main.cpp.o.provides: src/CMakeFiles/irony-server.dir/main.cpp.o.requires
	$(MAKE) -f src/CMakeFiles/irony-server.dir/build.make src/CMakeFiles/irony-server.dir/main.cpp.o.provides.build
.PHONY : src/CMakeFiles/irony-server.dir/main.cpp.o.provides

src/CMakeFiles/irony-server.dir/main.cpp.o.provides.build: src/CMakeFiles/irony-server.dir/main.cpp.o

# Object files for target irony-server
irony__server_OBJECTS = \
"CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o" \
"CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o" \
"CMakeFiles/irony-server.dir/Command.cpp.o" \
"CMakeFiles/irony-server.dir/Irony.cpp.o" \
"CMakeFiles/irony-server.dir/TUManager.cpp.o" \
"CMakeFiles/irony-server.dir/main.cpp.o"

# External object files for target irony-server
irony__server_EXTERNAL_OBJECTS =

bin/irony-server: src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o
bin/irony-server: src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o
bin/irony-server: src/CMakeFiles/irony-server.dir/Command.cpp.o
bin/irony-server: src/CMakeFiles/irony-server.dir/Irony.cpp.o
bin/irony-server: src/CMakeFiles/irony-server.dir/TUManager.cpp.o
bin/irony-server: src/CMakeFiles/irony-server.dir/main.cpp.o
bin/irony-server: /home/lagrunge/local/lib/libclang.so
bin/irony-server: src/CMakeFiles/irony-server.dir/build.make
bin/irony-server: src/Commands.def
bin/irony-server: src/CMakeFiles/irony-server.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable ../bin/irony-server"
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/irony-server.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/irony-server.dir/build: bin/irony-server
.PHONY : src/CMakeFiles/irony-server.dir/build

src/CMakeFiles/irony-server.dir/requires: src/CMakeFiles/irony-server.dir/support/CommandLineParser.cpp.o.requires
src/CMakeFiles/irony-server.dir/requires: src/CMakeFiles/irony-server.dir/support/TemporaryFile.cpp.o.requires
src/CMakeFiles/irony-server.dir/requires: src/CMakeFiles/irony-server.dir/Command.cpp.o.requires
src/CMakeFiles/irony-server.dir/requires: src/CMakeFiles/irony-server.dir/Irony.cpp.o.requires
src/CMakeFiles/irony-server.dir/requires: src/CMakeFiles/irony-server.dir/TUManager.cpp.o.requires
src/CMakeFiles/irony-server.dir/requires: src/CMakeFiles/irony-server.dir/main.cpp.o.requires
.PHONY : src/CMakeFiles/irony-server.dir/requires

src/CMakeFiles/irony-server.dir/clean:
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src && $(CMAKE_COMMAND) -P CMakeFiles/irony-server.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/irony-server.dir/clean

src/CMakeFiles/irony-server.dir/depend:
	cd /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src /home/lagrunge/.emacs.d/elpa/irony-20140701.10/server/src/CMakeFiles/irony-server.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/irony-server.dir/depend

