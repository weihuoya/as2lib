/*
 * Created on 23.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.parser.as2;

import java.io.File;
import java.util.List;

import org.as2lib.doc.log.LogEntry;
import org.as2lib.doc.log.Notice;
import org.as2lib.doc.parser.InterfaceParser;
import org.as2lib.doc.structure.Documentation;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AS2InterfaceParser implements InterfaceParser {

	public AS2InterfaceParser() {
		
	}
	
	/* (non-Javadoc)
	 * @see org.as2lib.doc.parser.InterfaceParser#parse(org.as2lib.doc.structure.Documentation, java.util.List, java.util.List)
	 */
	public LogEntry parse(Documentation documentation, List header, List body, File file) {
		// TODO Auto-generated method stub
		return new Notice("Well parsed ");
	}

}
