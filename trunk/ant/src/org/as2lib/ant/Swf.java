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

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;

import org.apache.tools.ant.BuildException;

/**
 * {@code Swf} creates swf files with the XML-based SWF Processing Tool (Swfmill),
 * that enables the inclusion of symbols, and compiles classes into this swf using
 * the Motion-Twin ActionScript 2.0 Compiler (MTASC).
 * 
 * <p>This task can be seen as a conjunction of the {@link Mtasc} and the
 * {@link Swfmill} tasks. The advantage of using this class instead of the other
 * classes directly is that it is more intuitive.
 * 
 * <p>As with any other task the first thing you must do is add a task definition
 * to your build file.
 * <p><code>&lt;taskdef name="swf" classname="org.as2lib.ant.Swf"/&gt;</code>
 * 
 * <p>If your class is not included in the CLASSPATH environment variable in Windows
 * you must explicitely specify the classpath.
 * <p><code>&lt;taskdef name="swf" classname="org.as2lib.ant.Swf" classpath="ant/src"/&gt;</code>
 * 
 * <p>You can now use this task as any other task.
 * <pre><code>&lt;swf src="${src.dir}/MyMain.as" dest="${dest.dir}/main.swf" width="300" height="300" framerate="31" bgcolor="00FFFF"&gt;
 *  &lt;clip id="myClip" import="${images.dir}/image.jpg"/&gt;
 *  &lt;font id="myFont" import="${fonts.dir}/font.ttf" glyphs="0123456789"/&gt;
 *  &lt;import file="${imports.dir}/import.swf" url="http://www.simonwacker.com/import.swf"/&gt;
 *&lt;/swf&gt;</code></pre>
 * 
 * <p>It is also possible to nest clips, fonts and imports respectively.
 * <pre><code>&lt;swf src="${src.dir}/MyMain.as" dest="${dest.dir}/main.swf" width="300" height="300" framerate="31" bgcolor="00FFFF"&gt;
 *  &lt;clip&gt;
 *    &lt;include id="clip1" import="${images.dir}/image1.jpg"/&gt;
 *    &lt;include id="clip2" import="${images.dir}/image2.jpg"/&gt;
 *    &lt;include id="clip3" import="${images.dir}/image3.jpg"/&gt;
 *  &lt;/clip&gt;
 *  &lt;font&gt;
 *    &lt;include id="font1" import="${fonts.dir}/font1.ttf" glyphs="0123456789"/&gt;
 *    &lt;include id="font2" import="${fonts.dir}/font2.ttf" glyphs="0123456789"/&gt;
 *  &lt;/font&gt;
 *  &lt;import file="${imports.dir}/import.swf" url="http://www.simonwacker.com/import.swf"/&gt;
 *&lt;/swf&gt;</code></pre>
 * 
 * <p>This task can take the following arguments:
 * <ul>
 *   <li>src or source or class or clazz</li>
 *   <li>dest or destination or swf</li>
 *   <li>classpath</li>
 *   <li>width</li>
 *   <li>height</li>
 *   <li>fps or framerate</li>
 *   <li>bgcolor or backgroundcolor or bg or color</li>
 *   <li>clip</li>
 *   <li>font</li>
 *   <li>import</li>
 *   <li>excl</li>
 *   <li>help</li>
 *   <li>verbose</li>
 *   <li>header (width:height:fps:bgcolor)</li>
 *   <li>strict</li>
 *   <li>msvc</li>
 *   <li>mx</li>
 *   <li>keep</li>
 *   <li>separate</li>
 *   <li>flash6</li>
 *   <li>main</li>
 *   <li>frame</li>
 *   <li>trace</li>
 *   <li>srcdir</li>
 *   <li>srcset</li>
 * </ul>
 * 
 * @author Simon Wacker
 * @since 15.06.2005
 * @see <a href="http://www.mtasc.org" title="Motion-Twin ActionScript Compiler">Motion-Twin ActionScript Compiler</a>
 * @see <a href="http://iterative.org/swfmill" title="Swfmill Homepage">Swfmill Homepage</a>
 * @see <a href="http://ant.apache.org" title="Apache Ant">Apache Ant</a>
 */
