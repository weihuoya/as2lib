/*
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure.lang;

import java.util.List;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public interface ClassContent {
	public abstract String getName();
	public abstract String getFullName();
	/*public abstract List getMethods();
	public abstract String getDescription();
	public abstract List getAuthors();
	public abstract boolean isPublic();
	public abstract String getVersion();
	public abstract List getReferences();
	public abstract List getImplementedInterfaces();
	public abstract ClassContent getExtendedClass();
	public abstract boolean isInterface();
	public abstract String getContstructor();*/
	public abstract Package getParent();
}