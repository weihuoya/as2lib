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
	 * Tests the output if no priority is used
	 */
	public function testNonPriority(Void):Void {
		var i:Number;
		var iter:Iterator;
		var map:PriorityMap;
		
		// Test normal direction
		map = new PriorityMap(new HashMap());
		map.put("a", 1);
		map.put("b", 2);
		map.put("c", 3);
		iter=map.iterator();
		for(i=0; iter.hasNext(); i++) {
			assertEquals("Normal iterating content "+i+" should be "+(i+1), i+1, iter.next());
		}
		assertEquals("There should be 3 entries for iterating after double inserted content", i, 3);
		
		// Test double inserting
		map = new PriorityMap(new HashMap());
		map.put("a", 4);
		map.put("b", 1);
		map.put("c", 2);
		map.put("a", 3);
		iter=map.iterator();
		for(i=0; iter.hasNext(); i++) {
			assertEquals("Normal iterating for doubled inserted content "+i+" should be "+(i+1), i+1, iter.next());
		}
		assertEquals("There should be 3 entries for iterating after double inserted content", i, 3);
	}
	
	/**
	 * Tests putting by priority
	 */
	public function testPutWithPriority(Void):Void {
		var map:PriorityMap;
		var i:Number;
		var iter:Iterator;
		
		// Tests for sorting to the middle
		// It could be possible that it has problems with concrete priorities higher than 0 (because 0 is always minimum).
		map = new PriorityMap(new HashMap());
		map.put("a", 1);
		map.put("b", 2);
		map.put("c", 3);
		map.put("d", 4, 2);
		iter=map.iterator();
		for(i=0; iter.hasNext(); i++) {
			if(i == 0 || i == 1) {
				assertEquals("Iterating over middle priority "+i+" should be "+(i-1), iter.next(), i-1);
			} else if(i == 2) {
				assertEquals("Iterating over middle priority 2 should be 4", iter.next(), 4);
			} else if(i == 3) {
				assertEquals("Iterating over middle priority "+i+" should be "+i, iter.next(), i);
			} else  {
				fail("Unexpected index "+i+" found by iterating for putting with middle priority");
				break;
			}
		}
	}
	
	/**
	 * Test changing priority with absolute priorities
	 */
	public function testChangeAbsolutePriority(Void):Void {
		var map:PriorityMap;
		var i:Number;
		var iter:Iterator;
		
		// Create Testlist
		map = new PriorityMap(new HashMap());
		map.put("a", 1);
		map.put("b", 2);
		map.put("c", 4);
		map.put("d", 3);
		map.changePriority("d", 2, true);
		iter=map.iterator();
		
		// Expected new structure:
		//   priority:  0,   1,   2,   3
		//   content:   a-1, b-2, d-3, c-4 
		for(i=0; iter.hasNext(); i++) {
			assertEquals("Iterating over priority "+i+" should be "+(i+1), iter.next(), i+1);
		}
		
		// Another change if its CONSTISTANT for a second time
		map.changePriority("b", 2, true);
		iter=map.iterator();
		
		// Expected new structure:
		//   priority:  0,   1,   2,   3
		//   content:   a-1, d-3, b-2, c-4
		for(i=0; iter.hasNext(); i++) {
			if(i == 0) {
				assertEquals("3rd iterating over priority 0 should be 1", iter.next(), 1);
			} else if(i == 1) {
				assertEquals("3rd iterating over priority 1 should be 3", iter.next(), 3);
			} else if(i == 2) {
				assertEquals("3rd iterating over priority 2 should be 2", iter.next(), 2);
			} else if(i == 3) {
				assertEquals("3rd iterating over priority 3 should be 4", iter.next(), 4);
			} else {
				fail("Unexpected index "+i+" found by 3rd iterating");
				break;
			}
		}
	}
	/**
	 * Test changing priority with absolute priorities
	 */
	public function testChangeRelativePriority(Void):Void {
		var map:PriorityMap;
		var i:Number;
		var iter:Iterator;
		
		// Create Testlist
		map = new PriorityMap(new HashMap());
		map.put("a", 1);
		map.put("b", 2);
		map.put("c", 4);
		map.put("d", 3);
		map.changePriority("a", 0, false);
		map.changePriority("d", -1, false);
		iter=map.iterator();
		
		// Expected new structure:
		//   priority:  0,   1,   2,   3
		//   content:   a-1, b-2, d-3, c-4 
		for(i=0; iter.hasNext(); i++) {
			assertEquals("Iterating over priority "+i+" should be "+(i+1), iter.next(), i+1);
		}
		
		// Another change if its CONSTISTANT for a second time
		map.changePriority("b", 1, false);
		iter=map.iterator();
		
		// Expected new structure:
		//   priority:  0,   1,   2,   3
		//   content:   a-1, d-3, b-2, c-4
		for(i=0; iter.hasNext(); i++) {
			if(i == 0) {
				assertEquals("3rd iterating over priority 0 should be 1", iter.next(), 1);
			} else if(i == 1) {
				assertEquals("3rd iterating over priority 1 should be 3", iter.next(), 3);
			} else if(i == 2) {
				assertEquals("3rd iterating over priority 2 should be 2", iter.next(), 2);
			} else if(i == 3) {
				assertEquals("3rd iterating over priority 3 should be 4", iter.next(), 4);
			} else {
				fail("Unexpected index "+i+" found by 3rd iterating");
				break;
			}
		}
	}
}