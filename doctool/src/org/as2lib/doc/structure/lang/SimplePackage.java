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
public class SimplePackage implements Package {
	
	private String name;
	private Package parent;
	private Map classes;
	private Map packages;
	
	public SimplePackage(String name) {
		this.name = name;
		classes = new HashMap();
		packages = new HashMap();
	}
	
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return name;
	}
	
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
	
	/**
	 * @return Returns the parent.
	 */
	public Package getParent() {
		return parent;
	}
	
	/**
	 * @param parent The parent to set.
	 */
	public void setParent(SimplePackage parent) {
		this.parent = parent;
	}
	
	public String getFullName() {
		if(parent.isRoot()) {
			return getName();
		} else {
			return parent.getFullName()+"."+getName();
		}
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
	
	public boolean isRoot() {
		return false;
	}
	/**
	 * @param parent The parent to set.
	 */
	public void setParent(Package parent) {
		this.parent = parent;
	}
}
