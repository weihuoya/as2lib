/*
 * Created on 23.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.util;

/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ArrayUtil {

	private ArrayUtil() {}
	
	public static String join(Object[] arr, String seperator) {
		StringBuffer result = new StringBuffer();
		for(int i =0; i<arr.length; i++) {
			if(i!=0) result.append(seperator);
			result.append(arr[i]);
		}
		return result.toString();
	}
}