public class Swf extends Mtasc {
    
    /** Default file path and name for xml file needed by swfmill. */
    public static final String XML = "swfmill.xml";
    
    private Swfmill swfmill;
    private int width;
    private int height;
    private int framerate;
    private String backgroundColor;
    private Clip clip;
    private Font font;
    private Import imp;
    
    /**
     * Constructs a new {@code Swf} instance.
     */
    public Swf() {
        this.swfmill = new Swfmill();
        this.swfmill.setSrc(new File(XML));
        this.swfmill.setCommand(new Swfmill.Command(Swfmill.SIMPLE));
        setMain(true);
        setWidth(800);
        setHeight(600);
        setFramerate(31);
        setBackgroundColor("FFFFFF");
    }
    
    /**
     * Sets the destination swf file.
     * 
     * @param destination the destination swf file
     */
    public void setDest(File destination) {
        super.setSwf(destination);
        this.swfmill.setDest(destination);
    }
    
    /**
     * Returns the destination swf file.
     * 
     * @return the destination swf file
     */
    public File getDest() {
        return super.getSwf();
    }
    
    /**
     * Sets the destination swf file.
     * 
     * @param destination the destination swf file
     */
    public void setDestination(File destination) {
        setDest(destination);
    }
    
    /**
     * Returns the destination swf file.
     * 
     * @return the destination swf file
     */
    public File getDestination() {
        return getDest();
    }
    
    /**
     * Sets the destination swf file.
     * 
     * @param destination the destination swf file
     */
    public void setSwf(File destination) {
        setDest(destination);
    }
    
    /**
     * Returns the destination swf file.
     * 
     * @return the destination swf file
     */
    public File getSwf() {
        return getDest();
    }
    
    /**
     * Sets the source or main class.
     * 
     * @param source the source or main class
     */
    public void setSource(File source) {
        setSrc(source);
    }
    
    /**
     * Returns the source or main class.
     * 
     * @return the source or main class
     */
    public File getSource() {
        return getSrc();
    }
    
    /**
     * Sets the source or main class.
     * 
     * @param source the source or main class
     */
    public void setClazz(File source) {
        setSrc(source);
    }
    
    /**
     * Sets the source or main class.
     * 
     * @param source the source or main class
     */
    public void setClass(File source) {
        setSrc(source);
    }
    
    /**
     * Returns the source or main class.
     * 
     * @return the source or main class
     */
    public File getClazz() {
        return getSrc();
    }
    
    /**
     * Sets the stage width of the swf.
     * 
     * @param width the stage widht of the swf
     */
    public void setWidth(int width) {
        this.width = width;
    }
    
    /**
     * Returns the stage width of the swf.
     * 
     * @return the stage height of the swf
     */
    public int getWidth() {
        return this.width;
    }
    
    /**
     * Sets the stage height of the swf.
     * 
     * @param height the stage height of the swf
     */
    public void setHeight(int height) {
        this.height = height;
    }
    
    /**
     * Returns the stage height of the swf.
     * 
     * @return the stage height of the swf
     */
    public int getHeight() {
        return this.height;
    }
    
    /**
     * Sets the framerate or frames per second.
     * 
     * @param framerate the framerate or frames per second
     */
    public void setFps(int framerate) {
        this.framerate = framerate;
    }
    
    /**
     * Returns the framerate or frames per second of the swf.
     * 
     * @return the framerate or frames per second
     */
    public int getFps() {
        return this.framerate;
    }
    
    /**
     * Sets the framerate.
     * 
     * @param framerate the framerate of the swf
     */
    public void setFramerate(int framerate) {
        setFps(framerate);
    }
    
    /**
     * Returns the framerate of the swf.
     * 
     * @return the framerate
     */
    public int getFramerate() {
        return getFps();
    }
    
    /**
     * Sets the background color.
     * 
     * @param backgroundColor the background color
     */
    public void setBgColor(String backgroundColor) {
        this.backgroundColor = backgroundColor;
    }
    
    /**
     * Returns the background color.
     * 
     * @return the background color
     */
    public String getBgColor() {
        return this.backgroundColor;
    }
    
