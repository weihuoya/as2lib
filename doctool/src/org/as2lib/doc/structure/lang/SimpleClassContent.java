/*
 * 
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure.lang;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SimpleClassContent implements ClassContent {
	
	private Package parent;
	private String name;
	
	public SimpleClassContent() {
	}
	

	public String getName() {
		return name;
	}
	
	public Package getParent() {
		return parent;
	}
	
	public String getFullName() {
		if(parent.isRoot()) {
			return getName();
		} else {
			return parent.getFullName()+"."+getName();
		}
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @param parent The parent to set.
	 */
	public void setParent(Package parent) {
		this.parent = parent;
	}
}
