/*
 * Created on 13.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.compiler;

import org.as2lib.swfIntegrator.IllegalSettingsException;
import org.as2lib.swfIntegrator.Settings;
import org.as2lib.swfIntegrator.library.Library;
import org.as2lib.swfIntegrator.library.SourceLibrary;
import org.as2lib.swfIntegrator.movie.MovieSettings;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public interface Compiler {
    public void setSettings(Settings settings);
    public LibraryCompiler getLibraryCompiler(Library library);
    public void generateMovie(MovieSettings movieSettings);
}
