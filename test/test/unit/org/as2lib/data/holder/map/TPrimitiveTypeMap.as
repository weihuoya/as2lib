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

import org.as2lib.data.holder.Map;
import org.as2lib.test.unit.TestCase;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.map.PrimitiveTypeMap;

/**
 * Similar implementation to AbstractTMap without "false" as key (because this isn't allowed in PrimitiveTypeMap
 * 
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.data.holder.map.TPrimitiveTypeMap extends TestCase {
	
	
	/**
	 * Creates a new Map instance 
	 */
	private function getMap(Void):Map {
		return new PrimitiveTypeMap();
	}
	
	/**
	 * Fills the map with testcontent
	 */
	public function fillMap(map:Map):Void {
		map.put("key", "stringKey");
		map.put(12, 15);
	}
	
	/**
	 * Tests if containsKey works proper
	 */
	public function testContainsKey(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		assertTrue("Map.containsKey('key') should return true.", map.containsKey("key"));
		assertTrue("Map.containsKey(12) should return true.", map.containsKey(12));
		assertFalse("Map.containsKey('notContainedKey') should return false.", map.containsKey("notContainedKey"));
		assertFalse("Map.containsKey(1) should return false.", map.containsKey(1));
	}
	
	/**
	 * Tests if containsValue works proper
	 */
	public function testContainsValue(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		assertTrue("Map.containsValue('stringKey') should return true.", map.containsValue("stringKey"));
		assertTrue("Map.containsValue(15) should return true.", map.containsValue(15));
		assertFalse("Map.containsValue('notContainedValue') should return false.", map.containsValue("notContainedValue"));
		assertFalse("Map.containsValue(48) should return false.", map.containsValue(48));
	}
	
	/**
	 * Tests if getKeys works as expected.
	 */
	public function testGetKeys(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		var keys:Array = map.getKeys();
		assertSame("Map.getKeys()[0] should be 'key'.", keys[0], "key");
		assertSame("Map.getKeys()[1] should be 12.", keys[1], 12);
		keys[0] = "outsideEditedKey";
		assertNotSame("Changes made to the Array returned by Map.getKeys() should not alter the Map's actual keys.", map.getKeys()[0], keys[0]);
	}
	
	
	/**
	 * Tests if getValues works as expected.
	 */
	public function testGetValues(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		var values:Array = map.getValues();
		assertSame("Map.getValues()[0] should be 'stringKey'.", values[0], "stringKey");
		assertSame("Map.getValues()[1] should be 15.", values[1], 15);
		values[0] = "outsideEditedValue";
		assertNotSame("Changes made to the Array returned by Map.getValues() should not alter the Map's actual values.", map.getValues()[0], values[0]);
	}
	
	
	/**
	 * Tests if get works as expected.
	 */
	public function testGet(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		assertSame("Map.get('key') should return 'stringKey'.", map.get("key"), "stringKey");
		assertSame("Map.get(12) should return 15.", map.get(12), 15);
		assertUndefined("Map.get('notContainedKey') should return undefined.", map.get("notContainedKey"));
	}
	
	/**
	 * Tests if putAll works as expected.
	 */
	public function testPutAll(Void):Void {
		var map:Map = getMap();
		var source:Map = getMap();
		fillMap(source);
		map.putAll(source);
		assertSame("Map.get('key') should return 'stringKey'.", map.get("key"), "stringKey");
		assertSame("Map.get(12) should return 15.", map.get(12), 15);
	}
	
	
	/**
	 * Tests if remove works as expected.
	 */
	public function testRemove(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		trace('1');
		assertEquals("Map.remove should return former value: 'stringKey'", map.remove("key"), "stringKey");
		trace('2');
		assertEquals("Map.remove should return former value: 15", map.remove(12), 15);
		trace('3');
		assertUndefined("Map.remove should return 'undefined' if it was not available", map.remove("a"));
		assertFalse("Map.containsKey('key') should return false.", map.containsKey("key"));
		assertFalse("Map.containsKey(12) should return false.", map.containsKey(12));
	}
	
	
	/**
	 * Tests if clear works as expected.
	 */
	public function testClear(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		map.clear();
		assertFalse("Map.containsKey('key') should return false.", map.containsKey("key"));
		assertFalse("Map.containsKey(12) should return false.", map.containsKey(12));
	}
	
	
	/**
	 * Tests if size() works as expected.
	 */
	public function testSize(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		assertSame("Map.size() should return 2.", map.size(), 2);
		map.remove("key");
		assertSame("Map.size() should return 1.", map.size(), 1);
		map.clear();
		assertSame("Map.size() should return 0.", map.size(), 0);
	}
	
	
	/**
	 * Tests if isEmpty works as expected.
	 */
	public function testIsEmpty(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		assertFalse("Map.isEmpty() should return false.", map.isEmpty());
		map.clear();
		assertTrue("Map.isEmpty() should return true.", map.isEmpty());
	}
	
	/**
	 * Tests if iterating over a primitive type map works proper.
	 */
	public function testIterator(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		var iterator:Iterator = map.iterator();
		
		// Tests the content and if .hasNext is always correct.
		assertSame("First element and 'stringKey' should be the same.", iterator.next(), "stringKey");
		assertTrue("Iterator should have 1 more element.", iterator.hasNext());
		assertSame("Last elemnt should be 15.", iterator.next(), 15);
		assertFalse("Iterator should have no more elments.", iterator.hasNext());
		
		// Remove test
		iterator.remove();
		assertUndefined("Element 15 corresponding to key 12 should have been deleted in iterator.", map.get(12));
		assertSame("Mapping from value 'stringKey' to key 'key' should still exist.", map.get("key"), "stringKey");
	}
}