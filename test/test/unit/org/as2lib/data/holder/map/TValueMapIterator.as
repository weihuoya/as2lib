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

import test.unit.org.as2lib.data.holder.AbstractTIterator;
import org.as2lib.test.mock.MockControl;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.map.ValueMapIterator;

/**
 * Specific Iterator Test for the MapIterator
 * 
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.data.holder.map.TValueMapIterator extends AbstractTIterator {
	
	/* Array content */
	private var content:Array;
	
	/* Map to be inherited */
	private var map:HashMap;
	
	/**
	 * Creates a dummy array and uses it for testing.
	 */
	public function setUp(Void):Void {
		content = [1,2,3,4,5,6,7,8,9,0,undefined,null];
		
		map = new HashMap();
		map.put("a", content[0]);
		map.put("b", content[1]);
		map.put("c", content[2]);
		map.put("d", content[3]);
		map.put("e", content[4]);
		map.put("f", content[5]);
		map.put("g", content[6]);
		map.put("h", content[7]);
		map.put("i", content[8]);
		map.put("j", content[9]);
		map.put("k", content[10]);
		map.put("l", content[11]);
		
		iterator = new ValueMapIterator(map);
	}
	
	/**
	 * Returns the elements that are contained within a array.
	 */
	public function getElements(Void):Array {
		return content;
	}
	
	/**
	 * Tests if all elements can be removed properly.
	 */
	public function testRemoveAll(Void):Void {
		super.testRemoveAll();
		assertEquals("All elements should be removed from the content", map.size(), 0);
	}	
}