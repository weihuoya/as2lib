/*
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure.lang;

import org.as2lib.doc.structure.TypeContent;


/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class AbstractContentProxy implements TypeContent {

	protected Package parent;
	protected String name;
	protected TypeContent reference;
	
	public AbstractContentProxy(String name) {
		this.name = name;
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
