/*
 * Created on 02.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.util;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ArrayUtil {
    public static String join(String[] source, String seperator) {
        String result = "";
        int i;
        for (i=0; i<source.length; i++) {
            result += source[i];
            if(i != source.length-1) {
                result += seperator;
            }
        }
        return result;
    }
}
