/*
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.parser.as2;

import java.util.ArrayList;

import org.as2lib.doc.parser.ClassParser;
import org.as2lib.doc.parser.InterfaceParser;
import org.as2lib.doc.parser.Language;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AS2FileParser extends AbstractLanguage implements Language {
	
	public String getClassPattern() {
		return "class";
	}
	
	public String getCommentPattern() {
		return "/*";
	}
	
	public InterfaceParser getInterfaceParser() {
		return new AS2InterfaceParser();
	}
	
	public ClassParser getClassParser() {
		return new AS2ClassParser();
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
	
	public String getBlockStartPattern() {
		return "{";
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
	
	public AS2FileParser() {
		validFileEndings = new ArrayList();
		validFileEndings.add("as");
	}
}
