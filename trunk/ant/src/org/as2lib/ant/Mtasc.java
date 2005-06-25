/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.as2lib.ant;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.taskdefs.Execute;
import org.apache.tools.ant.taskdefs.MatchingTask;
import org.apache.tools.ant.types.Commandline;
import org.apache.tools.ant.types.FileSet;
import org.apache.tools.ant.types.Path;

/**
 * {@code Mtasc} compiles ActionScript 2 classes with the Motion-Twin ActionScript
 * Compiler MTASC in Apache Ant as Ant Task.
 * 
 * <p>You must therefor daclare your custom task definition:
 * <p><code>&lt;taskdef name="mtasc" classname="org.as2lib.ant.Mtasc"/&gt;</code>
 * 
 * <p>It is now possible to reference the task by the tag/task name "mtasc". For
 * example:
 * <p><code>&lt;mtasc src="${src.dir}/Application.as" classpath="${src.dir}" main="true" swf="${src.dir}/app.swf"/&gt;</code>
 * 
 * <p>It is of course also possible to declare not only one source file but a whole
 * source directory. Note that this also includes the files of the sub-directories.
 * <p><code>&lt;mtasc srcdir="${src.dir}/org/as2lib" classpath="${src.dir}" split="yes"/&gt;</code>
 * 
 * <p>In case you only want to compile classes matching a given pattern you can use
 * "srcset".
 * <p><pre><code>&lt;mtasc classpath="${src.dir}" split="yes"&gt;
 *  &lt;srcset dir="${src.dir}"&gt;
 *    &lt;include name="**\/*Queue.as"/&gt;
 *    &lt;include name="**\/*Map.as"/&gt;
 *  &lt;/srcset>
 *&lt;/mtasc>
 * </code></pre>
 * 
 * <p>This task can take the following arguments:
 * <ul>
 *   <li>src</li>
 *   <li>srcdir</li>
 *   <li>srcset</li>
 *   <li>classpath</li>
 *   <li>verbose</li>
 *   <li>strict</li>
 *   <li>msvc</li>
 *   <li>mx</li>
 *   <li>keep</li>
 *   <li>separate</li>
 *   <li>flash6</li>
 *   <li>main</li>
 *   <li>swf</li>
 *   <li>frame</li>
 *   <li>header</li>
 *   <li>excl</li>
 *   <li>trace</li>
 *   <li>help</li>
 * </ul>
 * 
 * <p>You must either provide "src", "srcdir" or "srcset".
 * 
 * @author Simon Wacker
 * @since 28.04.2005
 * @see <a href="http://www.mtasc.org" title="Motion-Twin ActionScript Compiler">Motion-Twin ActionScript Compiler</a>
 * @see <a href="http://ant.apache.org" title="Apache Ant">Apache Ant</a>
 */
public class Mtasc extends MatchingTask {
    
    public static final String MTASC = "mtasc";
    public static final String VERBOSE = "-v";
    public static final String STRICT = "-strict";
    public static final String MSVC = "-msvc";
    public static final String MX = "-mx";
    public static final String KEEP = "-keep";
    public static final String SEPARATE = "-separate";
    public static final String FLASH6 = "-flash6";
    public static final String CLASSPATH = "-cp";
    public static final String MAIN = "-main";
    public static final String SWF = "-swf";
    public static final String FRAME = "-frame";
    public static final String HEADER = "-header";
    public static final String EXCLUDE = "-exclude";
    public static final String TRACE = "-trace";
    public static final String HELP = "-help";
    
    private List compileFiles;
    private boolean split;
    
    private Path sourceDirectory;
    private File source;
    private FileSet sourceSet;
    private Path classpath;
    private Path exclude;
    private File swf;
    private String frame;
    private String header;
    private String trace;
    private boolean help;
    private boolean verbose;
    private boolean strict;
    private boolean msvc;
    private boolean mx;
    private boolean keep;
    private boolean separate;
    private boolean flash6;
    private boolean main;
    
    /**
     * Constructs a new Mtasc instance.
     * 
     * <p>Note that {@code split} is by default set to {@code true}.
     */
    public Mtasc() {
        this.compileFiles = new ArrayList();
        this.split = true;
    }
    
