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

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Execute;
import org.apache.tools.ant.taskdefs.ExecuteStreamHandler;
import org.apache.tools.ant.taskdefs.ExecuteWatchdog;
import org.apache.tools.ant.taskdefs.PumpStreamHandler;
import org.apache.tools.ant.types.Commandline;
import org.apache.tools.ant.types.EnumeratedAttribute;

/**
 * {@code Swfmill} is an ant task for swfmill that converts xml to swf and vice versa.
 *
 * <p>You can include it as task in your build file as follows; note that for this to
 * work this class must be in the classpath, either in the global one or in the one of
 * eclipse's ant plugin.
 * <p><code>&lt;taskdef name="swfmill" classname="org.as2lib.ant.SwfMill"/&gt;</code>
 *
 * <p>You can then use the declared task as any other task. The simplest usage is to
 * create a swf from a xml file (swf2xml command) or vice versa (xml2swf command).
 * <p><code>&lt;swfmill src="src.xml" dest="dest.swf"/&gt;</code>
 * <p><code>&lt;swfmill src="src.swf" dest="dest.xml"/&gt;</code>
 *
 * <p>You can also use the 'xslt' command.
 * <p><code>&lt;swfmill src="src.xml" dest="dest.swf" xsl="my.xsl"/&gt;</code>
 *
 * <p>You can also explicitly specify which command to use: 'swf2xml', 'xml2swf',
 * 'simple' or 'xslt'. This must be done when you want to use the 'simple' command.
 * <p><code>&lt;swfmill src="src.xml" dest="dest.swf" cmd="simple"/&gt;</code>
 *
 * <p>If the swfmill executable is not included as environment variable in your operating
 * system you must either include it or set it yourself for every swfmill-tag using the
 * "swfmill" attribute. Take a look at {@link #setSwfmill(String)} for more information.
 *
 * <p>This task can take the following arguments:
 * <ul>
 *   <li>
 *     {@link #setSrc(File) src} or {@link #setSource(File) source} or {@link #setIn(File) in}
 *     (swf or xml file depending on the command to use)
 *   </li>
 *   <li>
 *     {@link #setDest(File) dest} or {@link #setDestination(File) destination} or
 *     {@link #setOut(File) out} (xml or swf file depending on the command to use)
 *   </li>
 *   <li>{@link #setXsl(File) xsl} (xslt stylesheet)</li>
 *   <li>
 *     {@link #setCmd(Command) cmd} or {@link #setCommand(Command) command}
 *     (supported values: 'swf2xml', 'xml2swf', 'simple', 'xslt')
 *   </li>
 *   <li>{@link #setQuiet(boolean) quiet} (turn quiet mode on?)</li>
 *   <li>{@link #setVerbose(boolean) verbose} (turn verbose mode on?)</li>
 *   <li>{@link #setDump(boolean) dump} (dump swf data when loaded?)</li>
 *   <li>{@link #setSwfmill(String) swfmill} (path to or name of the swfmill executable)</li>
 *   <li>{@link #setHelp(boolean) help} (show help message)</li>
 * </ul>
 *
 * @author Simon Wacker
 * @since 11.06.2005
 * @see <a href="http://iterative.org/swfmill" title="Swfmill Homepage">Swfmill Homepage</a>
 * @see <a href="http://ant.apache.org" title="Apache Ant">Apache Ant</a>
 */
public class Swfmill extends Task {

    public static final String SWFMILL = "swfmill";
    public static final String SWF2XML = "swf2xml";
    public static final String XML2SWF = "xml2swf";
    public static final String SIMPLE = "simple";
    public static final String XSLT = "xslt";
    public static final String HELP = "-h";
    public static final String QUIET = "-q";
    public static final String VERBOSE = "-v";
    public static final String EXTRA_VERBOSE = "-V";
    public static final String DUMP = "-d";
    public static final String STDIN = "stdin";

    private String swfmill;
    private File source;
    private File destination;
    private File xsl;
    private String command;
    private String xml;
    private boolean help = false;
    private boolean quiet = false;
    private boolean verbose = false;
    private boolean extraVerbose = false;
    private boolean dump = false;

    /**
     * Constructs a new {@code Swfmill} instance.
     */
    public Swfmill() {
    }

