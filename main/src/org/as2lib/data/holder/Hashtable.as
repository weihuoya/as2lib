import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.HashtableIterator;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;

class org.as2lib.data.holder.Hashtable implements Map {
	private var keys:Array;
	private var values:Array;
	
	public function Hashtable() {
		keys = new Array();
		values = new Array();
	}
	
	public function containsKey(key:Object):Boolean {
		return findKey(key) != -1;
	}
	
	public function containsValue(value:Object):Boolean {
		return findValue(value) != -1;
	}
	
	public function getKeys(Void):Array {
		return keys.slice();
	}
	
	public function getValues(Void):Array {
		return values.slice();
	}
	
	public function get(key:Object):Object {
		return containsKey(key) ? values[findKey(key)] : null;
	}
	
	public function put(key:Object, value:Object):Object {
		if (containsKey(key)) {
			var result:Object = get(key);
			values[findKey(key)] = value;
			return result;
		}
		keys.push(key);
		values.push(value);
		return null;
	}
	
	public function clear(Void):Void {
		keys = new Array();
		values = new Array();
	}
	
	public function putAll(map:Map):Void {
		var valueIterator:ArrayIterator = new ArrayIterator(map.getValues());
		var keyIterator:ArrayIterator = new ArrayIterator(map.getKeys())
		while (keyIterator.hasNext()) {
			set(keyIterator.next(), valueIterator.next());
		}
	}
	
	public function remove(key:Object):Object {
		if (findKey(key) != -1) {
			var result:Object = get(key);
			values.splice(findKey(key), 1);
			keys.splice(findKey(key), 1);
			return result;
		}
		return null;
	}
	
	public function iterator(Void):Iterator {
		return (new HashtableIterator(this));
	}
	
	public function size(Void):Number {
		return keys.length;
	}
	
	public function isEmpty(Void):Boolean {
		return size() == 0;
	}
	
	private function findValue(value:Object):Number {
		for (var i:Number = 0; i < size(); i++) {
			if (values[i] == value) {
				return i;
			}
		}
		return -1;
	}
	
	private function findKey(key:Object):Number {
		for (var i:Number = 0; i < size(); i++) {
			if (keys[i] == key) {
				return i;
			}
		}
		return -1;
	}
	
	public function toString(Void):String {
		var result:String = "{";
		var valueIterator:ArrayIterator = new ArrayIterator(values);
		var keyIterator:ArrayIterator = new ArrayIterator(keys)
		while (keyIterator.hasNext()) {
			result += keyIterator.next().toString()+"="+valueIterator.next().toString();
			if (keyIterator.hasNext()) {
				result += ", ";
			}
		}
		result += "}";
		return result;
	}
}