    /**
     * Creates and returns a new source directory.
     * 
     * @return a new source directory
     */
    public Path createSrcdir() {
        if (this.sourceDirectory == null) {
            this.sourceDirectory = new Path(getProject());
        }
        return this.sourceDirectory.createPath();
    }
    
    /**
     * Sets the new source directory.
     * 
     * @param sourceDirectory the new source directory
     */
    public void setSrcdir(Path sourceDirectory) {
        if (this.sourceDirectory == null) {
            this.sourceDirectory = sourceDirectory;
        } else {
            this.sourceDirectory.append(sourceDirectory);
        }
    }
    
    /**
     * Returns the source directory.
     * 
     * @return the source directory
     */
    public Path getSrcdir() {
        return this.sourceDirectory;
    }
    
    /**
     * Returns the source.
     * 
     * @return the source
     */
    public File getSrc() {
        return this.source;
    }
    
    /**
     * Sets a new source.
     * 
     * @param source the new source
     */
    public void setSrc(File source) {
        this.source = source;
    }
    
    /**
     * Creates and returns a new source file set.
     * 
     * @return a new source file set
     */
    public FileSet createSrcset() {
        if (this.sourceSet == null) {
            this.sourceSet = new FileSet();
        }
        return this.sourceSet;
    }
    
    /**
     * Returns the source file set.
     * 
     * @return the source file set
     */
    public FileSet getSrcset() {
        return this.sourceSet;
    }
    
    /**
     * Sets a new source file set.
     * 
     * @param sourceSet the new source file set
     */
    public void setSrcset(FileSet sourceSet) {
        this.sourceSet = sourceSet;
    }
    
    /**
     * Creates and returns a new classpath.
     * 
     * @return the new classpath
     */
    public Path createClasspath() {
        if (this.classpath == null) {
        	this.classpath = new Path(getProject());
        }
        return this.classpath.createPath();
    }
    
    /**
     * Sets a new classpath.
     * 
     * @param classpath the new classpath
     */
    public void setClasspath(Path classpath) {
        if (this.classpath == null) {
        	this.classpath = classpath;
        } else {
        	this.classpath.append(classpath);
        }
    }
    
    /**
     * Returns the classpath.
     * 
     * @return the classpath
     */
    public Path getClasspath() {
    	return this.classpath;
    }
    
    /**
     * Creates and returns a new exclude file.
     * 
     * @return the new exclude file
     */
    public Path createExcl() {
    	if (this.exclude == null) {
        	this.exclude = new Path(getProject());
        }
        return this.exclude.createPath();
    }
    
    /**
     * Sets a new exclude file.
     * 
     * @param exclude the new exclude file
     */
    public void setExcl(Path exclude) {
    	if (this.exclude == null) {
        	this.exclude = exclude;
        } else {
        	this.exclude.append(exclude);
        }
    }
    
    /**
     * Returns the exclude file path.
     * 
     * @return the exclude file path
     */
    public Path getExcl() {
    	return this.exclude;
    }
    
    /**
     * Returns the frame.
     * 
     * @return the frame
     */
    public String getFrame() {
        return frame;
    }
    
    /**
     * Sets the frame.
     * 
     * @param frame the frame
     */
    public void setFrame(String frame) {
        this.frame = frame;
    }
    
    /**
     * Returns the header.
     * 
     * @return the header
     */
    public String getHeader() {
        return header;
    }
    
    /**
     * Sets the header.
     * 
     * @param header the header
     */
    public void setHeader(String header) {
        this.header = header;
    }
    
    /**
     * Returns the swf.
     * 
     * @return the swf
     */
    public File getSwf() {
        return swf;
    }
    
    /**
     * Sets the swf.
     * 
     * @param swf the swf
     */
    public void setSwf(File swf) {
        this.swf = swf;
    }
    
    /**
     * Returns the trace method.
     * 
     * @return the trace method
     */
    public String getTrace() {
        return trace;
    }
    
