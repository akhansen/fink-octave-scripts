#!/bin/sh
printf "Registering %s package with Octave-%s..." signal 3.6.4
if [ -s @FINKPREFIX@/var/octave/3.6.4/octave_packages ] && [ -f @FINKPREFIX@/var/octave/3.6.4/octave_packages ] ; then 
 	`which xvfb-run` @FINKPREFIX@/share/octave/3.6.4/signal/octave-forge-postinst
else
 	mv @FINKPREFIX@/share/octave/3.6.4/packages/signal-1.2.1/octave_packages @FINKPREFIX@/var/octave/3.6.4/octave_packages
fi
printf "Done.\n"
