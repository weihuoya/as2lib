/*
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure;

import java.util.HashMap;
import java.util.Map;

import org.as2lib.doc.structure.lang.TypeContentProxy;
import org.as2lib.doc.structure.Documentation;
import org.as2lib.doc.structure.lang.Package;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class TypeCache {
	private Map types;
	private Documentation documentation;
	
	public TypeCache(Documentation documentation) {
		this.documentation = documentation;
		types = new HashMap();
	}
	
	public void addType(TypeContent type) {
		String fullName = type.getFullName();
		if(containsType(fullName)) {
			throw new IllegalArgumentException("Given classContent for '"+fullName+"' has already been added to the classcache");
		}
		types.put(fullName, type);
	}
	
	public boolean containsType(String fullPath) {
		return types.containsKey(fullPath);
	}
	
	public ClassContent getClass(String fullPath) {
		ClassContent type = (ClassContent)types.get(fullPath);
		if(type == null) {
			String name;
			Package parent;
			if(fullPath.indexOf(".") > 0) {
				name = fullPath.substring(fullPath.lastIndexOf(".")+1);
				parent = documentation.getPackages().getPackage(fullPath.substring(0, fullPath.lastIndexOf(".")));
			} else {
				name = fullPath;
				parent = documentation.getPackages().getRoot();
			}
				
			TypeContentProxy typeProxy = new TypeContentProxy(name);
			typeProxy.setParent(parent);
			type = typeProxy;
			types.put(fullPath, type);
		}
		return type;
	}
}
