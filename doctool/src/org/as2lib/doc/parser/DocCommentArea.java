/*
 * Created on 23.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.parser;






public class DocCommentArea implements Area {
	private String content;
	public DocCommentArea(String content) {
		this.content = content;
	}
	public String getContent() {
		return content;
	}
	public boolean isComment() {
		return true;
	}
	public boolean isDocComment() {
		return true;
	}
	public boolean isCode()  {
		return false;
	}
}