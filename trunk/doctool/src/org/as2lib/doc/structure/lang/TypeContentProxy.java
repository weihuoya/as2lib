/*
 * Created on 23.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure.lang;

import org.as2lib.doc.structure.ClassContent;
import org.as2lib.doc.structure.TypeContent;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class TypeContentProxy extends AbstractContentProxy implements ClassContent {

	private TypeContent reference;
	
	public TypeContentProxy(String name) {
		super(name);
	}
	
	public void setReference(TypeContent reference) {
		this.reference = reference;
	}
	
	public TypeContent getReference(){
		return reference;
	}
}
