/*
 * Created on 13.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

import java.io.File;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.Iterator;

public class ImportGenerator {
    public static void main(String[] args) {
        if(args.length == 1) {
            String fileName = ((String)args[0]);
            File file = new File(fileName);
            if(file.exists()) {
                if(file.isDirectory()) {
                    printFiles(file, "");
                } else {
                    throw new IllegalArgumentException("The passed path is not a Directory.");
                }
            } else {
                throw new IllegalArgumentException("The passed Directory was not found");
            }
            System.out.println();
        } else if(args.length > 1) {
            throw new IllegalArgumentException("There is only one argument [directoryname] expected");
        } else {
            throw new IllegalArgumentException("There is one argument [directoryname] expected!");
        }
    }

    public static void printFiles(File directory, String parentPath) {
        File[] list = directory.listFiles();
        for(int i=0; i<list.length; i++) {
            File file = ((File)list[i]);
            if(file.isDirectory()) {
                printFiles(file, parentPath+file.getName()+".");
            } else if(file.getName().endsWith(".as")) {
                System.out.println(""+parentPath+file.getName().substring(0,file.getName().length()-3)+";");
            }
        }
    }
}