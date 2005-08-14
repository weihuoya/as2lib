/*
 * Created on 02.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import org.as2lib.swfIntegrator.PathIterator;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FileUtil {
    public static void copy (String source, String target) throws IOException {
    	File inputFile = new File("farrago.txt");
    	File outputFile = new File("outagain.txt");

        FileReader in = null;
        try {
            in = new FileReader(inputFile);
        } catch (FileNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        FileWriter out = null;
        try {
            out = new FileWriter(outputFile);
        } catch (IOException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        int c;

        while ((c = in.read()) != -1) {
            try {
                out.write(c);
            } catch (IOException e2) {
                // TODO Auto-generated catch block
                e2.printStackTrace();
            }
        }
        
        in.close();
        out.close();
    }
    public static File clearFolder(String url) {
        File file = getFolder(url);
        File[] subFiles = file.listFiles();
        int i;
        for (i=0; i<subFiles.length; i++) {
            File subFile = (File) subFiles[i];
            if(subFile.isDirectory()) {
                clearFolder(subFile.getPath());
            }
            subFile.delete();
        }
        return file;
    }
    
    public static boolean hasChanged(File file, long timeStamp) {
        if (file.isDirectory()) {
            File[] subFiles = file.listFiles();
            int i;
            for (i=0; i<subFiles.length; i++) {
                if(hasChanged((File) subFiles[i], timeStamp)) {
                    return true;
                }
            }
        } else {
            return (file.lastModified() > timeStamp);
        }
        return false;
    }

    public static File getFolder(String url){
        url = cleanUrl(url);
        File file = new File(url);
        if(file.exists()) {
	        if(!file.isDirectory()) {
	            throw new IllegalArgumentException("Applied folder "+url+" exists already as file.");
	        }
        } else {
            String[] path = url.split("/");
            int i = path.length;
            File parentFile = null;
            PathIterator pathIterator = new PathIterator((String[])path.clone());
            while(pathIterator.hasNext()) {
                String subPath = (String) pathIterator.next();
                parentFile = new File(subPath);
                i --;
                if(parentFile.exists()) {
                    if(parentFile.isDirectory()) {
                        break;
                    } else {
        	            throw new IllegalArgumentException("Applied folder "+url+" has a parent that exists already as file.");
                    }
                }
            }
            if(parentFile != null && parentFile.exists()) {
                for(; i< path.length; i++) {
                    parentFile = new File(parentFile.getPath()+"/"+((String) path[i]));
                    parentFile.mkdir();
                    
                }
                return parentFile;
            } else {
                throw new IllegalArgumentException("Couldn't find any source path for '"+url+"'");
            }
        }
        return file;
    }
    
    public static String cleanUrl(String url) {
        return url.replaceAll("\\\\", "/");
    }
}
