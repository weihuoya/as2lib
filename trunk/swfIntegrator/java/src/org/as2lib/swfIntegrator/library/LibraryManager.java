/*
 * Created on 13.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.library;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.as2lib.swfIntegrator.IllegalSettingsException;
import org.as2lib.swfIntegrator.compiler.Compiler;
import org.as2lib.swfIntegrator.util.FileUtil;
import org.as2lib.swfIntegrator.util.MapUtil;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class LibraryManager {
    
    /** Libraries managed by this Manager */
    private Map libraries;
    
    /** Timestamps related to the last generation of libraries */
    private Map librariesGenerationTimeStamps;
    
    /** Compiler to compile the library */
    private Compiler compiler;
    
    /** Preventing recursive infinit loops with counting list of currently related libraries */
    private List justGenerating;
    
    /** Flag if it cache should be activated */
    private boolean cacheActive = false;
    
    /**
     * Creates a new LibraryManager
     * 
     * @param libraries Libraris to use for execution
     */
    public LibraryManager(Map libraries, Compiler compiler) {
        
        // Setting the name to all libraries.
        Set keySet = libraries.keySet();
        Iterator keyIterator = keySet.iterator();
        while(keyIterator.hasNext()) {
            String name = (String) keyIterator.next();
            ((Library) libraries.get(name)).setName(name);
        }
        
        this.libraries = libraries;
        this.compiler = compiler;
        librariesGenerationTimeStamps = new HashMap();
        justGenerating = new ArrayList();
    }
    
    /**
     * Validates if any Library should be updated (has been executed). 
     * 
     * @throws IllegalSettingsException
     */
    public void updateLibraries() throws IllegalSettingsException {
        updateLibraries(libraries.values());
    }   
    
    public void updateLibraries(Collection libraries) throws IllegalSettingsException {
        Iterator iter = libraries.iterator();
        long timeStamp = System.currentTimeMillis();
        while(iter.hasNext()) {
            updateLibrary((Library) iter.next(), timeStamp);
        }
        librariesGenerationTimeStamps = new HashMap();
    }
    
    public void updateLibrary(String name) throws IllegalSettingsException {
        updateLibrary(name, System.currentTimeMillis());
    }
    
    public void updateLibrary(String name, long timeStamp) throws IllegalSettingsException {
        updateLibrary((Library) libraries.get(name), timeStamp);
    }

    /**
     * Updates a certain library and all related libraries if its necessary.
     * 
     * @param libraryName Name of the certain library
     * @param library Library to update
     * @param timeStamp Last timeStamp to check
     * @throws IllegalSettingsException
     */
    public void updateLibrary( Library library,  long timeStamp) throws IllegalSettingsException {
        String libraryName = library.getName();
        
        // Recursion safety
        if(justGenerating.contains(libraryName)) {
            throw new IllegalSettingsException("Recursive library requiredments for library '"+libraryName+"'"); 
        }
        justGenerating.add(libraryName);
        
        // Check required libraries if something need to be created
        List requiredLibraries = library.getRequiredLibraries();
        Iterator i = requiredLibraries.iterator();
        boolean requiredLibraryChanged = false;
        
        while(i.hasNext()) {
            Object pureRequired = i.next();
            Library requiredLibrary = (Library) pureRequired;
            if(requiredLibrary == null) {
                throw new IllegalSettingsException("You are only allowed to set instances of 'Library' as required. '"+pureRequired.getClass().getName()+"' instance found in the requirements for '"+libraryName+"'");
            }
            String requiredLibraryName = (String) MapUtil.getKeyToValue(libraries, requiredLibrary);;
            
            Long lastGenerationOfRequired = (Long) librariesGenerationTimeStamps.get(requiredLibraryName);
            
            // Update check for library.
            if (
                    lastGenerationOfRequired == null
                    || (!isCacheActive() && lastGenerationOfRequired.longValue() < timeStamp)
                    || FileUtil.hasChanged(new File(requiredLibrary.getLocation()), lastGenerationOfRequired.longValue())
                ) {
                updateLibrary(requiredLibrary, timeStamp);
            }
            
            lastGenerationOfRequired = (Long) librariesGenerationTimeStamps.get(requiredLibraryName);
            if (lastGenerationOfRequired.longValue() > timeStamp) {
                requiredLibraryChanged = true;
            }
        }
        
        // Check library to be generated.
        Long lastGenerationOfLibrary = (Long) librariesGenerationTimeStamps.get(libraryName);
        if (
               lastGenerationOfLibrary == null 
               || requiredLibraryChanged
               || (!isCacheActive() && lastGenerationOfLibrary.longValue() < timeStamp)
               || FileUtil.hasChanged(new File(library.getLocation()), lastGenerationOfLibrary.longValue())
           ) {
            compiler.getLibraryCompiler(library).compile(libraryName, library);
            librariesGenerationTimeStamps.put(library.getName(), new Long(timeStamp));
        }
        
        justGenerating.remove(libraryName);
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
}
