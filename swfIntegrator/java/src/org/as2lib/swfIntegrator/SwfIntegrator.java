/*
 * Created on 02.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator;

import java.util.Map;

import org.as2lib.swfIntegrator.compiler.Compiler;
import org.as2lib.swfIntegrator.compiler.MtascCompiler;
import org.as2lib.swfIntegrator.library.Library;
import org.as2lib.swfIntegrator.library.LibraryManager;
import org.as2lib.swfIntegrator.movie.MovieSettings;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.FileSystemResource;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SwfIntegrator {
    
    private Settings settings;
    private XmlBeanFactory configuration;
    private Map libraries;
    private LibraryManager libraryManager;
    private Compiler compiler;
    
    public void setConfiguration(String url) throws IllegalSettingsException {
        
        configuration = new XmlBeanFactory(new FileSystemResource(url));
        
        Map allSettings = configuration.getBeansOfType(Settings.class);
        if(allSettings.isEmpty()) {
            throw new IncompleteSettingsException("No bean is of class 'org.as2lib.swfIntegrator.Settings'");
        }
        
        settings = (Settings) allSettings.values().iterator().next();
        compiler = new MtascCompiler();
        compiler.setSettings(settings);
        settings.getHtmlGenerator().setSettings(settings);
        libraryManager = new LibraryManager(configuration.getBeansOfType(Library.class), compiler);
    }

    /**
     * Generates a movie that is defined in the configuration
     * 
     * @param id Id of the certain Movie
     * @throws IllegalSettingsException
     */
    public String getMovie(String id) throws IllegalSettingsException {
        MovieSettings movieSettings = (MovieSettings) configuration.getBean(id);
        if(movieSettings == null) {
            throw new IncompleteSettingsException("There are no MovieSettings with id: "+id);
        }
        return getMovie(movieSettings);
    } 
    
    public String getMovie(MovieSettings movieSettings) throws IllegalSettingsException {
        libraryManager.updateLibraries(movieSettings.getRequiredLibraries());
        compiler.generateMovie(movieSettings);
        return settings.getHtmlGenerator().createSwfCode(movieSettings);
    }
}