    /**
     * Sets the trace method.
     * 
     * @param trace the trace method
     */
    public void setTrace(String trace) {
        this.trace = trace;
    }
    
    /**
     * Returns whether verbose mode is turned on.
     * 
     * @return true if verbose mode is turned on else false
     */
    public boolean getVerbose() {
        return this.verbose;
    }
    
    /**
     * Sets the verbose mode.
     * 
     * @param verbose the verbose mode
     */
    public void setVerbose(boolean verbose) {
        this.verbose = verbose;
    }
    
    /**
     * Returns whether strict mode is turned on.
     * 
     * @return true if strict mode is turned on else false
     */
    public boolean getStrict() {
        return this.strict;
    }
    
    /**
     * Sets the strict mode.
     * 
     * @param strict the strict mode
     */
    public void setStrict(boolean strict) {
        this.strict = strict;
    }
    
    /**
     * Returns whether msvc error style mode is turned on.
     * 
     * @return true if msvc error style mode is turned on else false
     */
    public boolean getMsvc() {
        return this.msvc;
    }
    
    /**
     * Sets the msvc error style mode.
     * 
     * @param msvc the msvc error style mode
     */
    public void setMsvc(boolean msvc) {
        this.msvc = msvc;
    }
    
    /**
     * Returns whether to use precompiled mx classes.
     * 
     * @return true if precompiled mx classes are used else false
     */
    public boolean getMx() {
        return this.mx;
    }
    
    /**
     * Sets the whether to use precompiled mx classes.
     * 
     * @param mx determines whether to use precompiled mx classes or not
     */
    public void setMx(boolean mx) {
        this.mx = mx;
    }
    
    /**
     * Returns whether keep mode is turned on.
     * 
     * @return true if keep mode is turned on else false
     */
    public boolean getKeep() {
        return this.keep;
    }
    
    /**
     * Sets the keep mode.
     * 
     * @param keep the keep mode
     */
    public void setKeep(boolean keep) {
        this.keep = keep;
    }
    
    /**
     * Returns whether separate mode is turned on.
     * 
     * @return true if separate mode is turned on else false
     */
    public boolean getSeparate() {
        return this.separate;
    }
    
    /**
     * Sets the separate mode.
     * 
     * @param separate the separate mode
     */
    public void setSeparate(boolean separate) {
        this.separate = separate;
    }
    
    /**
     * Returns whether flash6 mode is turned on.
     * 
     * @return true if flash6 mode is turned on else false
     */
    public boolean getFlash6() {
        return this.flash6;
    }
    
    /**
     * Sets the flash6 mode.
     * 
     * @param flash6 the flash6 mode
     */
    public void setFlash6(boolean flash6) {
        this.flash6 = flash6;
    }
    
    /**
     * Returns whether main mode is turned on.
     * 
     * @return true if main mode is turned on else false
     */
    public boolean getMain() {
        return this.main;
    }
    
    /**
     * Sets the main mode.
     * 
     * @param main the main mode
     */
    public void setMain(boolean main) {
        this.main = main;
    }
    
    /**
     * Returns whether source files are splitted, this means compiled one-by-one.
     * 
     * @return true if source files are splitted else false
     */
    public boolean getSplit() {
    	return this.split;
    }
    
    /**
     * Sets whether to split source files, this means compile them one-by-one.
     * 
     * @param split determines whether to split source files
     */
    public void setSplit(boolean split) {
    	this.split = split;
    }
    
    /**
     * Returns whether the help message is printed.
     * 
     * @return true if help message is printed else false
     */
    public boolean getHelp() {
        return this.help;
    }
    
    /**
     * Sets whether to print the help message.
     * 
     * @param help determines whether to print the help message
     */
    public void setHelp(boolean help) {
        this.help = help;
    }
    
    /**
     * Executes this task.
     * 
     * @throws BuildException if neither source directory nor source set nor source file
     * is specified
     * @throws BuildException if a source does not exist
     */
    public void execute() throws BuildException {
        checkParameters();
        resetCompileFiles();
        addCompileFiles();
        compile();
    }
    
