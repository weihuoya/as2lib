/*
 * Created on 23.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.parser;


public interface Area  {
	public String getContent();
	public boolean isComment();
	public boolean isCode();
	public boolean isDocComment();
}