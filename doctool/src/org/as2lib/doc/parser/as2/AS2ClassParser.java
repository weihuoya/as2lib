/*
 * Created on 23.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.parser.as2;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.as2lib.doc.log.*;
import org.as2lib.doc.parser.Area;
import org.as2lib.doc.parser.ClassParser;
import org.as2lib.doc.structure.ClassContent;
import org.as2lib.doc.structure.TypeCache;
import org.as2lib.doc.structure.Documentation;
import org.as2lib.doc.structure.lang.AbstractContentProxy;
import org.as2lib.doc.structure.lang.MultiClassProxy;
import org.as2lib.doc.structure.lang.MultiInterfaceProxy;
import org.as2lib.doc.structure.lang.SimpleClassContent;
import org.as2lib.doc.structure.lang.TypeContentProxy;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AS2ClassParser implements ClassParser {

	/* (non-Javadoc)
	 * @see org.as2lib.doc.parser.ClassParser#parse(org.as2lib.doc.structure.Documentation, java.util.List, java.util.List)
	 */
	public LogEntry parse(Documentation documentation, List header, List body, File file) {
		
		Iterator iter = header.iterator();
		SimpleClassContent classContent = null;
		Area formerDoc = null;
		List imports = new ArrayList();
		TypeCache classCache = documentation.getTypes();
		String name = null;
		String path = null;
		String extendedClass = null;
		String implementedInterfaces = null;
		Pattern p = Pattern.compile(".*? class +([^ ]+)(?: +extends +([^ ]+))?(?: *implements ([^ ,]*))? *\\{?");
		
		while(iter.hasNext()) {
			Area area = (Area) iter.next();
			if(area.isDocComment()) {
				formerDoc = area;
			}
			if(area.isCode()) {
				//parseForImports(area.getContent(), imports);

				Matcher m = p.matcher(area.getContent());
				m.find();
				String pureExtendedClass = null;
				String pureImplementedInterfaces = null;
				try {
					name = m.group(1);
					pureExtendedClass = m.group(2);
					pureImplementedInterfaces = m.group(3);
				} catch (StringIndexOutOfBoundsException e) {
				}
				if(pureExtendedClass != null) {
					extendedClass = pureExtendedClass;
				}
				if(pureImplementedInterfaces != null) {
					implementedInterfaces = pureImplementedInterfaces;
				}
				if(name != null) {
					classContent = new SimpleClassContent();
					int lastPointIndex = name.lastIndexOf(".");
					path = name.substring(0, lastPointIndex);
					name = name.substring(lastPointIndex+1);
					classContent.setName(name);
					classContent.setParent(documentation.getPackages().getPackage(path));
					if(classCache.containsType(name)) {
						ClassContent tempContent = classCache.getClass(name);
						if(tempContent instanceof TypeContentProxy) {
							((TypeContentProxy) tempContent).setReference(classContent);
						} else {
							throw new IllegalArgumentException("Given classContent for '"+name+"' has already been added to the classcache");
						}
					} else {
						classCache.addType(classContent);
					}
				}
			}
		}
		if(classContent != null) {
			if(extendedClass != null) {
				classContent.setExtendedClass(new MultiClassProxy(extendedClass, imports));
			} else {
				classContent.setExtendedClass(classCache.getClass("Object"));
			}
			if(implementedInterfaces != null) {
				String[] interfaces = implementedInterfaces.split("( *, *)");
				for(int i=0; i<interfaces.length; i++) {
					classContent.addImplementedInterface(new MultiInterfaceProxy(interfaces[i], imports));
				}
			}
		}
		
		return new Notice("Well parsed ");
	}
}
