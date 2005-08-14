/*
 * Created on 02.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator;

import org.as2lib.swfIntegrator.html.HtmlGenerator;
import org.as2lib.swfIntegrator.util.FileUtil;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Settings {
    private String compiler;
    private String webRoot;
    private String webLocation;
    private String librarySwfTarget;
    private String applicationSwfTarget;
    private String workingDir;
    private boolean cacheActive;
    private String swfIntegratorRoot;
    private HtmlGenerator htmlGenerator;
    
    /**
     * @return Returns the applicationSwfTarget.
     */
    public String getApplicationSwfTarget() {
        return applicationSwfTarget;
    }
    /**
     * @param applicationSwfTarget The applicationSwfTarget to set.
     */
    public void setApplicationSwfTarget(String applicationSwfTarget) {
        this.applicationSwfTarget = FileUtil.cleanUrl(applicationSwfTarget);
    }
    /**
     * @return Returns the compiler.
     */
    public String getCompiler() {
        return compiler;
    }
    /**
     * @param compiler The compiler to set.
     */
    public void setCompiler(String compiler) {
        this.compiler = FileUtil.cleanUrl(compiler);
    }
    /**
     * @return Returns the intrinsicRoot.
     */
    public String getIntrinsicRoot() {
        return workingDir+"/intrinsic";
    }
    /**
     * @return Returns the librarySwfTarget.
     */
    public String getLibrarySwfTarget() {
        return librarySwfTarget;
    }
    /**
     * @param librarySwfTarget The librarySwfTarget to set.
     */
    public void setLibrarySwfTarget(String librarySwfTarget) {
        this.librarySwfTarget = FileUtil.cleanUrl(librarySwfTarget);
    }
    /**
     * @return Returns the webLocation.
     */
    public String getWebLocation() {
        return webLocation;
    }
    /**
     * @param webLocation The webLocation to set.
     */
    public void setWebLocation(String webLocation) {
        this.webLocation = FileUtil.cleanUrl(webLocation);
    }
    /**
     * @return Returns the webRoot.
     */
    public String getWebRoot() {
        return webRoot;
    }
    /**
     * @param webRoot The webRoot to set.
     */
    public void setWebRoot(String webRoot) {
        this.webRoot = FileUtil.cleanUrl(webRoot);
    }
    /**
     * @return Returns the cacheActive.
     */
    public boolean isCacheActive() {
        return cacheActive;
    }
    /**
     * @param cacheActive The cacheActive to set.
     */
    public void setCacheActive(boolean cacheActive) {
        this.cacheActive = cacheActive;
    }
    /**
     * @return Returns the settingsRoot.
     */
    public String getSwfIntegratorRoot() {
        return swfIntegratorRoot;
    }
    /**
     * @param settingsRoot The settingsRoot to set.
     */
    public void setSwfIntegratorRoot(String swfIntegratorRoot) {
        this.swfIntegratorRoot = FileUtil.cleanUrl(swfIntegratorRoot);
    }
    /**
     * @return Returns the workingRoot.
     */
    public String getWorkingDir() {
        return workingDir;
    }
    /**
     * @param workingRoot The workingRoot to set.
     */
    public void setWorkingDir(String workingDir) {
        this.workingDir = FileUtil.cleanUrl(workingDir);
    }
    /**
     * @return Returns the htmlGenerator.
     */
    public HtmlGenerator getHtmlGenerator() {
        return htmlGenerator;
    }
    /**
     * @param htmlGenerator The htmlGenerator to set.
     */
    public void setHtmlGenerator(HtmlGenerator htmlGenerator) {
        this.htmlGenerator = htmlGenerator;
    }
}
