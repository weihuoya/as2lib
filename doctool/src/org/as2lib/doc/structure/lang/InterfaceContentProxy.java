/*
 * Created on 23.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure.lang;

import org.as2lib.doc.structure.ClassContent;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class InterfaceContentProxy extends AbstractContentProxy implements ClassContent {

	private ClassContent reference;
	
	public InterfaceContentProxy(String name) {
		super(name);
	}
	
	public void setReference(ClassContent reference) {
		this
		.reference = reference;
	}
	
	public ClassContent getReference(){
		return reference;
	}
}