    /**
     * Returns the path to or name of the swfmill executable.
     *
     * <p>If the swfmill executable has not been set, the default executable name
     * {@link #SWFMILL} will be returned.
     *
     * @return the path to or name of the swfmill executable
     */
    public String getSwfmill() {
        if (this.swfmill == null) this.swfmill = SWFMILL;
        return this.swfmill;
    }

    /**
     * Sets the path to or name of the swfmill executable.
     *
     * <p>The path can either be an absolute path:
     * <code>E:/Programming/Flash/swfmill/swfmill.exe</code>
     *
     * <p>or a relative path:
     * <code>lib/swfmill/swfmill.exe</code>
     *
     * <p>You may also just use the name of the executable (without the file
     * extension) if the directory it resides in is included in the 'PATH'
     * environment variable:
     * <code>swfmill</code>
     *
     * <p>If you do not set a swfmill executable {@link #SWFMILL} will be used. This
     * requires that you include the directory in which the swfmill executable resides
     * in the 'PATH' environment variable.
     *
     * @param swfmill the path to or name of the swfmill executable
     */
    public void setSwfmill(String swfmill) {
        this.swfmill = swfmill;
    }

    /**
     * Sets the source file. Depending on your used swfmill command this is either a
     * swf or xml file.
     *
     * @param source the source file
     */
    public void setSrc(File source) {
        this.source = source;
    }

    /**
     * Returns the source file.
     *
     * @return the set source file
     */
    public File getSrc() {
        return this.source;
    }

    /**
     * Sets the source file. Depending on your used swfmill command this is either a
     * swf or xml file.
     *
     * @param source the source file
     */
    public void setSource(File source) {
        setSrc(source);
    }

    /**
     * Return the source file.
     *
     * @return the set source file
     */
    public File getSource() {
        return getSrc();
    }

    /**
     * Sets the source file. Depending on your used swfmill command this is either a
     * swf or xml file.
     *
     * @param source the source file
     */
    public void setIn(File source) {
        setSrc(source);
    }

    /**
     * Return the source file.
     *
     * @return the set source file
     */
    public File getIn() {
        return getSrc();
    }

    /**
     * Sets the destination file. Depending on your used swfmill command this is
     * either a swf or xml file.
     *
     * @param destination the destination file
     */
    public void setDest(File destination) {
        this.destination = destination;
    }

    /**
     * Returns the destiantion file.
     *
     * @return the destination file
     */
    public File getDest() {
        return this.destination;
    }

    /**
     * Sets the destination file. Depending on your used swfmill command this is
     * either a swf or xml file.
     *
     * @param destination the destination file
     */
    public void setDestination(File destination) {
        setDest(destination);
    }

    /**
     * Returns the destiantion file.
     *
     * @return the destination file
     */
    public File getDestination() {
        return getDest();
    }

    /**
     * Sets the destination file. Depending on your used swfmill command this is
     * either a swf or xml file.
     *
     * @param destination the destination file
     */
    public void setOut(File destination) {
        setDest(destination);
    }

    /**
     * Returns the destiantion file.
     *
     * @return the destination file
     */
    public File getOut() {
        return getDest();
    }

    /**
     * Sets the xsl file if you want to use the xslt command of swfmill.
     *
     * @param xsl the xsl file
     */
    public void setXsl(File xsl) {
        this.xsl = xsl;
    }

    /**
     * Returns the xsl file.
     *
     * @return the xsl file
     */
    public File getXsl() {
        return this.xsl;
    }

    /**
     * Sets the command to use. The command is by default determined depending on the
     * file types of the set source and destination files, but you can also
     * explicitely specify the desired command.
     *
     * <p>A xml source file results in the usage of the xml2swf command by default and
     * a swf source file in the swf2xml command. If you want to use the simple command
     * you must explicitely specify this.
     *
     * <p>The xslt command is used if a xsl file is set.
     *
     * <p>Supported commands are:
     * <ul>
     *   <li>'swf2xml' converts from {@link #setIn(File) SWF} to {@link #setOut(File) XML}.</li>
     *   <li>'xml2swf' converts from {@link #setIn(File) XML} to {@link #setOut(File) SWF}.</li>
     *   <li>
     *     'simple' converts from a {@link #setIn(File) movie definition file} to
     *     {@link #setOut(File) SWF}.
     *   </li>
     *   <li>
     *     'xslt' transforms the {@link #setIn(File) input XML file} to the
     *     {@link #setOut(File) output file} as described by the
     *     {@link #setXsl(File) XSLT stylesheet}.
     *   </li>
     * </ul>
     *
     * @param command the swfmill command to use
     */
    public void setCmd(Command command) {
        this.command = command.getValue();
    }

