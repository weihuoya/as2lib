/*
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure.lang;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.as2lib.doc.structure.ClassContent;



/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class RootPackage implements Package {

	private Map classes;
	private Map packages;
	
	public RootPackage() {
		classes = new HashMap();
		packages = new HashMap();
	}	

	public void addClass(ClassContent classContent) {
		classes.put(classContent.getName(), classContent);
	}
	
	public ClassContent getClass(String name) {
		return (ClassContent)classes.get(name);
	}
	
	public List getClasses() {
		return new ArrayList(classes.entrySet());
	}
	
	public void addPackage(Package pack) {
		packages.put(pack.getName(), pack);
	}
	
	public Package getPackage(String name) {
		return (Package)packages.get(name);
	}
	
	public List getPackages() {
		return new ArrayList(packages.entrySet());
	}
	
	/* (non-Javadoc)
	 * @see org.as2lib.doc.structure.Package#getName()
	 */
	public String getName() {
		return null;
	}

	/* (non-Javadoc)
	 * @see org.as2lib.doc.structure.Package#getParent()
	 */
	public Package getParent() {
		return null;
	}

	/* (non-Javadoc)
	 * @see org.as2lib.doc.structure.Package#getFullName()
	 */
	public String getFullName() {
		return null;
	}

	public boolean isRoot() {
		return true;
	}
}