    /**
     * Sets the background color.
     * 
     * @param backgroundColor the background color
     */
    public void setBackgroundColor(String backgroundColor) {
        setBgColor(backgroundColor);
    }
    
    /**
     * Returns the background color.
     * 
     * @return the background color
     */
    public String getBackgroundColor() {
        return getBgColor();
    }
    
    /**
     * Sets the background color.
     * 
     * @param backgroundColor the background color
     */
    public void setBg(String backgroundColor) {
        setBgColor(backgroundColor);
    }
    
    /**
     * Returns the background color.
     * 
     * @return the background color
     */
    public String getBg() {
        return getBgColor();
    }
    
    /**
     * Sets the background color.
     * 
     * @param backgroundColor the background color
     */
    public void setColor(String backgroundColor) {
        setBgColor(backgroundColor);
    }
    
    /**
     * Returns the background color.
     * 
     * @return the background color
     */
    public String getColor() {
        return getBgColor();
    }

    /**
     * Creates a new clip (MovieClip or Graphic library symbol) to include in the swf.
     * 
     * <p>The returnd clip can alsobe used as container for multiple clips that shall
     * be included.
     * 
     * @return the created clip
     */
    public Clip createClip() {
        if (this.clip == null) {
        	this.clip = new Clip();
        }
        return this.clip;
    }
    
    /**
     * Returns the clip to include in the swf.
     * 
     * @return the clip to include in the swf
     */
    public Clip getClip() {
    	return this.clip;
    }
    
    /**
     * Creates a new font to include in the swf.
     * 
     * <p>The returned font can also be used as container for multiple fonts that
     * shall be included.
     * 
     * @return the created font
     */
    public Font createFont() {
        if (this.font == null) {
        	this.font = new Font();
        }
        return this.font;
    }
    
    /**
     * Returns the font to include in the swf.
     * 
     * @return the font to include in the swf
     */
    public Font getFont() {
    	return this.font;
    }
    
    /**
     * Creates a new shared library import that specifies the swf to import as
     * library.
     * 
     * <p>The returnd shared library import can also be used as container for multiple
     * shared library imports.
     * 
     * @return the created shared library import
     */
    public Import createImport() {
        if (this.imp == null) {
            this.imp = new Import();
        }
        return this.imp;
    }
    
    /**
     * Returns the shared library import that specifies the swf to import as library.
     * 
     * @return the shared library import that specifies the swf to import as library
     */
    public Import getImport() {
        return this.imp;
    }
    
    /**
     * Sets whether to show the help messages for mtasc and swfmill.
     * 
     * @param help determines whether to show help messages for mtasc and swfmill
     */
    public void setHelp(boolean help) {
        super.setHelp(help);
        this.swfmill.setHelp(help);
    }
    
    /**
     * Sets whether the actions performed by mtasc and swfmill shall be printed to
     * the commmand line. This is done by switching verbose mode for mtasc and swfmill
     * on.
     * 
     * @param verbose determines whether to switch on verbose mode for mtasc and
     * swfmill
     */
    public void setVerbose(boolean verbose) {
        super.setVerbose(verbose);
        this.swfmill.setVerbose(verbose);
    }
    
    /**
     * Sets the header information of the swf to compile. The passed-in argument
     * {@code header} can be a string composed of the following elements:
     * <pre>width:height:fps:bgcolor</pre>
     * 
     * <p>Note that every part of this header string is optional.
     * 
     * @param header the header information of the swf to compile
     */
    public void setHeader(String header) {
        String[] parts = header.split(":");
        switch (parts.length) {
            case 4:
                setBackgroundColor(parts[3]);
            case 3:
                setFramerate(new Integer(parts[2]).intValue());
            case 2:
                setHeight(new Integer(parts[1]).intValue());
            case 1:
                setWidth(new Integer(parts[0]).intValue());
        }
    }
    
    /**
     * Executes this swf task.
     * 
     * @throws BuildException if the build failed
     */
    public void execute() throws BuildException {
        createXmlFile();
        this.swfmill.setProject(getProject());
        swfmill.execute();
        super.execute();
    }
    
