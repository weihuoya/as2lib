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
	}
	
	public function testContainsValue(Void):Void {
		var map:Map = new HashMap();
		map.put("key", true);
		assertTrue(map.containsValue(true));
	}
	
	public function testGetKeys(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", true);
		map.put("key2", false);
		var keys:Array = map.getKeys();
		assertTrue(keys[0] == "key1");
		assertTrue(keys[1] == "key2");
	}
	
	public function testGetValues(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		var values:Array = map.getValues();
		assertTrue(values[0] == "value1");
		assertTrue(values[1] == "value2");
	}
	
	public function testGet(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		assertTrue(map.get("key1") == "value1");
		assertTrue(map.get("key2") == "value2");
	}
	
	public function testPut(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key1", "value2");
		assertTrue(map.get("key1") == "value2");
	}
	
	public function testClear(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		map.clear();
		assertTrue(map.getValues().length == 0);
		assertTrue(map.getKeys().length == 0);
	}
	
	public function testPutAll(Void):Void {
		var map1:Map = new HashMap();
		map1.put("key1", "value1");
		map1.put("key2", "value2");
		
		var map2:Map = new HashMap();
		map2.put("key3", "value3");
		map2.put("key4", "value4");
		
		map1.putAll(map2);
		
		assertTrue(map1.getValues().length == 4);
		assertTrue(map1.getKeys().length == 4);
		assertTrue(map1.get("key1") == "value1");
		assertTrue(map1.get("key4") == "value4");
	}
	
	public function testRemove(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		map.remove("key1");
		assertTrue(map.get("key1") == undefined);
	}
	
	public function testSize(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		assertTrue(map.size() == 2);
	}
	
	public function testIsEmpty(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		map.put("key2", "value2");
		assertTrue(map.isEmpty() == false);
		map.clear();
		assertTrue(map.isEmpty());
	}
	
	public function testIterator(Void):Void {
		var map:Map = new HashMap();
		map.put("key1", "value1");
		var iterator:Iterator = map.iterator();
		while (iterator.hasNext()) {
			assertTrue(iterator.next() == "value1");
		}
	}
}