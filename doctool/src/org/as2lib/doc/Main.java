/*
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc;

import java.io.File;
import java.util.regex.Pattern;

import org.as2lib.doc.parser.as2.AS2ClassParser;
import org.as2lib.doc.structure.Documentation;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Main {

	
	public static void main(String[] args) {
		Documentation doc = new Documentation(args[1]);
		doc.setLanguage(new AS2ClassParser());
		
			File file = new File(args[0]);
			if(file.exists()) {
				if(file.isDirectory()) {
					doc.addDirectory(file);
				} else {
					doc.addFile(file);
				}
			} else {
				System.out.println("Error: Given path cannot is not a file or directory!");
			}
		
	}
}
