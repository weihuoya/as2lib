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
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Execute;
import org.apache.tools.ant.types.Commandline;
import org.apache.tools.ant.types.FileSet;
import org.apache.tools.ant.types.Path;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

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
 * <p>If the mtasc executable is not included as environment variable in your operating
 * system you must either include it or set it yourself for every mtasc-tag using the
 * "mtasc" attribute. Take a look at {@link #setMtasc(String)} for more information.
 * 
 * <p>This task can take the following arguments:
 * <ul>
 *   <li>src</li>
 *   <li>srcdir</li>
 *   <li>srcset</li>
 *   <li>srcxml</li>
 *   <li>classpath</li>
 *   <li>verbose</li>
 *   <li>strict</li>
 *   <li>msvc</li>
 *   <li>mx</li>
 *   <li>keep</li>
 *   <li>group</li>
 *   <li>separate (MTASC versions rc2 to 1.08)</li>
 *   <li>version</li>
 *   <li>flash6 (MTASC versions 1.04 to 1.08)</li>
 *   <li>main</li>
 *   <li>swf</li>
 *   <li>out</li>
 *   <li>frame</li>
 *   <li>header</li>
 *   <li>excl or exclude</li>
 *   <li>trace</li>
 *   <li>help</li>
 *   <li>mtasc</li>
 *   <li>split</li>
 *   <li>package</li>
 *   <li>infer</li>
 * </ul>
 * 
 * <p>You must either provide "src", "srcdir", "srcset" or "srcxml".
 * 
 * @author Simon Wacker
 * @since 28.04.2005
 * @see <a href="http://www.mtasc.org" title="Motion-Twin ActionScript Compiler">Motion-Twin ActionScript Compiler</a>
 * @see <a href="http://ant.apache.org" title="Apache Ant">Apache Ant</a>
 */
public class Mtasc extends Task {
    
    public static final String MTASC = "mtasc";
    public static final String VERBOSE = "-v";
    public static final String STRICT = "-strict";
    public static final String MSVC = "-msvc";
    public static final String MX = "-mx";
    public static final String KEEP = "-keep";
    public static final String GROUP = "-group";
    public static final String CLASSPATH = "-cp";
    public static final String MAIN = "-main";
    public static final String SWF = "-swf";
    public static final String OUT = "-out";
    public static final String FRAME = "-frame";
    public static final String HEADER = "-header";
    public static final String EXCLUDE = "-exclude";
    public static final String TRACE = "-trace";
    public static final String HELP = "-help";
    public static final String VERSION = "-version";
    public static final String SEPARATE = "-separate";
    public static final String FLASH6 = "-flash6";
    public static final String PACKAGE = "-pack";
    public static final String INFER = "-infer";
    
    private String mtasc;
    private List compileFiles;
    private Path sourceDirectory;
    private File source;
    private Path pack;
    private ArrayList sourceSets;
    private ArrayList sourceList;
    private ArrayList sourceXmlList;
    private Path classpath;
    private Path exclude;
    private File swf;
    private File out;
    private String frame;
    private String header;
    private String trace;
    private String version;
    private boolean split;
    private boolean help;
    private boolean verbose;
    private boolean strict;
    private boolean msvc;
    private boolean mx;
    private boolean keep;
    private boolean separate;
    private boolean flash6;
    private boolean group;
    private boolean main;
    private boolean infer;
    
    /**
     * Constructs a new {@code Mtasc} instance.
     * 
     * <p>Note that {@code split} is by default set to {@code true}.
     */
    public Mtasc() {
        this.compileFiles = new ArrayList();
        this.sourceSets = new ArrayList();
        this.sourceList = new ArrayList();
        this.sourceXmlList = new ArrayList();
        this.split = true;
    }
    
    /**
     * Returns the path to or name of the mtasc executable.
     * 
     * <p>If the mtasc executable has not been set, the default executable name
     * {@link #MTASC} will be returned.
     * 
     * @return the path to or name of the mtasc executable
     */
    public String getMtasc() {
        if (this.mtasc == null) this.mtasc = MTASC;
        return this.mtasc;
    }
    
    /**
     * Sets the path to or name of the mtasc executable.
     * 
     * <p>The path can either be an absolute path:
     * <code>E:/Programming/Flash/mtasc/mtasc.exe</code>
     * 
     * <p>or a relative path:
     * <code>lib/mtasc/hamtasc.exe</code>
     * 
     * <p>You may also just use the name of the executable (without the file
     * extension) if the directory it resides in is included in the 'PATH'
     * environment variable:
     * <code>hamtasc</code>
     * 
     * <p>If you do not set a mtasc executable {@link #MTASC} will be used. This
     * requires that you include the directory in which the mtasc executable resides
     * in the 'PATH' environment variable.
     * 
     * @param mtasc the path to or name of the mtasc executable
     */
    public void setMtasc(String mtasc) {
        this.mtasc = mtasc;
    }
    
    /**
     * Creates and returns a new source directory.
     * 
     * @return a new source directory
     */
    public Path createSrcDir() {
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
    public void setSrcDir(Path sourceDirectory) {
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
    public Path getSrcDir() {
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
     * Adds a new source.
     * 
     * @param source the new source
     */
    public void addSrc(File source) {
        this.sourceList.add(source);
    }
    
    /**
     * Creates and returns a new source file set.
     * 
     * @return a new source file set
     */
    public FileSet createSrcSet() {
        FileSet sourceSet = new FileSet();
        this.sourceSets.add(sourceSet);
        return sourceSet;
    }
    
    /**
     * Returns the source file set.
     * 
     * @return the source file set
     */
    public FileSet[] getSrcSets() {
        return (FileSet[]) this.sourceSets.toArray(new FileSet[]{});
    }
    
    /**
     * Sets a new source file set.
     * 
     * @param sourceSet the new source file set
     */
    public void setSrcSet(FileSet sourceSet) {
        this.sourceSets.add(sourceSet);
    }
    
    /**
     * Adds a new src xml file. The src xml file must contain nodes with class-
     * attributes. The values of all class-attribues are added as src-files. The
     * class attributes' values must look as follows:
     * <code>org.as2lib.env.log.Logger</code>
     * 
     * @param srcXml the source xml to add
     */
    public void addSrcXml(File srcXml) {
        this.sourceXmlList.add(srcXml);
    }
    
    /**
     * Sets a new src xml file. The src xml file must contain nodes with class-
     * attributes. The values of all class-attribues are added as src-files. The
     * class attributes' values must look as follows:
     * <code>org.as2lib.env.log.Logger</code>
     * 
     * @param srcXml the source xml to set
     */
    public void setSrcXml(File srcXml) {
        this.sourceXmlList.add(srcXml);
    }
    
    /**
     * Creates and returns a new source package.
     * 
     * @return a new source package
     */
    public Path createPackage() {
        if (this.pack == null) {
            this.pack = new Path(getProject());
        }
        return this.pack.createPath();
    }
    
    /**
     * Sets the new source package.
     * 
     * @param pack the new source package
     */
    public void setPackage(Path pack) {
        if (this.pack == null) {
            this.pack = pack;
        } else {
            this.pack.append(pack);
        }
    }
    
    /**
     * Returns the source package.
     * 
     * @return the source package
     */
    public Path getPack() {
        return this.pack;
    }
    
    /**
     * Creates and returns a new classpath.
     * 
     * <p>Alternatively to useing the classpath-tag to specify multiple classpaths
     * you may also use the classpath-attribute and separate the various classpaths
     * with the characters ';' or ':'.
     * 
     * @return the new classpath
     * @see #setClasspath(Path)
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
     * <p>If you want to specify multiple classpaths you must separate them with the
     * characters ';' or ':', or you may not use the classpath attribute but the
     * classpath-tag inside the mtasc-tag.
     * 
     * @param classpath the new classpath
     * @see #createClasspath()
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
     * Creates and returns a new exclude file.
     * 
     * @return the new exclude file
     */
    public Path createExclude() {
    	return createExcl();
    }
    
    /**
     * Sets a new exclude file.
     * 
     * @param exclude the new exclude file
     */
    public void setExclude(Path exclude) {
    	setExcl(exclude);
    }
    
    /**
     * Returns the exclude file path.
     * 
     * @return the exclude file path
     */
    public Path getExclude() {
    	return getExcl();
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
     * <p>Only supported by MTASC versions rc2 to 1.08. Since version 1.09 'separate'
     * is the default mode and you can switch it off with the 'group' mode.
     * 
     * @param separate the separate mode
     * @see #setGroup(boolean)
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
     * <p>Only supported by MTASC versions 1.04 to 1.08. Since version 1.09 the
     * 'version' attribute can be used instead.
     * 
     * @param flash6 the flash6 mode
     * @see #setVersion(String)
     */
    public void setFlash6(boolean flash6) {
        this.flash6 = flash6;
    }
    
    /**
     * Returns whether group mode is turned on.
     * 
     * @return true if goup mode is turned on else false
     */
    public boolean getGroup() {
        return this.group;
    }
    
    /**
     * Turns the group mode on.
     * 
     * <p>Supported since version 1.09. Use the 'separate' mode in previous
     * versions.
     * 
     * @param group the group mode
     * @see #setSeparate(boolean)
     */
    public void setGroup(boolean group) {
        this.group = group;
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
     * Returns the version of the output swf.
     * 
     * @return the version of the output swf
     */
    public String getVersion() {
        return this.version;
    }
    
    /**
     * Sets the version of the ouput swf.
     * 
     * <p>Supported since version 1.09. Use the 'flash6' attribute in previous
     * versions if you want to compile Flash 6 SWFs.
     * 
     * @param version the version of the output swf
     * @see #setFlash6(boolean)
     */
    public void setVersion(String version) {
        this.version = version;
    }
    
    /**
     * Returns the output swf.
     * 
     * @return the output swf
     */
    public File getOut() {
        return this.out;
    }
    
    /**
     * Sets the output swf.
     * 
     * <p>Supported since version 1.08.
     * 
     * @param out the output swf
     */
    public void setOut(File out) {
        this.out = out;
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
     * Returns whether local variables inference is turned on.
     * 
     * @return true if local variables inference is turned on else false
     */
    public boolean getInfer() {
        return this.infer;
    }
    
    /**
     * Turns local variables inference on.
     * 
     * @param infer determines whether to turn local variables inference on or off
     */
    public void setInfer(boolean infer) {
        this.infer = infer;
    }
    
    /**
     * Returns whether this mtasc task has any sources to compile.
     * 
     * @return true if this mtasc task has any sources else false
     */
    public boolean hasSources() {
        if ((this.sourceDirectory == null || this.sourceDirectory.size() == 0)
                && this.sourceSets.size() == 0
                && this.source == null
                && this.sourceList.size() == 0
                && (this.pack == null || this.pack.size() == 0)) {
            return false;
        }
        return true;
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
     * source set, source file, source xml or pack.
     * 
     * @throws BuildException if neither source directory nor source set nor source file
     * nor source xml is specified
     */
    private void checkParameters() throws BuildException {
        if ((this.sourceDirectory == null || this.sourceDirectory.size() == 0)
        		&& this.sourceSets.size() == 0
        		&& this.source == null
                && this.sourceList.size() == 0
                && this.sourceXmlList.size() == 0
                && (this.pack == null || this.pack.size() == 0)) {
            throw new BuildException("Either 'src', 'srcset', 'srcxml', 'srcdir' or 'pack' must be set.", getLocation());
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
        addCompileFilesByXmlFiles((File[]) this.sourceXmlList.toArray(new File[]{}));
        addCompileFiles(this.sourceDirectory);
        addCompileFiles((File[]) this.sourceList.toArray(new File[]{}));
        addCompileFiles((FileSet[]) this.sourceSets.toArray(new FileSet[]{}));
        addCompileFile(this.source);
    }
    
    /**
     * Adds all source files declared in the given xml files to the compile files list.
     * 
     * @param xmlFiles the xml files to look for source files in
     */
    private void addCompileFilesByXmlFiles(File[] xmlFiles) {
        for (int i = 0; i < xmlFiles.length; i++) {
            File file = xmlFiles[i];
            InputStream is = null;
            try {
                DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                DocumentBuilder builder = factory.newDocumentBuilder();
                is = new FileInputStream(file);
                Document doc = builder.parse(is);
                Element root = doc.getDocumentElement();
                addCompileFiles(root);
            } catch (ParserConfigurationException e) {
                e.printStackTrace();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (SAXException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (is != null) {
                    try {
                        is.close();
                    }
                    catch (IOException ex) {
                        log("Could not close input stream.");
                    }
                }
            }
        }
    }
    
    /**
     * Adds all source files contained in the given node to the compile files list.
     * 
     * @param node the node to look for source files in
     */
    private void addCompileFiles(Node node) {
        NodeList nl = node.getChildNodes();
        for (int i = 0; i < nl.getLength(); i++) {
            Node n = nl.item(i);
            if (n instanceof Element) {
                Element e = (Element) n;
                if (e.hasAttribute("class")){
                    String clazz = e.getAttribute("class");
                    clazz = clazz.replace(".", "/");
                    clazz += ".as";
                    addCompileFile(new File(clazz));
                }
            }
            if (n.hasChildNodes()) {
                addCompileFiles(n);
            }
        }
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
                DirectoryScanner ds = new DirectoryScanner();
                ds.setBasedir(sd);
                ds.setCaseSensitive(true);
                ds.setIncludes(new String[] {"**/*.as"});
                ds.scan();
                String[] fl = ds.getIncludedFiles();
                for (int k = 0; k < fl.length; k++) {
                    addCompileFile(new File(sourceDirectory.toString() + "/" + fl[k]));
                }
            }
        }
    }
    
    /**
     * Adds all source files in the given sourceList to the compile files list.
     * 
     * @param sourceList the list of source files to add
     */
    private void addCompileFiles(File[] sourceList) {
        if (sourceList != null && sourceList.length > 0) {
            for (int i = 0; i < sourceList.length; i++) {
                addCompileFile(sourceList[i]);
            }
        }
    }
    
    /**
     * Adds all compile files mathing the passed-in sourceSet.
     * 
     * @param sourceSet the source set to get source files from
     */
    private void addCompileFiles(FileSet[] sourceSets) {
        if (sourceSets != null && sourceSets.length > 0) {
            for (int i = 0; i < sourceSets.length; i++) {
                FileSet ss = sourceSets[i];
	            DirectoryScanner ds = ss.getDirectoryScanner(getProject());
	            ds.setCaseSensitive(true);
	            ds.setIncludes(new String[]{"*.as"});
	            String[] fl = ds.getIncludedFiles();
	            for (int k = 0; k < fl.length; k++) {
	                addCompileFile(new File(ds.getBasedir() + "/" + fl[k]));
	            }
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
            if (sourceFile.isAbsolute()) {
                String p = sourceFile.getPath();
                String[] classpaths = classpath.list();
                for (int i = 0; i < classpaths.length; i++) {
                    String cp = classpaths[i];
                    if (p.startsWith(cp)) {
                        this.compileFiles.add(new File(p.substring(cp.length() + 1)));
                        return;
                    }
                }
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
        cmd.setExecutable(getMtasc());
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
        cmd.setExecutable(getMtasc());
        setupCommandSwitches(cmd);
        if (compileFile.isAbsolute()) {
            cmd.createArgument().setValue(CLASSPATH);
        	cmd.createArgument().setValue(compileFile.getParent());
            cmd.createArgument().setValue(compileFile.getName());
        } else {
            cmd.createArgument().setValue(compileFile.getPath());
        }
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
        if (this.out != null) {
            command.createArgument().setValue(OUT);
            command.createArgument().setFile(this.out);
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
        if (this.version != null) {
            command.createArgument().setValue(VERSION);
            command.createArgument().setValue(this.version);
        }
        if (this.verbose) command.createArgument().setValue(VERBOSE);
        if (this.strict) command.createArgument().setValue(STRICT);
        if (this.msvc) command.createArgument().setValue(MSVC);
        if (this.mx) command.createArgument().setValue(MX);
        if (this.keep) command.createArgument().setValue(KEEP);
        if (this.group) command.createArgument().setValue(GROUP);
        if (this.separate) command.createArgument().setValue(SEPARATE);
        if (this.flash6) command.createArgument().setValue(FLASH6);
        if (this.infer) command.createArgument().setValue(INFER);
        addExcludes(command);
        addClasspaths(command);
        addPackages(command);
        if (this.main) command.createArgument().setValue(MAIN);
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
     * Adds all packages to the given command.
     * 
     * @param command the command to add the packages to
     */
    private void addPackages(Commandline command) {
        if (this.pack != null && this.pack.size() > 0) {
            String[] a = this.pack.list();
            for (int i = 0; i < a.length; i++) {
                String p = a[i];
                command.createArgument().setValue(PACKAGE);
                command.createArgument().setValue(p);
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
            File cf = (File) this.compileFiles.get(i);
            if (cf.isAbsolute()) {
                command.createArgument().setValue(CLASSPATH);
                command.createArgument().setValue(cf.getParent());
                command.createArgument().setValue(cf.getName());
            } else {
                command.createArgument().setValue(cf.getPath());
            }
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