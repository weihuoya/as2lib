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
import org.as2lib.data.holder.Iterator;

/**
 * @author Simon Wacker
 */
class org.as2lib.data.holder.AbstractTMap extends TestCase {
	
	/**
	 * Flag to block collecting by the TestSuiteFactory of this Abstract class.
	 */
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	/**
	 * Template Method to get the specific Map implementation.
	 */
	public function getMap(Void):Map {
		return null;
	}
	
	/**
	 * Fills the map with testcontent.
	 */
	private function fillMap(map:Map):Void {
		map.put("key", "stringKey");
		map.put(12, 15);
		map.put(true, false);
	}
	
	/**
	 * Validates if the keys that gets filled with fillMap are available and that other keys arn't
	 */
	public function testContainsKey(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		
		// Positive Cases
		assertTrue("Map.containsKey('key') should return true.", map.containsKey("key"));
		assertTrue("Map.containsKey(12) should return true.", map.containsKey(12));
		assertTrue("Map.containsKey(true) should return true.", map.containsKey(true));
		
		// Negative Cases
		assertFalse("Map.containsKey('notContainedKey') should return false.", map.containsKey("notContainedKey"));
		assertFalse("Map.containsKey(1) should return false.", map.containsKey(1));
		assertFalse("Map.containsKey(false) should return false.", map.containsKey(false));
	}
	
	/**
	 * Validates if the contents that gets filled with fillMap are available and that other content isn't.
	 */
	public function testContainsValue(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		
		// Positive Cases
		assertTrue("Map.containsValue('stringKey') should return true.", map.containsValue("stringKey"));
		assertTrue("Map.containsValue(15) should return true.", map.containsValue(15));
		assertTrue("Map.containsValue(false) should return true.", map.containsValue(false));
		
		// Negative Cases
		assertFalse("Map.containsValue('notContainedValue') should return false.", map.containsValue("notContainedValue"));
		assertFalse("Map.containsValue(48) should return false.", map.containsValue(48));
		assertFalse("Map.containsValue(true) should return false.", map.containsValue(true));
	}
	
	/**
	 * Tests if the inserted Content is available with getKey. 
	 */
	public function testGetKeys(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		
		// Normal Validation
		var keys:Array = map.getKeys();
		assertSame("Map.getKeys()[0] should be 'key'.", keys[0], "key");
		assertSame("Map.getKeys()[1] should be 12.", keys[1], 12);
		assertSame("Map.getKeys()[2] should be true.", keys[2], true);
		
		// Modification Test
		keys[0] = "outsideEditedKey";
		assertNotSame("Changes made to the Array returned by Map.getKeys() should not alter the Map's actual keys.", map.getKeys()[0], keys[0]);
	}
	
	/**
	 * Tests if the values returned by getValues match the values that were inserted.
	 */
	public function testGetValues(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		
		// Normal Validation
		var values:Array = map.getValues();
		assertSame("Map.getValues()[0] should be 'stringKey'.", values[0], "stringKey");
		assertSame("Map.getValues()[1] should be 15.", values[1], 15);
		assertSame("Map.getValues()[2] should be false.", values[2], false);
		
		// Modification Test
		values[0] = "outsideEditedValue";
		assertNotSame("Changes made to the Array returned by Map.getValues() should not alter the Map's actual values.", map.getValues()[0], values[0]);
	}
	
	/**
	 * Tests if the values returned by getValues match the values that were inserted.
	 */
	public function testGet(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		
		// Positive Case
		assertSame("Map.get('key') should return 'stringKey'.", map.get("key"), "stringKey");
		assertSame("Map.get(12) should return 15.", map.get(12), 15);
		assertSame("Map.get(true) should return false.", map.get(true), false);
		
		// Negative case
		assertUndefined("Map.get('notContainedKey') should return undefined.", map.get("notContainedKey"));
	}
	
	/**
	 * Tests if the content inserted by putAll matches the expected content.
	 */
	public function testPutAll(Void):Void {
		var map:Map = getMap();
		var source:Map = getMap();
		fillMap(source);
		
		map.putAll(source);
		assertSame("Map.get('key') should return 'stringKey'.", map.get("key"), "stringKey");
		assertSame("Map.get(12) should return 15.", map.get(12), 15);
		assertSame("Map.get(true) should return false.", map.get(true), false);
	}
	
	/**
	 * Tests if remove really removes the content.
	 */
	public function testRemove(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		
		// Removes the inserted content
		assertEquals("Map.remove should return former value: 'stringKey'", map.remove("key"), "stringKey");
		assertEquals("Map.remove should return former value: 15", map.remove(12), 15);
		assertEquals("Map.remove should return former value: false", map.remove(true), false);
		
		// Validates that the removing of another content returns "undefined""
		assertUndefined("Map.remove should return 'undefined' if it was not available", map.remove("a"));
		
		// Validates that containsKey returns false if a content was removed.
		assertFalse("Map.containsKey('key') should return false.", map.containsKey("key"));
		assertFalse("Map.containsKey(12) should return false.", map.containsKey(12));
		assertFalse("Map.containsKey(true) should return false.", map.containsKey(true));
	}
	
	/**
	 * Test if clear really removes all content.
	 */
	public function testClear(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		map.clear();
		assertFalse("Map.containsKey('key') should return false.", map.containsKey("key"));
		assertFalse("Map.containsKey(12) should return false.", map.containsKey(12));
		assertFalse("Map.containsKey(true) should return false.", map.containsKey(true));
	}
	
	/**
	 * Tests if the map returns the correct size.
	 */
	public function testSize(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		
		// Normal test
		assertSame("Map.size() should return 3.", map.size(), 3);
		
		// Tests after something was removed
		map.remove("key");
		assertSame("Map.size() should return 2.", map.size(), 2);
		
		// Test after all was cleared.
		map.clear();
		assertSame("Map.size() should return 0.", map.size(), 0);
	}
	
	/**
	 * Tests if isEmpty works.
	 */
	public function testIsEmpty(Void):Void {
		var map:Map = getMap();
		
		// Test without anything added.
		assertTrue("Map.isEmpty() should return true.", map.isEmpty());
		
		// Normal Test
		fillMap(map);
		assertFalse("Map.isEmpty() should return false.", map.isEmpty());
		
		// Test after the map was cleared
		map.clear();
		assertTrue("Map.isEmpty() should return true.", map.isEmpty());
	}
	
	/**
	 * Tests if the iterator works and has any affect to the content.
	 */
	public function testIterator(Void):Void {
		var map:Map = getMap();
		fillMap(map);
		var iterator:Iterator = map.iterator();
		// Test for the first element
		assertSame("First element and 'stringKey' should be the same.", iterator.next(), "stringKey");
		
		// Remove the next element
		assertTrue("Iterator should have 2 more elements to iterate over.", iterator.hasNext());
		assertSame("Next element should be 15.", iterator.next(), 15);
		iterator.remove();
		
		// Test for the last element
		assertTrue("Iterator should have 1 more element.", iterator.hasNext());
		assertSame("Last elemnt should be false.", iterator.next(), false);
		assertFalse("Iterator should have no more elments.", iterator.hasNext());
		
		// Validates that no modifications to the map were made.
		assertUndefined("Element 15 corresponding to key 12 should have been deleted in iterator.", map.get(12));
		assertSame("Mapping from value 'stringKey' to key 'key' should still exist.", map.get("key"), "stringKey");
		assertSame("Mapping from value false to key true should still exist.", map.get(true), false);
	}	
}