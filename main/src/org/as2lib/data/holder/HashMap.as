import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.HashMapIterator;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;

class org.as2lib.data.holder.HashMap implements Map {
	private var keys:Array;
	private var values:Array;
	
	public function HashMap() {
		keys = new Array();
		values = new Array();
		keys[-1] = values[-1] = null;
	}
	
	public function containsKey(key):Boolean {
		return (findKey(key) != -1);
	}
	
	public function containsValue(value):Boolean {
		return (findValue(value) != -1);
	}
	
	public function getKeys(Void):Array {
		return keys.slice();
	}
	
	public function getValues(Void):Array {
		return values.slice();
	}
	
	public function get(key):Object {
		return values[findKey(key)];
	}
	
	public function put(key, value):Object {
		var result:Object = null;
		var i:Number = findKey(key);
		if(i!=-1) {
			result = values[i];
			values[i] = value;
		} else {
			keys.push(key);
			values.push(value);
		}
		return result;
	}
	
	public function clear(Void):Void {
		keys = new Array();
		values = new Array();
		keys[-1] = values[-1] = null;
	}
	
	public function putAll(map:Map):Void {
		var valueIterator:ArrayIterator = new ArrayIterator(map.getValues());
		var keyIterator:ArrayIterator = new ArrayIterator(map.getKeys())
		while (keyIterator.hasNext()) {
			put(keyIterator.next(), valueIterator.next());
		}
	}
	
	public function remove(key):Object {
		var result:Object = null;
		var i:Number = findKey(key);
		if(i!=-1) {
			result = values[i];
			values.splice(i, 1);
			keys.splice(i, 1);
		}
		return result;
	}
	
	public function iterator(Void):Iterator {
		return (new HashMapIterator(this));
	}
	
	public function size(Void):Number {
		return keys.length;
	}
	
	public function isEmpty(Void):Boolean {
		return (size() == 0);
	}
	
	private function findValue(value):Number {
		var l = values.length;
		while (values[--l] != value && l>-1);
		return l;
	}
	
	private function findKey(key):Number {
		var l = keys.length;
		while (keys[--l] != key && l>-1);
		return l;
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