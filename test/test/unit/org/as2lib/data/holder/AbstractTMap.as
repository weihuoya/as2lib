import org.as2lib.test.unit.TestCase;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.Iterator;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.data.holder.AbstractTMap extends TestCase {
	
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	public function AbstractTMap(Void) {
	}
	
	private function fillMap(map:Map):Void {
		map.put("key", "stringKey");
		map.put(12, 15);
		map.put(true, false);
	}
	
	public function testContainsKey(Void):Void {
		var map:Map = this["getMap"]();
		fillMap(map);
		assertTrue("Map.containsKey('key') should return true.", map.containsKey("key"));
		assertTrue("Map.containsKey(12) should return true.", map.containsKey(12));
		assertTrue("Map.containsKey(true) should return true.", map.containsKey(true));
		assertFalse("Map.containsKey('notContainedKey') should return false.", map.containsKey("notContainedKey"));
		assertFalse("Map.containsKey(1) should return false.", map.containsKey(1));
		assertFalse("Map.containsKey(false) should return false.", map.containsKey(false));
	}
	
	public function testContainsValue(Void):Void {
		var map:Map = this["getMap"]();
		fillMap(map);
		assertTrue("Map.containsValue('stringKey') should return true.", map.containsValue("stringKey"));
		assertTrue("Map.containsValue(15) should return true.", map.containsValue(15));
		assertTrue("Map.containsValue(false) should return true.", map.containsValue(false));
		assertFalse("Map.containsValue('notContainedValue') should return false.", map.containsValue("notContainedValue"));
		assertFalse("Map.containsValue(48) should return false.", map.containsValue(48));
		assertFalse("Map.containsValue(true) should return false.", map.containsValue(true));
	}
	
	public function testGetKeys(Void):Void {
		var map:Map = this["getMap"]();
		fillMap(map);
		var keys:Array = map.getKeys();
		assertSame("Map.getKeys()[0] should be 'key'.", keys[0], "key");
		assertSame("Map.getKeys()[1] should be 12.", keys[1], 12);
		assertSame("Map.getKeys()[2] should be true.", keys[2], true);
		keys[0] = "outsideEditedKey";
		assertNotSame("Changes made to the Array returned by Map.getKeys() should not alter the Map's actual keys.", map.getKeys()[0], keys[0]);
	}
	
	public function testGetValues(Void):Void {
		var map:Map = this["getMap"]();
		fillMap(map);
		var values:Array = map.getValues();
		assertSame("Map.getValues()[0] should be 'stringKey'.", values[0], "stringKey");
		assertSame("Map.getValues()[1] should be 15.", values[1], 15);
		assertSame("Map.getValues()[2] should be false.", values[2], false);
		values[0] = "outsideEditedValue";
		assertNotSame("Changes made to the Array returned by Map.getValues() should not alter the Map's actual values.", map.getValues()[0], values[0]);
	}
	
	public function testGet(Void):Void {
		var map:Map = this["getMap"]();
		fillMap(map);
		assertSame("Map.get('key') should return 'stringKey'.", map.get("key"), "stringKey");
		assertSame("Map.get(12) should return 15.", map.get(12), 15);
		assertSame("Map.get(true) should return false.", map.get(true), false);
		assertUndefined("Map.get('notContainedKey') should return undefined.", map.get("notContainedKey"));
	}
	
	public function testPut(Void):Void {
		// Has already been tested in testGet(Void):Void.
	}
	
	public function testPutAll(Void):Void {
		var map:Map = this["getMap"]();
		var source:Map = this["getMap"]();
		fillMap(source);
		map.putAll(source);
		assertSame("Map.get('key') should return 'stringKey'.", map.get("key"), "stringKey");
		assertSame("Map.get(12) should return 15.", map.get(12), 15);
		assertSame("Map.get(true) should return false.", map.get(true), false);
	}
	
	public function testRemove(Void):Void {
		var map:Map = this["getMap"]();
		fillMap(map);
		map.remove("key");
		map.remove(12);
		map.remove(true);
		assertFalse("Map.containsKey('key') should return false.", map.containsKey("key"));
		assertFalse("Map.containsKey(12) should return false.", map.containsKey(12));
		assertFalse("Map.containsKey(true) should return false.", map.containsKey(true));
	}
	
	public function testClear(Void):Void {
		var map:Map = this["getMap"]();
		fillMap(map);
		map.clear();
		assertFalse("Map.containsKey('key') should return false.", map.containsKey("key"));
		assertFalse("Map.containsKey(12) should return false.", map.containsKey(12));
		assertFalse("Map.containsKey(true) should return false.", map.containsKey(true));
	}
	
	public function testSize(Void):Void {
		var map:Map = this["getMap"]();
		fillMap(map);
		assertSame("Map.size() should return 3.", map.size(), 3);
		map.remove("key");
		assertSame("Map.size() should return 2.", map.size(), 2);
		map.clear();
		assertSame("Map.size() should return 0.", map.size(), 0);
	}
	
	public function testIsEmpty(Void):Void {
		var map:Map = this["getMap"]();
		fillMap(map);
		assertFalse("Map.isEmpty() should return false.", map.isEmpty());
		map.clear();
		assertTrue("Map.isEmpty() should return true.", map.isEmpty());
	}
	
	public function testIterator(Void):Void {
		var map:Map = this["getMap"]();
		fillMap(map);
		var iterator:Iterator = map.iterator();
		assertSame("First element and 'stringKey' should be the same.", iterator.next(), "stringKey");
		assertTrue("Iterator should have 2 more elements to iterate over.", iterator.hasNext());
		assertSame("Next element should be 15.", iterator.next(), 15);
		iterator.remove();
		assertTrue("Iterator should have 1 more element.", iterator.hasNext());
		assertSame("Last elemnt should be false.", iterator.next(), false);
		assertFalse("Iterator should have no more elments.", iterator.hasNext());
		assertUndefined("Element 15 corresponding to key 12 should have been deleted in iterator.", map.get(12));
		assertSame("Mapping from value 'stringKey' to key 'key' should still exist.", map.get("key"), "stringKey");
		assertSame("Mapping from value false to key true should still exist.", map.get(true), false);
	}
	
}