    /**
     * Creates the xml file needed by swfmill.
     */
    private void createXmlFile() {
        try {
            OutputStream os = new BufferedOutputStream(new FileOutputStream(XML));
            OutputStreamWriter ow = new OutputStreamWriter(os);
            ow.write("<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>\n\n");
            ow.write("<movie");
            ow.write(" width=\"" + new Integer(this.width).toString() + "\"");
            ow.write(" height=\"" + new Integer(this.height).toString() + "\"");
            ow.write(" framerate=\"" + new Integer(this.framerate).toString() + "\"");
            ow.write(">\n");
            if (this.backgroundColor != null) {
                ow.write("  <background color='#" + this.backgroundColor + "'/>\n");
            }
            if (this.clip != null || this.font != null || this.imp != null) {
                ow.write("  <frame>\n");
                ow.write("    <library>\n");
                if (this.clip != null) {
                    writeClip(this.clip, ow);
                    Clip[] includes = this.clip.getIncludes();
                    for (int i = 0; i < includes.length; i++) {
                        writeClip(includes[i], ow);
                    }
                }
                if (this.font != null) {
                    writeFont(this.font, ow);
                    Font[] includes = this.font.getIncludes();
                    for (int i = 0; i < includes.length; i++) {
                        writeFont(includes[i], ow);
                    }
                }
                if (this.imp != null) {
                    writeImport(this.imp, ow);
                    Import[] includes = this.imp.getIncludes();
                    for (int i = 0; i < includes.length; i++) {
                        writeImport(includes[i], ow);
                    }
                }
                ow.write("    </library>\n");
                ow.write("  </frame>\n");
            }
            ow.write("</movie>");
            ow.flush();
            ow.close();
        } catch (IOException e) {
            throw new BuildException("problem on generating '" + XML + "'");
        }
    }
    
    private void writeClip(Clip clip, OutputStreamWriter outputWriter) throws IOException {
        if (clip != null) {
            outputWriter.write("      <clip");
            if (clip.getId() != null) {
                outputWriter.write(" id=\"" + clip.getId() + "\"");
            }
            if (clip.getImport() != null) {
                outputWriter.write(" import=\"" + clip.getImport() + "\"");
            }
            if (clip.getClazz() != null) {
                outputWriter.write(" class=\"" + clip.getClazz() + "\"");
            }
            outputWriter.write("/>\n");
        }
    }
    
    private void writeFont(Font font, OutputStreamWriter outputWriter) throws IOException {
        if (font != null) {
            outputWriter.write("      <font");
	        if (font.getId() != null) {
	            outputWriter.write(" id=\"" + font.getId() + "\"");
	        }
	        if (font.getImport() != null) {
	            outputWriter.write(" import=\"" + font.getImport() + "\"");
	        }
	        if (font.getGlyphs() != null) {
	            outputWriter.write(" glyphs=\"" + font.getGlyphs() + "\"");
	        }
	        outputWriter.write("/>\n");
        }
    }
    
    private void writeImport(Import imp, OutputStreamWriter outputWriter) throws IOException {
        if (imp != null) {
            outputWriter.write("      <import");
            if (imp.getFile() != null) {
                outputWriter.write(" file=\"" + imp.getFile() + "\"");
            }
            if (imp.getUrl() != null) {
                outputWriter.write(" url=\"" + imp.getUrl() + "\"");
            }
            outputWriter.write("/>\n");
        }
    }
    
    /**
     * {@code Symbol} represents a library symbol that consists of an id (identifier)
     * corresponding to a movieclip, image or font.
     * 
     * @author Simon Wacker
     */
    public static class Symbol {
        
        private String id;
        private File path;
        
        /**
         * Constructs a new {@code Symbol} instance.
         */
        public Symbol() {
        }
        
        /**
         * Sets the path of the file, mostly a swf or image file, to import.
         * 
         * @param path the file to import
         */
        public void setImport(File path) {
            this.path = path;
        }
        
        /**
         * Returns the path of the file to include in the swf as library symbol.
         * 
         * @return the path of the library symbol
         */
        public File getImport() {
            return this.path;
        }
        
