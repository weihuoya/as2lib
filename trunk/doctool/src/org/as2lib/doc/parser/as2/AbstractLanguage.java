/*
 * Created on 23.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.parser.as2;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.as2lib.doc.log.*;
import org.as2lib.doc.log.Error;
import org.as2lib.doc.parser.Area;
import org.as2lib.doc.parser.ClassParser;
import org.as2lib.doc.parser.CodeArea;
import org.as2lib.doc.parser.CommentArea;
import org.as2lib.doc.parser.DocCommentArea;
import org.as2lib.doc.parser.InterfaceParser;
import org.as2lib.doc.structure.Documentation;


/**
 * @author main
 *s
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
abstract class AbstractLanguage {
	
	protected List validFileEndings;
	
	abstract protected String getClassPattern();
	abstract protected String getInterfacePattern();
	abstract protected String getBlockStartPattern();
	abstract protected String getExtendsPattern();
	abstract protected String getImplementedPattern();
	abstract protected String getCommentPattern();
	abstract protected String getCommentEndPattern();
	abstract protected String getDocumentationCommentPattern();
	abstract protected String getSingleLineCommentPattern();
	abstract protected InterfaceParser getInterfaceParser();
	abstract protected ClassParser getClassParser();
	
	public LogEntry parse(File file, Documentation documentation) {
		if(isValidFileName(file.getName()))  {
			
			List content = seperateComments(getFileContent(file));
			
			// Analyse class properties and seperate classcontent from header definition.
			List header = new ArrayList();
			List body = new ArrayList();
			boolean typeMarkerFound = false;
			boolean typeStartFound = false;
			boolean isClass = false;
			boolean isInterface = false;
			String classPattern = getClassPattern();
			String interfacePattern = getInterfacePattern();
			String blockStartPattern = getBlockStartPattern();
			for(Iterator i = content.iterator(); i.hasNext();) {
				Area area = (Area)i.next();
				if(!typeStartFound) {
					if(area.isCode())  {
						String areaContent = area.getContent();
						if(areaContent.indexOf(classPattern) > 0) {
							isClass = true;
							typeMarkerFound = true;
						} else if(areaContent.indexOf(interfacePattern) > 0) {
							isInterface = true;
							typeMarkerFound = true;
						}
						int blockStart = areaContent.indexOf(blockStartPattern);
						if(typeMarkerFound && blockStart > 0) {
							typeStartFound = true;
							if(blockStart == areaContent.length()-1) {
								header.add(area);
							} else {
								String beforeBlockStart = areaContent.substring(0, blockStart+1);
								String afterBlockStart = areaContent.substring(blockStart+1);
								header.add(new CodeArea(beforeBlockStart));
								body.add(new CodeArea(afterBlockStart));
							}
						} else {
							header.add(area);
						}
					}
				} else {
					body.add(area);
				}
			}
			
			if(isClass) {
				return getClassParser().parse(documentation, header, body, file);
			} else if (isInterface) {
				return getInterfaceParser().parse(documentation, header, body, file);
			} else {
				return new Error("File '"+file.getPath()+"' doesn't match to a class/interface definition.");
			}
		} else {
			return new Warning("Used file '"+file.getPath()+" doesn't match the language filename restrictions.");
		}
	}
	
	protected List seperateComments(String pureContent) {
		// BIG Part: Construction of all real code (without any comment)
		// Seperation of all comment blocks(!) to seperate the corret code
		// TODO: There is a problem with the "// /*" Case
		boolean startingWithComment = false;
		if(pureContent.indexOf(getCommentPattern())==0) {
			startingWithComment = true;
		}
		
		String[] commentSeperated = pureContent.split("\\Q"+getCommentPattern()+"\\E");
		List content = new ArrayList();
		for(int i=0; i<commentSeperated.length; i++) {
			if( 	(i%2 == 0 && startingWithComment )
				||  (i%2 != 0 && !startingWithComment)
			   ) {
				int j = i;
				// Checks if the End of the comment block is here
				while(commentSeperated[i].indexOf(getCommentEndPattern()) < 0 && i<commentSeperated.length-1) {
					i++;
				}
				startingWithComment = (i%2 != 0);
				StringBuffer commentArea = new StringBuffer();
				commentArea.append(getCommentPattern());
				// Adds all the comment blocks until end is here
				while(j<i) {
					commentArea.append(commentSeperated[j]);
					j++;
				}
				int commentEnd = commentSeperated[i].indexOf(getCommentEndPattern())+getCommentEndPattern().length();
				// Handles wrong commentEnd
				if(commentEnd < 0  || commentEnd > commentSeperated[i].length()) {
					commentArea.append(commentSeperated[i].substring(0, commentSeperated[i].length()));
				} else {
					commentArea.append(commentSeperated[i].substring(0, commentEnd));
				}
				String commentStr = commentArea.toString();
				if(commentStr.indexOf(getDocumentationCommentPattern()) == 0) {
					content.add(new DocCommentArea(commentStr));
				} else {
					content.add(new CommentArea(commentStr));
				}
				// Adds the code 
				if(commentEnd < commentSeperated[i].length()) {
					addCodeArea(content, commentSeperated[i].substring(commentEnd));
				}
			} else {
				// Executes the content lines, if a single line comment is used
				addCodeArea(content, commentSeperated[i]);
			}
		}
		return content;
	}
	
	private void addCodeArea(List content, String expectedCodeArea) {
		String[] lines = expectedCodeArea.split("\n");
		StringBuffer formerCode = new StringBuffer();
		for(int i=0; i<lines.length; i++) {
			int commentPos = lines[i].indexOf(getSingleLineCommentPattern()); 
			if(commentPos > 0) {
				String beforeComment = lines[i].substring(0, commentPos);
				content.add(new CodeArea(formerCode.append(beforeComment).toString()));
				formerCode = new StringBuffer(); 
			} else {
				formerCode.append(lines[i]);
			}
		}
		if(formerCode.length() > 0) {
			content.add(new CodeArea(formerCode.toString()));
		}
	}
	
	protected void parseClass(String content, File file, Documentation documentation) {
		String beforeClassContent = content.split("."+getClassPattern()+" .")[0];
	}

	protected void parseInterface(String content, File file, Documentation documentation) {
		String beforeInterfaceContent = content.split("."+getInterfacePattern()+" .")[0];
		List imports = new ArrayList();
		
	}
	
	protected String getFileContent(File file) {
		StringBuffer content = new StringBuffer();
		try {
			DataInputStream stream = new DataInputStream(new FileInputStream(file));
			String line;
			while ((line = stream.readLine()) != null) {
				content.append(line + "\n");
			}
		} catch (FileNotFoundException e) {
			System.out.println("Error: File '"+file.getPath()+"' was not properly found.");
		} catch (IOException e) {
			System.out.println("Error: File '"+file.getPath()+"' was not readable.");
		}
		return content.toString();
	}
	
	protected boolean isValidFileName(String name) {
		String ending = name.substring(name.lastIndexOf(".")+1);
		for(Iterator iter= validFileEndings.iterator(); iter.hasNext();) {
			String allowedEnding = (String)iter.next();
			if(ending.equals(allowedEnding)) {
				return true;
			}
		}
		return false;
	}
}
