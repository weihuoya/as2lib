/*
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
public class ClassContentProxy implements ClassContent {

	private Package parent;
	private String name;
	private ClassContent reference;
	
	public ClassContentProxy(String name) {
		this.name = name;
	}
	
	public void setReference(ClassContent reference) {
		this.reference = reference;
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
	 * @param parent The parent to set.
	 */
	public void setParent(Package parent) {
		this.parent = parent;
	}
}
