/*
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure.lang;

import java.util.List;

import org.as2lib.doc.structure.ClassContent;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public interface Package {

	/**
	 * @return Returns the name.
	 */
	public abstract String getName();

	public abstract void addClass(ClassContent classContent);
	
	public abstract ClassContent getClass(String name);
	
	public abstract List getClasses();
	
	public abstract void addPackage(Package pack);
	
	public abstract Package getPackage(String name);
	
	public abstract List getPackages();
	
	/**
	 * @return Returns the parent.
	 */
	public abstract Package getParent();

	public abstract String getFullName();
	
	public abstract boolean isRoot();
}