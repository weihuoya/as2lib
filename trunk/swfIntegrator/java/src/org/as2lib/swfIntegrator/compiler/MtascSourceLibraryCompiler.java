/*
 * Created on 14.08.2005
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
public class MtascSourceLibraryCompiler implements LibraryCompiler {

    private Settings settings;
    
    public void setSettings(Settings settings) {
        this.settings = settings;
    }
    
    public void compile(String libraryName, Library library) throws IllegalSettingsException {
        
        File file = FileUtil.clearFolder(settings.getIntrinsicRoot()+"/"+libraryName);
        library.setIntrinsicLocation(file);
        
        try {
            String outputLine;
            String execution = "\""+settings.getCompiler()+"\"";
            
            Iterator libsIter = library.getRequiredLibraries().iterator();
            while(libsIter.hasNext()) {
                execution += " -cp \""+FileUtil.cleanUrl( ((Library) libsIter.next()).getIntrinsicLocation().getPath())+"\"";   
            }
            execution += " -cp \""+library.getLocation()+"\"";
            
            File source = new File(library.getLocation());
            if(source.exists()) {
                execution = MtascUtil.createPackDefinitions(source, execution);
            } else {
                throw new IllegalSettingsException("Classpath for '"+libraryName+"' is not correct: '"+library.getLocation()+"'");
            }
            String intrinsic = execution + " -rb_intrinsic_out_path \""+FileUtil.cleanUrl(file.getPath())+"\"";
            
            String libPath = settings.getWebRoot()+"/"+settings.getLibrarySwfTarget();
            FileUtil.getFolder(libPath);
            
            String filePath = libPath+"/"+library.getName()+".swf";
            
            SwfCreator.create(filePath);
            
            String swf = execution + " -cp \""+settings.getSwfIntegratorRoot()+"\" -swf \""+filePath+"\"";// -main org/as2lib/swfIntegrator/Main.as";
            
            Execution.exec("Generating "+library.getName()+" Intrinsic Definition ...", intrinsic);
            Execution.exec("Compiling "+library.getName()+".swf ...", swf);
            
        } catch (IOException e) {
            InternalError e1 = new InternalError("Couldn't compile proper.");
            e1.initCause(e);
            throw e1;
        }
    }

}