    /**
     * Checks whether the required parameters are set. This is either source directory,
     * source set or source file.
     * 
     * @throws BuildException if neither source directory nor source set nor source file
     * is specified
     */
    private void checkParameters() throws BuildException {
        if ((this.sourceDirectory == null || this.sourceDirectory.size() == 0)
        		&& (this.sourceSet == null || (!this.sourceSet.hasPatterns() && !this.sourceSet.hasSelectors()))
        		&& this.source == null) {
            throw new BuildException("Either the 'src', 'srcset' or 'srcdir' attribute must be set.", getLocation());
        }
    }
    
    /**
     * Resets the compile files.
     */
    private void resetCompileFiles() {
        this.compileFiles = new ArrayList();
    }
    
    /**
     * Adds all compile files.
     */
    private void addCompileFiles() {
        addCompileFiles(this.sourceDirectory);
        addCompileFiles(this.sourceSet);
        addCompileFile(this.source);
    }
    
    /**
     * Add compile files by a source directory.
     * 
     * <p>Searches recursively for all source files in the passed-in sourceDirectory
     * and any sub-directories.
     * 
     * @param sourceDirectory the directory to find source files in
     * @throws BuildException if a directory does not exist
     */
    private void addCompileFiles(Path sourceDirectory) throws BuildException {
        if (sourceDirectory != null && sourceDirectory.size() > 0) {
            String[] sl = sourceDirectory.list();
            for (int i = 0; i < sl.length; i++) {
                File sd = getProject().resolveFile(sl[i]);
                if (!sd.exists()) {
                    throw new BuildException("Source directory '"
                                             + sd.getPath()
                                             + "' does not exist.", getLocation());
                }
                DirectoryScanner ds = getDirectoryScanner(sd);
                ds.setCaseSensitive(true);
                ds.setIncludes(new String[] {"**/*.as"});
                String[] fl = ds.getIncludedFiles();
                for (int k = 0; k < fl.length; k++) {
                    this.compileFiles.add(new File(sourceDirectory.toString() + "/" + fl[k]));
                }
            }
        }
    }
    
    /**
     * Adds all compile files mathing the passed-in sourceSet.
     * 
     * @param sourceSet the source set to get source files from
     */
    private void addCompileFiles(FileSet sourceSet) {
        if (sourceSet != null) {
            DirectoryScanner ds = sourceSet.getDirectoryScanner(getProject());
            ds.setCaseSensitive(true);
            ds.setIncludes(new String[]{"*.as"});
            String[] fl = ds.getIncludedFiles();
            for (int k = 0; k < fl.length; k++) {
                this.compileFiles.add(new File(ds.getBasedir() + "/" + fl[k]));
            }
        }
    }
    
    /**
     * Adds the passed-in sourceFile to the compile files.
     * 
     * @param sourceFile the source file to add
     * @throws BuildException if the passed-in sourceFile does not exist
     */
    private void addCompileFile(File sourceFile) throws BuildException {
        if (sourceFile != null) {
            if (!sourceFile.exists()) {
                throw new BuildException("Source file '"
                                         + sourceFile.getPath()
                                         + "' does not exist.", getLocation());
            }
            this.compileFiles.add(sourceFile);
        }
    }
    
    /**
     * Compiles all compile files.
     */
    private void compile() {
        if (this.compileFiles.size() > 0) {
            log("Compiling " + this.compileFiles.size() + " source file"
                + (this.compileFiles.size() == 1 ? "" : "s")
				+ ".");
            if (this.split) {
            	for (int i = 0; i < this.compileFiles.size(); i++) {
            		Commandline cmd = setupCommand((File) this.compileFiles.get(i));
            		executeCommand(cmd);
            	}
            } else {
            	Commandline cmd = setupCommand();
                executeCommand(cmd);
            }
        }
    }
    
    /**
     * Sets up and returns a command for this task that includes all compile files.
     * 
     * @return the set-up command
     */
    private Commandline setupCommand() {
        Commandline cmd = new Commandline();
        cmd.setExecutable(MTASC);
        setupCommandSwitches(cmd);
        addCompileFiles(cmd);
        return cmd;
    }
    
