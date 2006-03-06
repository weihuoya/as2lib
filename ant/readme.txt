------------------------------------
As2ant - SWF Ant Tasks - Version 1.5
------------------------------------


These tasks are programmed by Simon Wacker (http://www.simonwacker.com) and distributed
under the Mozilla Public License Version 1.1. They are part of the As2lib Open Source
ActionScript 2.0 Library (http://www.as2lib.org).


1. Mtasc Ant Task
   
   The mtasc ant task allows you to use the Motion-Twin ActionScript 2.0 Compiler (MTASC)
   in your ant build script. It supports all functionalites supported by MTASC and some
   more. The tasks does for example allow you to compile only classes matching a given
   pattern or to compile all classes of a directory and all sub-directories.
   For more information take a look at the API documentation of the org.as2lib.ant.Mtasc
   class.


2. Swfmill Ant Task

   The swfmill ant task allows you to use the XML-based SWF Processor Tool (Swfmill) in
   your ant build script. It also supports all functioanlities supported by Swfmill.
   For more information take a look at the API documentation of the org.as2lib.ant.Swfmill
   class or the swfmill samples.


3. Swf Ant Task

   The swf ant task is a conjunction of the mtasc and swfmill ant tasks. It allows you to
   create a swf, include library symbols into this swf and import classes into it, without
   having to manually write a external xml file that is based on the swfmill standard. The
   library symbols can be directly specified as attributes in the swf ant task.
   For more information take a look at the API documentation of the org.as2lib.ant.Swf class
   or the swf samples.


4. As2api Ant Task

   The as2api ant task uses as2api to generate HTML API documentation from ActionScript 2.0
   source files.
   For more information take a look at the API documentation of the org.as2lib.ant.As2api
   class.