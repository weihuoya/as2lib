/*
 * Created on 14.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.compiler;

import org.as2lib.swfIntegrator.IllegalSettingsException;
import org.as2lib.swfIntegrator.Settings;
import org.as2lib.swfIntegrator.library.Library;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public interface LibraryCompiler {
    public void setSettings(Settings settings);
    public void compile(String libraryName, Library library) throws IllegalSettingsException;
}
