/*
 * Created on 23.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

package org.as2lib.doc.log;

import java.util.Date;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Notice implements LogEntry {

	private String message;
	private Date date;
	
	public Notice(String message) {
		this.message = message;
		date = new Date();
	}
	
	public boolean isWarning() {
		return true;
	}
	
	public String getMessage() {
		return message;
	}
	
	public boolean isError() {
		return false;
	}
	
	public String toString() {
		StringBuffer result = new StringBuffer();
		result.append(date);
		result.append(" | ");
		result.append(message);
		return result.toString();
	}
}
