/*
 * Created on 02.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.library;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.as2lib.swfIntegrator.util.FileUtil;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SourceLibrary implements Library {
    private List requiredLibraries;
    private String location;
    private File intriniscPath;
    private String name;
    
    public SourceLibrary() {
        requiredLibraries = new ArrayList();
    }

    public void setRequiredLibraries(List requiredLibraries) {
        this.requiredLibraries = requiredLibraries;
    }
    
    public List getRequiredLibraries() {
        return requiredLibraries;
    }
    
    public void setLocation(String location) {
        this.location = FileUtil.cleanUrl(location);
    }
    
    public String getLocation() {
        return location;
    }
    /**
     * @return Returns the name.
     */
    public String getName() {
        return name;
    }
    /**
     * @param name The name to set.
     */
    public void setName(String name) {
        this.name = name;
    }
    /**
     * @return Returns the sourcePath.
     */
    public File getIntrinsicLocation() {
        return intriniscPath;
    }
    /**
     * @param sourcePath The sourcePath to set.
     */
    public void setIntrinsicLocation(File location) {
        this.intriniscPath = location;
    }
}
