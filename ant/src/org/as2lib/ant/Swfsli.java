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

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Execute;
import org.apache.tools.ant.types.Commandline;

/**
 * {@code Swfsli} allows to add/modify/remove the "ScriptLimits" tag of a SWF
 * file.
 *
 * <p>The "ScriptLimits" tag is recognized by Flash Player 7 and above. The Tag
 * contains 2 values:
 * <ul>
 *   <li>Maximum Recursion Depth (0..65535)</li>
 *   <li>Script Timeout Seconds (0..65535)</li>
 * </ul>
 *
 * <p>Example:
 * <pre>&lt;swfsli swf="${src.dir}/app.swf" recursion="10000" timeout="500"/&gt;</pre>
 *
 * <p>This task can take the following arguments:
 * <ul>
 *   <li>{@link #setSwf(File) swf} (SWF file to adapt the "ScriptLimits" tag of)</li>
 *   <li>{@link #setRecursion(int) recursion} (new recursion depth)</li>
 *   <li>{@link #setTimeout(int) timeout} (new script timeout)</li>
 *   <li>{@link #setDelete(boolean) delete} (remove "ScriptLimits" tag?)</li>
 *   <li>{@link #setBackup(boolean) backup} (backup original file?)</li>
 *   <li>{@link #setVerbose(boolean) verbose} (enable verbose mode?)</li>
 * </ul>
 *
 * @author Igor Sadovskiy
 * @author Simon Wacker
 * @since 29.06.2006
 * @see <a href="http://buraks.com/swfsli/" title="SWF ScriptLimits Injector (SWFSLI)">SWF ScriptLimits Injector (SWFSLI)</a>
 * @see <a href="http://ant.apache.org" title="Apache Ant">Apache Ant</a>
 */
public class Swfsli extends Task {

    private static final String SWFSLI = "swfsli";
    private static final String RECURSION = "/r";
    private static final String TIMEOUT = "/t";
    private static final String BACKUP = "/b";
    private static final String DELETE = "/d";
    private static final String VERBOSE = "/v";

    private String swfsli = SWFSLI;
    private File swf;
    private Integer recursion;
    private Integer timeout;
    private boolean backup = false;
    private boolean delete = false;
    private boolean verbose = false;

    public Swfsli() {
    }

    /**
     * Sets the path to or name of the swfsli executable.
     *
     * <p>The path can either be an absolute path:
     * <code>E:/Programming/Flash/swfsli/swfsli.exe</code>
     *
     * <p>or a relative path:
     * <code>exe/swfsli/swfsli.exe</code>
     *
     * <p>You may also just use the name of the executable (without the file
     * extension) if the directory it resides in is included in the 'PATH'
     * environment variable:
     * <code>swfsli</code>
     *
     * <p>If you do not set a swfsli executable {@link #SWFSLI} will be used. This
     * requires that you include the directory in which the swfsli executable resides
     * in the 'PATH' environment variable.
     *
     * @param swfsli the path to or name of the swfsli executable
     */
    public void setSwfsli(String swfsli) {
        this.swfsli = swfsli;
    }

    /**
     * Returns the path to or name of the swfsli executable.
     *
     * <p>If the swfsli executable has not been set, the default executable name
     * {@link #SWFSLI} will be returned.
     *
     * @return the path to or name of the swfsli executable
     */
    public String getSwfsli() {
        return swfsli;
    }

    /**
     * Sets the destination SWF file whose "ScriptLimits" tag shall be
     * added/modified/removed.
     */
    public void setSwf(File swf) {
    	this.swf = swf;
    }

    /**
     * Returns destination SWF file.
     */
    public File getSwf() {
    	return swf;
    }

    /**
     * Sets the maximum recursion depth. It must be between 0 and 65535.
     */
    public void setRecursion(int recussion) {
    	this.recursion = Integer.valueOf(recussion);
    }

    /**
     * Returns the maximum recursion depth.
     */
    public int getRecursion() {
    	return recursion.intValue();
    }

    /**
     * Sets the script timeout in seconds. It must be between 0 and 65535 seconds.
     */
    public void setTimeout(int timeout) {
    	this.timeout = Integer.valueOf(timeout);
    }

    /**
     * Returns the script timeout in seconds.
     */
    public int getTimeout() {
    	return timeout.intValue();
    }

    /**
     * Specifies whether the original SWF file shall be backed-up. The file will be
     * copied to a file with the same name but with the ".bak" extension appended.
     * For example, <code>my.swf</code> will be backed-up as <code>my.swf.bak</code>.
     */
    public void setBackup(boolean backup) {
        this.backup = backup;
    }

    /**
     * Returns whether the original SWF file will be backed-up.
     */
    public boolean isBackup() {
        return backup;
    }

    /**
     * Specifies whether the "ScriptLimits" tags shall be removed from the SWF.
     */
    public void setDelete(boolean delete) {
        this.delete = delete;
    }

    /**
     * Returns whether the "ScriptLimits" tags will be removed from the SWF.
     */
    public boolean isDelete() {
        return delete;
    }

    /**
     * Specifies whether verbode mode shall be enabled or disabled. If enabled SWFSLI
     * will display more information about warnings and errors.
     */
    public void setVerbose(boolean verbode) {
        this.verbose = verbode;
    }

    /**
     * Returns whether verbose mode is enabled or disabled.
     */
    public boolean isVerbose() {
        return verbose;
    }

    /**
     * Executes this task.
     *
     * @throws BuildException if parameters are missing or have illegal values
     */
    public void execute() throws BuildException {
        Commandline command = new Commandline();
        command.setExecutable(swfsli);
        if (swf != null) {
        	command.createArgument().setFile(swf);
        }
        if (recursion != null) {
            command.createArgument().setValue(RECURSION + recursion.toString());
        }
        if (timeout != null) {
            command.createArgument().setValue(TIMEOUT + timeout.toString());
        }
        if (backup) command.createArgument().setValue(BACKUP);
        if (delete) command.createArgument().setValue(DELETE);
        if (verbose) command.createArgument().setValue(VERBOSE);
        try {
            Execute exe = new Execute();
            exe.setAntRun(getProject());
            exe.setWorkingDirectory(getProject().getBaseDir());
            exe.setCommandline(command.getCommandline());
            log(command.toString());
            int r = exe.execute();
            if (r != 0) {
            	if (r == 1) {
            		throw new BuildException("Usage error: swfsli inputFilename /rMaxRecursionDepth /tScriptTimeoutSeconds /b /d /v", getLocation());
            	}
            	else if (r == 2) {
            		throw new BuildException("MaxRecursionDepth or ScriptTimeoutSeconds must be specified.", getLocation());
            	}
            	else if (r == 3) {
            		throw new BuildException("MaxRecursionDepth value invalid.", getLocation());
            	}
            	else if (r == 4) {
            		throw new BuildException("ScriptTimeoutSeconds value invalid.", getLocation());
            	}
            	else if (r == 5) {
            		throw new BuildException("File not found.", getLocation());
            	}
            	else if (r == 6) {
            		throw new BuildException("Could not backup file.", getLocation());
            	}
            	else if (r == 11) {
            		throw new BuildException("Error loading file.", getLocation());
            	}
            	else if (r == 12) {
            		throw new BuildException("Error modifying file.", getLocation());
            	}
            	else if (r == 13) {
            		throw new BuildException("Error saving file.", getLocation());
            	}
            	else {
            		throw new BuildException("Unknown error!", getLocation());
            	}
            }
        }
        catch (IOException e) {
            throw new BuildException("Error running " + command.getCommandline()[0] + " compiler.", e, getLocation());
        }
    }

}