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

import org.as2lib.test.unit.TestCase;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.map.PriorityMap;
import org.as2lib.data.holder.Iterator;
import test.unit.org.as2lib.data.holder.AbstractTMap;

/**
 * Extended Template Method of AbstractTMap.getMap.
 * 
 * @return New instance of a typedMap.
 */
class test.unit.org.as2lib.data.holder.map.TPriorityMap extends AbstractTMap {
	
	/**
	 * Extended Template Method of AbstractTMap.getMap.
	 * 
	 * @return New instance of a PriorityMap.
	 */
	public function getMap(Void):Map {
		return new PriorityMap(new HashMap());
	}
	
	/**
	 *
	 */
	public function testNonPriority(Void):Void {
		var map:PriorityMap = new PriorityMap(new HashMap());
		map.put("a", 1);
		map.put("b", 2);
		map.put("c", 3);
		var i:Number;
		var iter:Iterator;
		iter=map.iterator();
		for(i=0; iter.hasNext(); i++) {
			assertEquals("Normal iterating content "+i+" should be "+(i+1), i+1, iter.next());
		}
	}
	
	public function testPriority(Void):Void {
		var map:PriorityMap = new PriorityMap(new HashMap());
		map.put("a", 1);
		map.put("b", 2);
		map.put("c", 3);
		map.put("d", 4, 0);
		var i:Number;
		var iter:Iterator;
		iter=map.iterator();
		for(i=0; iter.hasNext(); i++) {
			switch(i) {
				case 0:
					assertEquals("Iterating over priority 0 should be 4", iter.next(), 4);
					break;
				case 1:
				case 2:
				case 3:
					assertEquals("Iterating over priority "+i+" should be "+i, iter.next(), i);
					break;
				default:
					fail("Unexpected index "+i+" found");
			}
		}
	}
	
	public function testChangePriority(Void):Void {
		var map:PriorityMap = new PriorityMap(new HashMap());
		map.put("a", 1);
		map.put("b", 2);
		map.put("c", 3);
		map.put("d", 4);
		map.changePriority("a", -1, false);
		map.changePriority("b", 3, false);
		var i:Number;
		var iter:Iterator;
		iter=map.iterator();
		for(i=0; iter.hasNext(); i++) {
			trace(iter.next());
			/*
			switch(i) {
				case 0:
					assertEquals("Iterating over priority 0 should be 4", iter.next(), 4);
					break;
				case 1:
				case 2:
				case 3:
					assertEquals("Iterating over priority "+i+" should be "+i, iter.next(), i);
					break;
				default:
					fail("Unexpected index "+i+" found");
			}
			*/
		}
	}
}