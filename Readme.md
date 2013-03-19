# fink-octave-scripts

Written by Alexander Hansen <alexkhansen@users.sourceforge.net>.

Based on  script designs by Johnathan Stickel.

See the **COPYING** file for license information.

_fink-octave-scripts_ contains convenience scripts to make maintaining the various
Octave Forge (OF) (or whatever they ultimately call them) packages in Fink easier.

## Scripts 

This package consists of the following scripts:

* **octave-forge-patch.sh**:  
This is the master script, generated at install time from **octave-forge-patch.sh.in**
by substituting in the Fink prefix.  This script generates shell and Octave compile, 
install, post-install, and pre-remove scripts for each OF package at build time from 
templates installed by _this_ package.  The post-install and pre-remove scripts are needed
at .deb install and remove time, so  they are installed in the OF package, to be run in 
the `PostInstScript` or `PreRmScript`, respectively.

* **octave-forge-compile-(3.0.5|3.4.3).sh.in**:  Template for the compile phase shell script.
One of these gets converted by **octave-forge-patch.sh** to **octave-forge-compile.sh**; 
which one depends on the Octave version the package is being installed for--Octave 3.4.0 
and later only support installation from an archive. **octave-forge-compile.sh** performs
some file system operations and creates a post-patch tarball if installing for 
Octave-3.4.3 or later, then invokes **octave-forge-comp**.

* **octave-forge-comp-(3.0.5|3.4.3).in**:  Template for the compile phase Octave script. One 
of these gets converted to **octave-forge-comp**; again, which one depends on the Octave 
version the package is being installed for.  This runs the package's internal build 
procedure and installs it in a temporary location (**%b../bld**) with a temporary database 
(**bld/share/octave/\<octave version\>/octave\_packages**).

* **octave-forge-install.sh.in**:  Template for the install phase shell script
**octave-forge-install.sh**, which does the install phase filesystem operations, 
including copying the installed files over to the  .deb root directory (**%i**) as well as 
invoking **octave-forge-inst**.

* **octave-forge-inst.in**:  Template for the install phase Octave script 
**octave-forge-inst**, which changes the path information in 
**%i/share/octave/\<octave version\>/octave_packages** to match where the
files will actually be installed.

* **octave-forge-postinst.sh.in**:  Template for the shell script **octave-forge-postinst.sh**
which is called by the PostInstScript, which verifies whether the global Octave 
package database (**%p/var/octave/\<octave version\>/octave\_packages**) is a regular file of 
nonzero size, and therefore presumably a valid Octave database file.  If not, we remove the
existing file (in case it's a directory) and copy 
**%p/share/octave/\<octave version\>/octave_packages** over it.  If not, we run 
**octave-forge-postinst**.

* **octave-forge-postinst.in**:  Template for the post-install Octave script 
**octave-forge-postinst**, which appends the information from 
%p/share/octave/\<octave version\>/octave\_packages into 
%p/var/octave/\<octave version\>/octave\_packages.

* **octave-forge-prerm.sh.in**:  Template for the shell script **octave-forge-prerm.sh**
which is called by the PreRmScript and runs **octave-forge-postinst**.

* **octave-forge-prerm**:  Template for the post-install Octave script **octave-forge-prerm**,
which removes the package's entry from global Octave package database.

## Usage:

These scripts should be used in a .info file as follows:

    CompileScript: <<
    \# $pkgsrc is typically either "%type_raw[forge]" or "%type_raw[forge]-%v"

    %p/share/fink-octave-scripts/octave-forge-patch.sh %type_raw[forge] %v %type_raw[oct] %b %i $pkgsrc

    \# The above generates all of the other scripts appropriately for the package

    ./octave-forge-compile.sh
    <<

    InstallScript: ./octave-forge-install.sh

    PostInstScript:  %p/share/octave/%type_raw[oct]/%type_raw[forge]/octave-forge-postinst.sh

    PreRmScript: %p/share/octave/%type_raw[oct]/%type_raw[forge]/octave-forge-prerm.sh
