/*
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure;

import java.util.HashMap;
import java.util.Map;

import org.as2lib.doc.structure.lang.Package;
import org.as2lib.doc.structure.lang.RootPackage;
import org.as2lib.doc.structure.lang.SimplePackage;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class PackageCache {

	private Map packages;
	private Package root;
	private Documentation documentation;
	
	public PackageCache (Documentation documentation) {
		this.documentation = documentation;
		packages = new HashMap();
	}
	
	public Package getPackage(String fullPath) {
		Package pack = (Package)packages.get(fullPath);
		if(pack == null) {
			String name;
			Package parent;
			if(fullPath.lastIndexOf(".") > 0) {
				name = fullPath.substring(fullPath.lastIndexOf(".")+1);
				parent = getPackage(fullPath.substring(0, fullPath.lastIndexOf(".")));
			} else {
				name = fullPath;
				parent = getRoot();
			}
			SimplePackage newPack = new SimplePackage(name);
			newPack.setParent(parent);
			pack = newPack;
			parent.addPackage(pack);
			packages.put(fullPath, pack);
		}
		return pack;
	}
	
	public Package getRoot() {
		if(root == null) {
			root = new RootPackage();
		}
		return root;
	}
}
