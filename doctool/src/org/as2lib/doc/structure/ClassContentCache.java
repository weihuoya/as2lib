/*
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure;

import java.util.HashMap;
import java.util.Map;

import org.as2lib.doc.structure.lang.ClassContent;
import org.as2lib.doc.structure.lang.ClassContentProxy;
import org.as2lib.doc.structure.Documentation;
import org.as2lib.doc.structure.lang.Package;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ClassContentCache {
	private Map classes;
	private Documentation documentation;
	
	public ClassContentCache(Documentation documentation) {
		this.documentation = documentation;
		classes = new HashMap();
	}
	
	public ClassContent getClass(String fullPath) {
		ClassContent classContent = (ClassContent)classes.get(fullPath);
		if(classContent == null) {
			String name;
			Package parent;
			if(fullPath.indexOf(".") > 0) {
				name = fullPath.substring(fullPath.lastIndexOf(".")+1);
				parent = documentation.getPackages().getPackage(fullPath.substring(0, fullPath.lastIndexOf(".")));
			} else {
				name = fullPath;
				parent = documentation.getPackages().getRoot();
			}
				
			ClassContentProxy classContentProxy = new ClassContentProxy(name);
			classContentProxy.setParent(parent);
			classContent = classContentProxy;
		}
		return classContent;
	}
}