    /**
     * Returns the swfmill command.
     *
     * @return the swfmill command
     */
    public String getCmd() {
        return this.command;
    }

    /**
     * Sets the command to use. The command is by default determined depending on the
     * file types of the set source and destination files, but you can also
     * explicitely specify the desired command.
     *
     * <p>A xml source file results in the usage of the xml2swf command by default and
     * a swf source file in the swf2xml command. If you want to use the simple command
     * you must explicitely specify this.
     *
     * <p>The xslt command is used if a xsl file is set.
     *
     * @param command the swfmill command to use
     */
    public void setCommand(Command command) {
        setCmd(command);
    }

    /**
     * Returns the swfmill command.
     *
     * @return the swfmill command
     */
    public String getCommand() {
        return getCmd();
    }

    /**
     * Sets whether to show the help message for swfmill.
     *
     * @param help determines whether to show swfmill's help message
     */
    public void setHelp(boolean help) {
        this.help = help;
    }

    /**
     * Returns whether the help message is shown.
     *
     * @return {@code true} if help messages are shown else {@code false}
     */
    public boolean getHelp() {
        return this.help;
    }

    /**
     * Sets whether to turn quiet mode on. If turned on only warnings and errors are
     * printed.
     *
     * @param quiet determines whether quiet mode is on or off
     */
    public void setQuiet(boolean quiet) {
        this.quiet = quiet;
    }

    /**
     * Returns whether quiet mode is turned on or off.
     *
     * @return {@code true} if quiet mode is turned on else {@code false}
     */
    public boolean getQuiet() {
        return this.quiet;
    }

    /**
     * Sets whether to turn verbose mode on or off. If turned on verbose output is
     * made which may be needed for debugging.
     *
     * @param verbose determines whether to turn verbose mode on or off
     */
    public void setVerbose(boolean verbose) {
        this.verbose = verbose;
    }

    /**
     * Returns whether verbose mode is turned on or off.
     *
     * @return {@code true} if verbose mode is turned on else {@code false}
     */
    public boolean getVerbose() {
        return this.verbose;
    }

    /**
     * Sets whether to make extra verbose debugging output.
     */
    public void setExtraVerbose(boolean extraVerbose) {
        this.extraVerbose = extraVerbose;
    }

    /**
     * Returns whether extra verbose debugging ouput is made.
     */
    public boolean getExtraVerbose() {
        return this.extraVerbose;
    }

    /**
     * Sets whether to dump swf data when loaded.
     *
     * @param dump determines whether to dump swf data
     */
    public void setDump(boolean dump) {
        this.dump = dump;
    }

    /**
     * Returns whether swf data is dumped.
     *
     * @return {@code true} if swf data is dumped else {@code false}
     */
    public boolean getDump() {
        return this.dump;
    }

    /**
     * Sets the swfmill xml.
     *
     * <p>You must wrap the xml in a CDATA block:
     * <pre>&lt;swfmill src="${src.dir}/com/simonwacker/ant/Sample.as" dest="${build.dir}/sample.swf"&gt;
     *  &lt;![CDATA[
     *    &lt;movie width="300" height="100" framerate="31"&gt;
     *      &lt;background color='#FF8A00'/&gt;
     *      &lt;frame&gt;
     *        &lt;library&gt;
     *          &lt;clip id="simonwacker" import="files/simonwacker.jpg"/&gt;
     *          &lt;font id="pixel" import="files/pixel.ttf"/&gt;
     *        &lt;/library&gt;
     *      &lt;/frame&gt;
     *    &lt;/movie&gt;
     *  ]]&gt;
     *&lt;/swf&gt;</pre>
     *
     * @param xml the swfmill xml to use
     */
    public void addText(String xml) {
        this.xml = xml;
    }

    /**
     * Returns the swfmill xml.
     *
     * @see #addText(String)
     */
    public String getText() {
        return this.xml;
    }

    /**
     * Executes this task.
     *
     * @throws BuildException if the build failed
     */
    public void execute() throws BuildException {
        checkParameters();
        Commandline cmd = setupCommand();
        executeCommand(cmd);
    }

