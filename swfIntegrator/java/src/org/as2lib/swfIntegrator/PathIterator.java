/*
 * Created on 02.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator;

import java.util.Iterator;

import org.as2lib.swfIntegrator.util.ArrayUtil;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class PathIterator implements Iterator{
    
    private String[] path;
    
    public PathIterator(String[] path) {
        this.path = path;
    }
    
    public void remove() {
        
    }
    
    public boolean hasNext() {
        return (path.length > 1);
    }
    
    public Object next() {
        removeLastElement();
        return ArrayUtil.join(path, "/")+"/";
    }
    
    private void removeLastElement() {
        String[] result = new String[path.length-1];
        int i;
        for (i=0; i<path.length-1; i++) {
            result[i] = path[i];
        }
        path = result;
    }
}
