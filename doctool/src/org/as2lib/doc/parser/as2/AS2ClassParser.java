/*
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.parser.as2;

import java.io.File;
import java.util.ArrayList;

import org.as2lib.doc.log.LogEntry;
import org.as2lib.doc.log.Notice;
import org.as2lib.doc.log.Warning;
import org.as2lib.doc.parser.Language;
import org.as2lib.doc.structure.Documentation;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AS2ClassParser extends AbstractLanguage implements Language {
	
	public String getClassPattern() {
		return "class";
	}
	
	public String getCommentPattern() {
		return "/*";
	}
	
	public String getSingleLineCommentPattern() {
		return "//";
	}
	
	public String getDocumentationCommentPattern() {
		return "/**";
	}
	
	public String getCommentEndPattern() {
		return "*/";
	}
	
	public String getExtendsPattern() {
		return "extends";
	}
	
	public String getImplementedPattern() {
		return "implements";
	}
	
	public String getInterfacePattern() {
		return "interface";
	}
	
	public AS2ClassParser() {
		validFileEndings = new ArrayList();
		validFileEndings.add("as");
		fileNamePattern = ".";
	}
}