    /**
     * Sets up and returns a command for this task that includes only the passed-in
     * compileFile.
     * 
     * @param compileFile the file to compile with this task's settings
     * @return the set-up command
     */
    private Commandline setupCommand(File compileFile) {
        Commandline cmd = new Commandline();
        cmd.setExecutable(MTASC);
        setupCommandSwitches(cmd);
        // -
        cmd.createArgument().setValue(CLASSPATH);
    	cmd.createArgument().setValue(compileFile.getParent());
        // cmd.createArgument().setValue(compileFile.getAbsolutePath());
        cmd.createArgument().setValue(compileFile.getName());
        return cmd;
    }
    
    /**
     * Sets up the command switches for the passed-in command.
     * 
     * @param command the command to set-up
     */
    private void setupCommandSwitches(Commandline command) {
        if (this.help) command.createArgument().setValue(HELP);
        if (this.swf != null) {
            command.createArgument().setValue(SWF);
            command.createArgument().setFile(this.swf);
        }
        if (this.frame != null) {
            command.createArgument().setValue(FRAME);
            command.createArgument().setValue(this.frame);
        }
        if (this.header != null) {
            command.createArgument().setValue(HEADER);
            command.createArgument().setValue(this.header);
        }
        if (this.trace != null) {
            command.createArgument().setValue(TRACE);
            command.createArgument().setValue(this.trace);
        }
        if (this.verbose) command.createArgument().setValue(VERBOSE);
        if (this.strict) command.createArgument().setValue(STRICT);
        if (this.msvc) command.createArgument().setValue(MSVC);
        if (this.mx) command.createArgument().setValue(MX);
        if (this.keep) command.createArgument().setValue(KEEP);
        if (this.separate) command.createArgument().setValue(SEPARATE);
        if (this.flash6) command.createArgument().setValue(FLASH6);
        addExcludes(command);
        addClasspaths(command);
        if (this.main) command.createArgument().setValue(MAIN);
    }
    
    /**
     * Adds all classpaths to the passed-in command.
     * 
     * @param command the command to add the classpaths to
     */
    private void addClasspaths(Commandline command) {
        if (this.classpath != null && this.classpath.size() > 0) {
            String[] a = this.classpath.list();
            for (int k = 0; k < a.length; k++) {
                String p = a[k];
                command.createArgument().setValue(CLASSPATH);
                command.createArgument().setValue(p);
            }
        }
    }
    
    /**
     * Adds all excludes to the passed-in command
     * 
     * @param command the command to add the excludes to
     */
    private void addExcludes(Commandline command) {
        if (this.exclude != null && this.exclude.size() > 0) {
            String[] a = this.exclude.list();
            for (int i = 0; i < a.length; i++) {
                String e = a[i];
                command.createArgument().setValue(EXCLUDE);
                command.createArgument().setValue(e);
            }
        }
    }
    
    /**
     * Adds the compile files to the passed-in command.
     * 
     * @param command the command to add the compile files to
     */
    private void addCompileFiles(Commandline command) {
        for (int i = 0; i < this.compileFiles.size(); i++) {
        	// String fn = ((File) this.compileFiles.get(i)).getAbsolutePath();
            String fn = ((File) this.compileFiles.get(i)).getName();
            command.createArgument().setValue(fn);
            // -
            String pp = ((File) this.compileFiles.get(i)).getParent();
        	command.createArgument().setValue(CLASSPATH);
        	command.createArgument().setValue(pp);
        }
    }
    
    /**
     * Executes the passed-in command.
     * 
     * @param command the command to execute
     * @throws BuildException if the execution failed
     */
    private void executeCommand(Commandline command) throws BuildException {
        try {
            Execute exe = new Execute();
            exe.setAntRun(getProject());
            exe.setWorkingDirectory(getProject().getBaseDir());
            exe.setCommandline(command.getCommandline());
            log(command.toString());
            int r = exe.execute();
            if (r != 0) {
            	throw new BuildException("compile error");
            }
        } catch (IOException e) {
            throw new BuildException("error running " + command.getCommandline()[0] + " compiler", e, getLocation());
        }
    }
    
}