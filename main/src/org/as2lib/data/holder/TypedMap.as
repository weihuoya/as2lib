import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.MapIterator;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.HolderConfig;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.except.IllegalArgumentException;

class org.as2lib.data.holder.TypedMap extends BasicClass implements Map {
	private var map:Map;
	private var type:Function;
	
	public function TypedMap(type:Function, map:Map) {
		this.map = map;
		this.type = type;
	}
	
	public function containsKey(key):Boolean {
		return map.containsKey(key);
	}
	
	public function containsValue(value):Boolean {
		return map.containsValue(value);
	}
	
	public function getKeys(Void):Array {
		return map.getKeys();
	}
	
	public function getValues(Void):Array {
		return map.getValues();
	}
	
	public function get(key) {
		return map.get(key);
	}
	
	public function put(key, value) {
		validate(value);
		return map.put(key, value);
	}
	
	public function clear(Void):Void {
		map.clear();
	}
	
	public function putAll(map:Map):Void {
		var iterator:Iterator = map.iterator();
		while (iterator.hasNext()) {
			validate(iterator.next());
		}
		map.putAll(map);
	}
	
	public function remove(key) {
		return map.remove(key);
	}
	
	public function iterator(Void):Iterator {
		return map.iterator();
	}
	
	public function size(Void):Number {
		return map.size();
	}
	
	public function isEmpty(Void):Boolean {
		return map.isEmpty();
	}
	
	public function toString(Void):String {
		return map.toString();
	}
	
	private function validate(object):Void {
		if (!ObjectUtil.typesMatch(object, type)) {
			throw new IllegalArgumentException("Type mismatch between [" + object + "] and [" + type + "].");
		}
	}
}