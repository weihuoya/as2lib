import org.as2lib.test.unit.Test;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.iterator.Iterator;

class test.org.as2lib.data.holder.THashMap extends Test{
	public function THashMap(Void) {
	}
   
	public function testContainsKey(Void):Void {
		var map:Map = new HashMap();
		var key:Object = new Object();
		map.put(key, true);
		assertTrue(map.containsKey(key));
		assertFalse(map.containsKey("Hi There!"));
		assertFalse(map.containsKey());
	}
	
	public function testContainsValue(Void):Void {
		var map:Map = new HashMap();
		map.put("key", true);
		assertTrue(map.containsValue(true));
		assertFalse(map.containsValue("I'm not in there"));
		assertFalse(map.containsValue());
	}
	
	public function testGetKeys(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", true);
		map.put("key2", false);
		var keys:Array = map.getKeys();
		assertEquals(keys[0], "key1");
		assertEquals(keys[1], "key2");
		// Changes made to the Array returned by HashMap.getKeys() must not alter the HashMap's actual keys. 
		keys[0] = "Hi!";
		if(map.getKeys()[0]=="Hi!") {
			fail("Changes made to the Array returned by HashMap.getKeys() do alter the HashMap's actual keys!");
		}
	}
	
	public function testGetValues(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		var values:Array = map.getValues();
		assertEquals(values[0], "value1");
		assertEquals(values[1], "value2");
		// Changes made to the Array returned by HashMap.getValues() must not alter the HashMap's actual values. 
		values[0] = "Hi!";
		if(map.getValues()[0]=="Hi!") {
			fail("Changes made to the Array returned by HashMap.getValues() do alter the HashMap's actual values!");
		}
	}
	
	public function testGet(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		assertEquals(map.get("key1"), "value1");
		assertEquals(map.get("key2"), "value2");
		assertNotEquals(map.get("key1"), "Just some text");
		assertNull(map.get("Nonexisting key"));
	}
	
	public function testPut(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		assertEquals(map.get("key1"), "value1");
		assertEquals(map.put("key1", "value2"), "value1");
		assertEquals(map.get("key1"), "value2");
	}
	
	public function testClear(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		map.clear();
		assertEquals(map.getValues().length, 0);
		assertEquals(map.getKeys().length, 0);
		assertEquals(map.size(), 0);
	}
	
	public function testPutAll(Void):Void {
		var map1:Map = new HashMap();
		map1.put("key1", "value1");
		map1.put("key2", "value2");
		
		var map2:Map = new HashMap();
		map2.put("key2", "newValue2");
		map2.put("key3", "value3");
		map2.put("key4", "value4");
		
		map1.putAll(map2);
		
		assertEquals(map1.getValues().length, 4);
		assertEquals(map1.getKeys().length, 4);
		assertEquals(map1.get("key1"), "value1");
		assertEquals(map1.get("key2"), "newValue2");
		assertEquals(map1.get("key4"), "value4");
	}
	
	public function testRemove(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		map.remove("key1");
		assertNull(map.get("key1"));
	}
	
	public function testSize(Void):Void {
		var map:Map = new HashMap();
		assertEquals(map.size(), 0);
		map.put("key1", "value1");
		map.put("key2", "value2");
		assertEquals(map.size(), 2);
		map.clear();
		assertEquals(map.size(), 0);
	}
	
	public function testIsEmpty(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		assertFalse(map.isEmpty());
		map.clear();
		assertTrue(map.isEmpty());
	}
	
	public function testIterator(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		var iterator:Iterator = map.iterator();
		assertEquals(iterator.next(), "value1");
		assertTrue(iterator.hasNext());
		assertEquals(iterator.next(), "value2");
		iterator.remove();
		assertEquals(map.size(), 1);
		assertNull(map.get("key2"));
	}
}