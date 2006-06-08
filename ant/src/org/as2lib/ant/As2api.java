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
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Execute;
import org.apache.tools.ant.types.Commandline;
import org.apache.tools.ant.types.Path;

/**
 * {@code As2api} generates HTML API documentation from ActionScript 2 source code
 * with As2api.
 *
 * <p>Example:
 * <pre>&lt;as2api package="org.as2lib.*" classpath="${dist.dir}/src"
 *    outputDir="${docs.dir}/api" dotExe="dot.exe" drawDiagrams="yes"
 *    progress="yes" title="As2lib - Open Source ActionScript 2.0 Library"
 *    sources="yes"/&gt;</pre>
 *
 * <p>This task can take the following arguments:
 * <ul>
 *   <li>{@link #setPackage(String) package} (packages containing types to document)</li>
 *   <li>
 *     {@link #setOutputDir(File) outputDir} (output directory to put generated html
 *     files into)
 *   </li>
 *   <li>{@link #setClasspath(Path) classpath} (classpaths to search for packages)</li>
 *   <li>{@link #setTitle(String) title} (title of the generated html pages)</li>
 *   <li>{@link #setProgress(boolean) progress} (show generation progress?)</li>
 *   <li>{@link #setEncoding(String) encoding} (encoding of the source files to parse)</li>
 *   <li>
 *     {@link #setDrawDiagrams(boolean) drawDiagrams} (generate class/interface
 *     inheritance diagrams?)
 *   </li>
 *   <li>{@link #setDotExe(File) dotExe} (location of the "dot" tool from Graphviz)</li>
 *   <li>
 *     {@link #setSources(boolean) sources} (generate a html page for the source code
 *     of each input file?)
 *   </li>
 *   <li>{@link #setAs2api(String) as2api} (path to or name of the as2api executable)</li>
 *   <li>{@link #setHelp(boolean) help} (show swfmill help?)</li>
 * </ul>
 *
 * <p>You must provide "package".
 *
 * @author Simon Wacker
 * @since 25.02.2006
 * @see <a href="http://www.badgers-in-foil.co.uk/projects/as2api" title="As2api">As2api</a>
 * @see <a href="http://ant.apache.org" title="Apache Ant">Apache Ant</a>
 */
public class As2api extends Task {

    private static final String AS2API = "as2api";
    private static final String HELP = "--help";
    private static final String OUTPUT_DIR = "--output-dir";
    private static final String CLASSPATH = "--classpath";
    private static final String TITLE = "--title";
    private static final String PROGRESS = "--progress";
    private static final String ENCODING = "--encoding";
    private static final String DRAW_DIAGRAMS = "--draw-diagrams";
    private static final String DOT_EXE = "--dot-exe";
    private static final String SOURCES = "--sources";

    private String as2api = AS2API;
    private List packages = new ArrayList();
    private boolean help = false;
    private File outputDir;
    private Path classpath;
    private String title;
    private boolean progress = false;
    private String encoding;
    private boolean drawDiagrams = false;
    private File dotExe;
    private boolean sources = false;

    public As2api() {
    }

    /**
     * Sets the path to or name of the as2api executable.
     *
     * <p>The path can either be an absolute path:
     * <code>E:/Programming/Flash/as2api/as2api.exe</code>
     *
     * <p>or a relative path:
     * <code>exe/as2api/as2api.exe</code>
     *
     * <p>You may also just use the name of the executable (without the file
     * extension) if the directory it resides in is included in the 'PATH'
     * environment variable:
     * <code>as2api</code>
     *
     * <p>If you do not set a as2api executable {@link #AS2API} will be used. This
     * requires that you include the directory in which the as2api executable resides
     * in the 'PATH' environment variable.
     *
     * @param as2api the path to or name of the as2api executable
     */
    public void setAs2api(String as2api) {
        this.as2api = as2api;
    }

    /**
     * Returns the path to or name of the as2api executable.
     *
     * <p>If the as2api executable has not been set, the default executable name
     * {@link #AS2API} will be returned.
     *
     * @return the path to or name of the as2api executable
     */
    public String getAs2api() {
        return as2api;
    }

    /**
     * Sets new packages containing types to document. Multple packages can be
     * separated by ';'.
     *
     * @param pazkage the new package
     */
    public void setPackage(String pazkage) {
        if (pazkage.indexOf(";") != -1) {
            String[] ps = pazkage.split(";");
            for (int i = 0; i < ps.length; i++) {
                packages.add(ps[i].trim());
            }
        }
        else {
            packages.add(pazkage);
        }
    }

    /**
     * Creates a new package containing types to document.
     *
     * @param pazkage the new package
     */
    public void addConfiguredPackage(Pazkage pazkage) {
        setPackage(pazkage.getName());
    }

    /**
     * Returns the source package.
     *
     * @return the source package
     */
    public String[] getPackages() {
        return (String[]) packages.toArray(new String[] {});
    }

    /**
     * Show help?
     */
    public void setHelp(boolean help) {
        this.help = help;
    }

    /**
     * Returns whether help is shown.
     */
    public boolean getHelp() {
        return help;
    }

    /**
     * Sets the directory into which generated HTML files shall be placed (the
     * directory will be created if required). If no output directory is specified
     * the default "apidocs" will be used.
     *
     * @param outputDir the directory to place the generated documentation into
     */
    public void setOutputDir(File outputDir) {
        this.outputDir = outputDir;
    }

    /**
     * Returns the directory into which generated HTML files are placed.
     *
     * @see #setOutputDir(File)
     */
    public File getOutputDir() {
        return outputDir;
    }

