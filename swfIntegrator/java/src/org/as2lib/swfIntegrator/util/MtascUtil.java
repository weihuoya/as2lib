/*
 * Created on 13.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.util;

import java.io.File;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class MtascUtil {

    
    public static String createPackDefinitions(File folder, String target) {
        return createPackDefinitions(folder, target, "");
    }
    
    public static String createPackDefinitions(File folder, String target, String path) {
        
        File[] subFiles = folder.listFiles();
        boolean foundAS = false;
        long timeStamp = System.currentTimeMillis();
        int i;
        for (i=0; i<subFiles.length; i++) {
            File subFile = (File) subFiles[i];
            if(subFile.isDirectory()) {
                target = createPackDefinitions(subFile, target, path+subFile.getName()+"/");
            }
            if(subFile.getName().endsWith(".as") || subFile.getName().endsWith(".asi")) {
                foundAS = true;
            }
        }
        if(foundAS) {
            target += " -pack \""+path+"\"";
        }
        return target;
    }
}
