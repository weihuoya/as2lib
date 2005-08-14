/*
 * Created on 03.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.util;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class MapUtil {

    public static Object getKeyToValue(Map map, Object value) {
        Set keySet = map.keySet();
        Iterator iter = keySet.iterator();
        Object result = null;
        while(iter.hasNext()) {
            Object temp = iter.next();
            if(map.get(temp) == value) {
                return temp;
            }
        }
        return result;
    }

}