    /**
     * Sets a list of paths, delimited by ';' or ':'. Each path will be searched for
     * packages matching the given package list. If no classpath is specified, only
     * the current directory is searched.
     *
     * @param classpath the classpaths to look-for packages in
     */
    public void setClasspath(Path classpath) {
        if (this.classpath == null) {
            this.classpath = classpath;
        }
        else {
            this.classpath.append(classpath);
        }
    }

    /**
     * @see #setClasspath(Path)
     */
    public Path createClasspath() {
        if (classpath == null) {
            classpath = new Path(getProject());
        }
        return classpath.createPath();
    }

    /**
     * @see #setClasspath(Path)
     */
    public Path getClasspath() {
        return classpath;
    }

    /**
     * Sets the title to put into the titles of the generated HTML pages.
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * Returns the title put into the generated HTML pages.
     */
    public String getTitle() {
        return title;
    }

    /**
     * Shall feedback showing how far tasks have progressed be printed?
     */
    public void setProgress(boolean progress) {
        this.progress = progress;
    }

    /**
     * Returns whether feedback showing how far tasks have progress will be printed.
     */
    public boolean getProgress() {
        return progress;
    }

    /**
     * Specifies the location of the "dot" tool from Graphviz, if it is not available
     * via the standard "PATH" environment variable.
     *
     * <p>Graphviz generates class/interface inheritance diagrams for each package.
     *
     * @param dotExe
     * @see #setDrawDiagrams(boolean)
     * @see <a href="http://www.graphviz.org">Graphviz</a>
     */
    public void setDotExe(File dotExe) {
        this.dotExe = dotExe;
    }

    /**
     * @see #setDotExe(File)
     */
    public File getDotExe() {
        return dotExe;
    }

    /**
     * Shall class/interface inheritance diagrams be generated for each package? This
     * requires that you have Graphviz.
     *
     * <p>You may specify the location of the "dot" tool from Graphviz, if it is not
     * available via the standard "PATH" environment variable.
     *
     * @param drawDiagrams
     * @see #setDotExe(File)
     * @see <a href="http://www.graphviz.org">Graphviz</a>
     */
    public void setDrawDiagrams(boolean drawDiagrams) {
        this.drawDiagrams = drawDiagrams;
    }

    /**
     * Are class/interface inheritance diagrams generated for each package?
     *
     * @see #setDrawDiagrams(boolean)
     */
    public boolean isDrawDiagrams() {
        return drawDiagrams;
    }

    /**
     * Sets the encoding of the source files to be parsed.
     *
     * <p>Note that this must match the encoding of all input source files; no
     * transcoding is performed. As2api cannot handle a mixture of file encodings
     * in the set of source files to be proccessed.
     */
    public void setEncoding(String encoding) {
        this.encoding = encoding;
    }

    /**
     * Returns the encoding of the source files to be parsed.
     *
     * @see #setEncoding(String)
     */
    public String getEncoding() {
        return encoding;
    }

    /**
     * Shall a HTML page be generated for the source code of each input file?
     *
     * <p>Enables the inclusion of a copy of the source code of each documented type
     * in the generated HTML. The source will be converted to an HTML file with
     * syntax highlighting.
     */
    public void setSources(boolean sources) {
        this.sources = sources;
    }

    /**
     * @see #setSources(boolean)
     */
    public boolean isSources() {
        return sources;
    }

    /**
     * Executes this task.
     *
     * @throws BuildException if no package is specified or some other problems
     * occurred (for example a file does not exist)
     */
    public void execute() throws BuildException {
        if (packages.size() == 0) {
            throw new BuildException("At least one package must be specified.", getLocation());
        }
        Commandline command = new Commandline();
        command.setExecutable(as2api);
        if (help) command.createArgument().setValue(HELP);
        if (outputDir != null) {
            command.createArgument().setValue(OUTPUT_DIR);
            command.createArgument().setFile(outputDir);
        }
        if (classpath != null) {
            command.createArgument().setValue(CLASSPATH);
            command.createArgument().setPath(classpath);
        }
        if (title != null) {
            command.createArgument().setValue(TITLE);
            command.createArgument().setValue(title);
        }
        if (progress) command.createArgument().setValue(PROGRESS);
        if (encoding != null) {
            command.createArgument().setValue(ENCODING);
            command.createArgument().setValue(encoding);
        }
        if (drawDiagrams) command.createArgument().setValue(DRAW_DIAGRAMS);
        if (dotExe != null) {
            command.createArgument().setValue(DOT_EXE);
            command.createArgument().setFile(dotExe);
        }
        if (sources) command.createArgument().setValue(SOURCES);
        for (int i = 0; i < packages.size(); i++) {
            String pazkage = (String) packages.get(i);
            command.createArgument().setValue(pazkage);
        }
        try {
            Execute exe = new Execute();
            exe.setAntRun(getProject());
            exe.setWorkingDirectory(getProject().getBaseDir());
            exe.setCommandline(command.getCommandline());
            log(command.toString());
            int r = exe.execute();
            if (r != 0) {
                throw new BuildException("Compile error!", getLocation());
            }
        }
        catch (IOException e) {
            throw new BuildException("Error running " + command.getCommandline()[0] + " compiler.", e, getLocation());
        }
    }

    /**
     * {@code Pazkage} represents a package. A package has only one argument:
     * "name".
     */
    public static class Pazkage {

        private String name;

        public Pazkage() {
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

    }

}
