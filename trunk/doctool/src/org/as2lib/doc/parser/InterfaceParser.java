/*
 * Created on 23.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.parser;

import java.io.File;
import java.util.List;

import org.as2lib.doc.log.LogEntry;
import org.as2lib.doc.structure.Documentation;

/**
 * @author Martin Heidegger
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public interface InterfaceParser {
	public LogEntry parse(Documentation documentation, List header, List body, File file);
}
