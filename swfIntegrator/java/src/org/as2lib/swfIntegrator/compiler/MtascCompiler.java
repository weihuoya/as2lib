/*
 * Created on 13.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.compiler;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;

import org.as2lib.swfIntegrator.IllegalSettingsException;
import org.as2lib.swfIntegrator.Settings;
import org.as2lib.swfIntegrator.library.Library;
import org.as2lib.swfIntegrator.library.SourceLibrary;
import org.as2lib.swfIntegrator.movie.MovieSettings;
import org.as2lib.swfIntegrator.util.Execution;
import org.as2lib.swfIntegrator.util.FileUtil;
import org.as2lib.swfIntegrator.util.MtascUtil;
import org.as2lib.swfIntegrator.util.SwfCreator;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class MtascCompiler implements Compiler {
    
    private Settings settings;
    private LibraryCompiler sourceLibraryCompiler;
    
    /**
     * @param settings The settings to set.
     */
    public void setSettings(Settings settings) {
        sourceLibraryCompiler = new MtascSourceLibraryCompiler();
        sourceLibraryCompiler.setSettings(settings);
        this.settings = settings;
    }

    /* (non-Javadoc)
     * @see org.as2lib.swfIntegrator.compiler.Compiler#generateMovie(org.as2lib.swfIntegrator.movie.MovieSettings)
     */
    public void generateMovie(MovieSettings movieSettings) {
        // TODO Auto-generated method stub
        
    }

    /* (non-Javadoc)
     * @see org.as2lib.swfIntegrator.compiler.Compiler#getLibraryCompiler(org.as2lib.swfIntegrator.library.Library)
     */
    public LibraryCompiler getLibraryCompiler(Library library) {
        if(library instanceof SourceLibrary) {
            return sourceLibraryCompiler;
        }
        throw new UnsupportedLibraryException("Mtasc Compiler can't compile "+library.getClass().getName());
    }
}