    private void checkParameters() throws BuildException {
        if (this.source == null && this.xml == null) {
            throw new BuildException("The 'src', 'source' or 'in' attribute or the xml data must be set.", getLocation());
        }
    }

    private Commandline setupCommand() {
        Commandline cmd = new Commandline();
        cmd.setExecutable(getSwfmill());
        setupCommandSwitches(cmd);
        String command = evaluateCommand();
        cmd.createArgument().setValue(command);
        if (command.equals(XSLT)) {
        	cmd.createArgument().setFile(this.xsl);
        }
        if (this.source != null) {
            cmd.createArgument().setFile(this.source);
        }
        else {
            cmd.createArgument().setValue(STDIN);
        }
        if (this.destination != null) {
            cmd.createArgument().setFile(this.destination);
        }
        return cmd;
    }

    private void setupCommandSwitches(Commandline command) {
        if (this.help) command.createArgument().setValue(HELP);
        if (this.quiet) command.createArgument().setValue(QUIET);
        if (this.verbose) command.createArgument().setValue(VERBOSE);
        if (this.extraVerbose) command.createArgument().setValue(EXTRA_VERBOSE);
        if (this.dump) command.createArgument().setValue(DUMP);
    }

    private String evaluateCommand() {
        if (this.command != null) return this.command;
        if (this.xsl != null) {
            return XSLT;
        }
        if (isXmlFile(this.source)) {
            return XML2SWF;
        }
        if (isSwfFile(this.source)) {
            return SWF2XML;
        }
        return SIMPLE;
    }

    private boolean isXmlFile(File file) {
        if (file != null) {
            // are there other extension to check here
            if (getFileExtension(file).equals("xml")) {
                return true;
            }
        }
        return false;
    }

    private boolean isSwfFile(File file) {
        if (file != null) {
            // are there other extension to check here
            if (getFileExtension(file).equals("swf")) {
                return true;
            }
        }
        return false;
    }

    private String getFileExtension(File file) {
        String fileName = file.getName();
        String extension = "";
        int lastDotPosition = fileName.lastIndexOf(".");
        if (0 < lastDotPosition && lastDotPosition <= fileName.length() - 2) {
           extension = fileName.substring(lastDotPosition + 1);
        }
        return extension;
    }

    private void executeCommand(Commandline command) {
        try {
            Execute exe;
            if (this.xml != null) {
                String xml = getProject().replaceProperties(this.xml);
                InputStream bis = new ByteArrayInputStream(xml.trim().getBytes());
                DataInputStream dis = new DataInputStream(bis);
                ExecuteStreamHandler sh = new PumpStreamHandler(System.out, System.err, dis);
                exe = new Execute(sh, new ExecuteWatchdog((long) 10000));
            } else {
                exe = new Execute();
            }
            exe.setAntRun(getProject());
            exe.setWorkingDirectory(getProject().getBaseDir());
            exe.setCommandline(command.getCommandline());
            log(command.toString());
            int r = exe.execute();
            if (r != 0) {
            	throw new BuildException("Processing error!", getLocation());
            }
        } catch (IOException e) {
            throw new BuildException("Error running " + command.getCommandline()[0] + " compiler.", e, getLocation());
        }
    }

    /**
     * {@code Command} allows only for an enumerated set of string values to be set.
     * These are {@link Swfmill#SWF2XML}, {@link Swfmill#XML2SWF},
     * {@link Swfmill#SIMPLE} and {@link Swfmill#XSLT}.
     *
     * @author Simon Wacker
     */
    public static class Command extends EnumeratedAttribute {

        /**
         * Constructs a new {@code Command} class.
         */
        public Command() {
        }

        /**
         * Constructs a new {@code Command} class with a pre-defined value.
         *
         * @param value the value of this command
         */
        public Command(String value) {
            setValue(value);
        }

        /**
         * Returns the collection of allowed string values. The allowed string values
         * are {@link Swfmill#SWF2XML}, {@link Swfmill#XML2SWF}, {@link Swfmill#SIMPLE}
         * and {@link Swfmill#XSLT}.
         *
         * @return the allowed string values
         */
        public String[] getValues() {
            return new String[]{SWF2XML, XML2SWF, SIMPLE, XSLT};
        }

    }

}