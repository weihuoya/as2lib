------------------------------------
As2ant - SWF Ant Tasks - Version 2.2
------------------------------------


These tasks are programmed by Simon Wacker (http://www.simonwacker.com) and distributed
under the Mozilla Public License Version 1.1. They are part of the As2lib Open Source
ActionScript 2.0 Library (http://www.as2lib.org).


0. Files and Directories

   as2ant.jar - compiled source files (to be used as classpath in task definitions)
   build.xml - various targets to compile sources, generate documentation, create distributions
   changelog.txt - changes since the previous release
   license.txt - license under which as2ant is distributed
   readme.txt - basic information on as2ant to get started
   bin - compiled source files (binaries)
   docs - API documentation (detailed information on the usage of the tasks)
   flash - plug-in classes for as2lib unit test and asunit to be used with the unit test task
   samples - samples for the different tasks
   src - java source files


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


5. Unit Test Ant Task

   The unit test task executes a test swf and prints the test result to the console. The
   As2lib Unit Test and AsUnit frameworks are directly supported (XmlSocketTestListener or
   XmlSocketResultPrinter classes in the "flash" directory) but you may also write your own
   adapter class to plugin other unit test frameworks.
   For more information take a look at the API documentation of the org.as2lib.ant.UnitTest
   class.


6. Swfsli Ant Task

   The swfsli ant task modifies, removes or adds script limit tags (maximum recursion depth,
   script timeout) of swf files using the SWF ScriptLimits Injector (Swfsli).
   For more information take a look at the API documentation of the org.as2lib.ant.Swfsli
   class.


7. Using As2ant

   (1) Create a 'build.xml' file (take a look at 'samples/swf/build.xml' for a complete
       example):

       <project name="My Project" default="mytarget" basedir="."></project>

   (2) Add task definitions for the needed tasks ('classpath' must be an absolute or relative
       path to 'as2ant.jar' or to the folder with the compiled sources):

       <taskdef name="swf" classname="org.as2lib.ant.Swf" classpath="as2ant.jar"/>
       <taskdef name="mtasc" classname="org.as2lib.ant.Mtasc" classpath="as2ant.jar"/>
       <taskdef name="swfmill" classname="org.as2lib.ant.Swfmill" classpath="as2ant.jar"/>

   (3) Create a target which uses the defined tasks:

       <target name="mytarget" description="my target description">
         <swf src="${src.dir}/com/simonwacker/ant/MySample.as" dest="${build.dir}/mysample.swf"
             classpath="${src.dir}" width="300" height="100" framerate="31" bgcolor="FF8A00">
           <clip id="simonwacker" import="${files.dir}/simonwacker.jpg"/>
           <font id="pixel" import="${files.dir}/PixelClassic.ttf"/>
         </swf>
       </target>

   (4) Run the target:

       > With the command line (requires '{ant.home}/bin' to be part of the 'PATH' environment
         variable):

         ant mytarget

       > With Eclipse (any further builds can be triggered with the green arrow with brief
         case (External Tools)):

         Right click on your build.xml file.
         Select Run As -> Ant Build


8. Additional Eclipse Setup

   (1) Define tasks globally (frees you from defining tasks in every build.xml file):

       > Go to Window -> Preferences
       > Open Ant -> Runtime
       > Add 'as2ant.jar' as External JAR
       > Select Tasks -> Add Tasks
       > Enter a name (e.g. 'swf', 'mtasc' or 'swfmill')
       > Set 'as2ant.jar' as location
       > Go to /org/as2lib/ant in the left window below 'Location'
       > Select either 'Swf.class', 'Mtasc.class' or 'Swfmill.class', respectively
       > Click OK

   (2) ...