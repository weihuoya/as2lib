/*
 * 
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure.lang;

import java.util.ArrayList;
import java.util.List;

import org.as2lib.doc.structure.ClassContent;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SimpleClassContent implements ClassContent {
	
	private Package parent;
	private String name;
	private List implementedInterfaces;
	private ClassContent extendedClass;
	
	public SimpleClassContent() {
		implementedInterfaces = new ArrayList();
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
	
	public void setExtendedClass(ClassContent extendedClass) {
		this.extendedClass = extendedClass;
	}
	
	public void addImplementedInterface(InterfaceContent implementedInterface) {
		implementedInterfaces.add(implementedInterface);
	}
}
