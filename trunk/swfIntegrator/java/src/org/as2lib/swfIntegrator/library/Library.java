/*
 * Created on 01.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.library;

import java.io.File;
import java.util.List;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public interface Library {
    public List getRequiredLibraries();
    public String getLocation();
    public void setIntrinsicLocation(File location);
    public File getIntrinsicLocation();
    public String getName();
    public void setName(String name);
}
