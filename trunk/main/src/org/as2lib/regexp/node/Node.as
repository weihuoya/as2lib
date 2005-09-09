/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.regexp.Pattern;
import org.as2lib.regexp.node.TreeInfo;
import org.as2lib.regexp.node.Not;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.Exception;

/**
 * {@code Node} is a base class for all node classes. Subclasses should 
 * override the match() method as appropriate. This class is an accepting 
 * node, so its match() always returns true.
 * 
 * @author Igor Sadovskiy
 */
 
class org.as2lib.regexp.node.Node extends BasicClass {
	
    var next:Node;
    
    function Node() {
        next = Pattern.ACCEPT;
    }
    
    function dup(flag:Boolean):Node {
        if (flag) {
            return new Not(this);
        } else {
            throw new Exception("Internal error in Node dup()", this, arguments);
        }
    }
    /**
     * This method implements the classic accept node.
     */
    function match(matcher:Object, i:Number, seq:String):Boolean {
        matcher.last = i;
        matcher.groups[0] = matcher.first;
        matcher.groups[1] = matcher.last;
        return true;
    }
    /**
     * This method is good for all zero length assertions.
     */
    function study(info:TreeInfo):Boolean {
        if (next != null) {
            return next.study(info);
        } else {
            return info.deterministic;
        }
    }
}