        /**
         * Sets the id (identifier) of the library symbol.
         * 
         * @param id the id of the library symbol
         */
        public void setId(String id) {
            this.id = id;
        }
        
        /**
         * Returns the id (identifier) of the library symbol.
         * 
         * @return the id of the library symbol
         */
        public String getId() {
            return this.id;
        }
        
    }
    
    /**
     * {@code Clip} represents a clip library symbol. This is either a movieclip or a
     * graphic library symbol.
     * 
     * @author Simon Wacker
     */
    public static class Clip extends Symbol {
        
        private List includes;
        private File clazz;
        
        /**
         * Constructs a new {@code Clip} instance.
         */
        public Clip() {
            this.includes = new ArrayList();
        }
        
        /**
         * Sets the class to associate with the clip.
         * 
         * @param clazz the class of the clip
         */
        public void setClass(File clazz) {
            this.clazz = clazz;
        }
        
        /**
         * Returns the class to associate with the clip.
         * 
         * @return the class of the clip
         */
        public File getClazz() {
            return this.clazz;
        }
        
        /**
         * Creates a new included clip, if this clip instance is used as container for
         * multiple clips.
         * 
         * @return the created included clip
         */
        public Clip createInclude() {
            Clip clip = new Clip();
            this.includes.add(clip);
            return clip;
        }
        
        /**
         * Returns the collection of all included clips.
         * 
         * @return the collection of all included clips
         */
        public Clip[] getIncludes() {
            return (Clip[]) this.includes.toArray(new Clip[]{});
        }
        
    }
    
    /**
     * {@code Font} represents a font library symbol to include in the swf.
     * 
     * @author Simon Wacker
     */
    public static class Font extends Symbol {
        
        private String glyphs;
        private List includes;
        
        /**
         * Constructs a new {@code Font} instance.
         */
        public Font() {
            this.includes = new ArrayList();
        }
        
        /**
         * Sets the characters of the font that shall be included.
         * 
         * @param glyphs the characters of the font to include
         */
        public void setGlyphs(String glyphs) {
            this.glyphs = glyphs;
        }
        
        /**
         * Returns the characters of the font that shall be included.
         * 
         * @return the font's characters that shall be included
         */
        public String getGlyphs() {
            return this.glyphs;
        }
        
        /**
         * Creates a new included font if this font instance is used as container.
         * 
         * @return the created included font
         */
        public Font createInclude() {
            Font font = new Font();
            this.includes.add(font);
            return font;
        }
        
        /**
         * Returns all included fonts.
         * 
         * @return all included fonts
         */
        public Font[] getIncludes() {
            return (Font[]) this.includes.toArray(new Font[]{});
        }
        
    }
    
    /**
     * {@code Import} represents a shared library import. The specified swf is
     * imported as library.
     * 
     * @author Simon Wacker
     */
    public static class Import {
        
        private File file;
        private URI url;
        private List includes;
        
        /**
         * Constructs a new {@code Import} instance.
         */
        public Import() {
            this.includes = new ArrayList();
        }
        
        /**
         * Sets the swf file to import as shared library.
         * 
         * @param file the swf file to import as shared library
         */
        public void setFile(File file) {
            this.file = file;
        }
        
        /**
         * Returns the swf file to import as shared library.
         * 
         * @return the swf file to import as shared library
         */
        public File getFile() {
            return this.file;
        }
        
        /**
         * Sets the url to the swf file of the shared library.
         * 
         * @param url the url to the swf file of the shared library
         */
        public void setUrl(URI url) {
            this.url = url;
        }
        
        /**
         * Returns the url to the swf file of the shared library.
         * 
         * @return the url to the swf file of the shared library
         */
        public URI getUrl() {
            return this.url;
        }
        
        /**
         * Creates a new included shared library import. This shared library import is
         * then used as container for further shared library imports.
         * 
         * @return the created and included shared library imports
         */
        public Import createInclude() {
            Import i = new Import();
            this.includes.add(i);
            return i;
        }
        
        /**
         * Returns all included shared library imports.
         * 
         * @return all included shared library imports
         */
        public Import[] getIncludes() {
            return (Import[]) this.includes.toArray(new Import[]{});
        }
        
    }
    
}