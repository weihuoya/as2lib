import org.as2lib.test.unit.TestCase;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.PrimitiveTypeMap;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.data.holder.TPrimitiveTypeMap extends TestCase {
	
	public function TPrimitiveTypeMap(Void) {
	}
	
	private function getFilledMap(Void):Map {
		var result:Map = new PrimitiveTypeMap();
		result.put("key", "stringKey");
		result.put(12, 15);
		result.put(true, false);
		return result;
	}
	
	public function testContainsKey(Void):Void {
		var map:Map = getFilledMap();
		assertTrue("PrimitiveTypeMap.containsKey('key') should return true.", map.containsKey("key"));
		assertTrue("PrimitiveTypeMap.containsKey(12) should return true.", map.containsKey(12));
		assertTrue("PrimitiveTypeMap.containsKey(true) should return true.", map.containsKey(true));
		assertFalse("PrimitiveTypeMap.containsKey('notContainedKey') should return false.", map.containsKey("notContainedKey"));
		assertFalse("PrimitiveTypeMap.containsKey(1) should return false.", map.containsKey(1));
		assertFalse("PrimitiveTypeMap.containsKey(false) should return false.", map.containsKey(false));
	}
	
	public function testContainsValue(Void):Void {
		var map:Map = getFilledMap();
		assertTrue("PrimitiveTypeMap.containsValue('stringKey') should return true.", map.containsValue("stringKey"));
		assertTrue("PrimitiveTypeMap.containsValue(15) should return true.", map.containsValue(15));
		assertTrue("PrimitiveTypeMap.containsValue(false) should return true.", map.containsValue(false));
		assertFalse("PrimitiveTypeMap.containsValue('notContainedValue') should return false.", map.containsValue("notContainedValue"));
		assertFalse("PrimitiveTypeMap.containsValue(48) should return false.", map.containsValue(48));
		assertFalse("PrimitiveTypeMap.containsValue(true) should return false.", map.containsValue(true));
	}
	
	public function testGetKeys(Void):Void {
		var keys:Array = getFilledMap().getKeys();
		assertSame("PrimitiveTypeMap.getKeys()[0] should be 'key'.", keys[0], "key");
		assertSame("PrimitiveTypeMap.getKeys()[1] should be 12.", keys[1], 12);
		assertSame("PrimitiveTypeMap.getKeys()[2] should be true.", keys[2], true);
	}
	
	public function testGetValues(Void):Void {
		var values:Array = getFilledMap().getValues();
		assertSame("PrimitiveTypeMap.getValues()[0] should be 'stringKey'.", values[0], "stringKey");
		assertSame("PrimitiveTypeMap.getValues()[1] should be 15.", values[1], 15);
		assertSame("PrimitiveTypeMap.getValues()[2] should be false.", values[2], false);
	}
	
	public function testGet(Void):Void {
		var map:Map = getFilledMap();
		assertSame("PrimitiveTypeMap.get('key') should return 'stringKey'.", map.get("key"), "stringKey");
		assertSame("PrimitiveTypeMap.get(12) should return 15.", map.get(12), 15);
		assertSame("PrimitiveTypeMap.get(true) should return false.", map.get(true), false);
		assertUndefined("PrimitiveTypeMap.get('notContainedKey') should return undefined.", map.get("notContainedKey"));
	}
	
	public function testPut(Void):Void {
		// Can only be tested by using PrimitiveTypeMap.get().
	}
	
	public function testPutAll(Void):Void {
		var map:Map = new PrimitiveTypeMap();
		map.putAll(getFilledMap());
		assertSame("PrimitiveTypeMap.get('key') should return 'stringKey'.", map.get("key"), "stringKey");
		assertSame("PrimitiveTypeMap.get(12) should return 15.", map.get(12), 15);
		assertSame("PrimitiveTypeMap.get(true) should return false.", map.get(true), false);
	}
	
	public function testRemove(Void):Void {
		var map:Map = getFilledMap();
		map.remove("key");
		map.remove(12);
		map.remove(true);
		assertFalse("PrimitiveTypeMap.containsKey('key') should return false.", map.containsKey("key"));
		assertFalse("PrimitiveTypeMap.containsKey(12) should return false.", map.containsKey(12));
		assertFalse("PrimitiveTypeMap.containsKey(true) should return false.", map.containsKey(true));
	}
	
	public function testClear(Void):Void {
		var map:Map = getFilledMap();
		map.clear();
		assertFalse("PrimitiveTypeMap.containsKey('key') should return false.", map.containsKey("key"));
		assertFalse("PrimitiveTypeMap.containsKey(12) should return false.", map.containsKey(12));
		assertFalse("PrimitiveTypeMap.containsKey(true) should return false.", map.containsKey(true));
	}
	
	public function testSize(Void):Void {
		var map:Map = getFilledMap();
		assertSame("PrimitiveTypeMap.size() should return 3.", map.size(), 3);
		map.remove("key");
		assertSame("PrimitiveTypeMap.size() should return 2.", map.size(), 2);
		map.clear();
		assertSame("PrimitiveTypeMap.size() should return 0.", map.size(), 0);
	}
	
	public function testIsEmpty(Void):Void {
		var map:Map = getFilledMap();
		assertFalse("PrimitiveTypeMap.isEmpty() should return false.", map.isEmpty());
		map.clear();
		assertTrue("PrimitiveTypeMap.isEmpty() should return true.", map.isEmpty());
	}
	
	public function testIterator(Void):Void {
		// How can PrimitiveTypeMap.iterator() be tested properly?
	}
	
}