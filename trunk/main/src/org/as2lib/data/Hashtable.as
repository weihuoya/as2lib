import org.as2lib.data.Map;
import org.as2lib.data.HashtableIterator;
import org.as2lib.data.Iterator;
import org.as2lib.data.ArrayIterator;

class org.as2lib.data.Hashtable implements Map {
	
	private var _keys:Array;
	private var _values:Array;
	
	public function Hashtable() {
		_keys = new Array();
		_values = new Array();
	}
	
	public function clear():Void {
		_keys = new Array();
		_values = new Array();
	}
	
	public function containsKey(key:Object):Boolean {
		return findKey(key)!=-1;
	}
	
	public function containsValue(value:Object):Boolean {
		return findValue(value)!=-1;
	}
	
	public function get(key:Object):Object {
		return containsKey(key) ? _values[findKey(key)] : null;
	}
	
	public function getKeys():Array {
		return _keys.slice();
	}
	
	public function getValues():Array {
		return _values.slice();
	}
	
	public function isEmpty():Boolean {
		return size()==0;
	}
	
	public function iterator():Iterator {
		return new HashtableIterator(this);
	}
	
	public function set(key:Object, value:Object):Object {
		var result:Object;
		if(containsKey(key)) {
			result = get(key);
			_values[findKey(key)] = value;
			return result;
		} else {
			result = null;
			_keys.push(key);
			_values.push(value);
		}
		return result;
	}
	
	public function putAll(map:Map):Void {
		var valueIterator:ArrayIterator = new ArrayIterator(map.getValues());
		for(var keyIterator:ArrayIterator = new ArrayIterator(map.getKeys()); keyIterator.hasNext();) {
			set(keyIterator.next(), valueIterator.next());
		}
	}
	
	public function remove(key:Object):Object {
		var result:Object;
		if(findKey(key)!=-1) {
			result = get(key);
			_values.splice(findKey(key), 1);
			_keys.splice(findKey(key), 1);
		} else {
			result = null;
		}
		return result;
	}
	
	public function size():Number {
		return _keys.length;
	}
	
	public function toString():String {
		var result:String = "{";
		var valueIterator:ArrayIterator = new ArrayIterator(_values);
		for(var keyIterator:ArrayIterator = new ArrayIterator(_keys); keyIterator.hasNext();) {
			result += keyIterator.next().toString()+"="+valueIterator.next().toString();
			if(keyIterator.hasNext())
				result += ", ";
		}
		result += "}";
		return result;
	}
	
	private function findValue(value:Object):Number {
		for(var i:Number=0;i<size();i++)
			if(_values[i]==value)
				return i;
		return -1;
	}
	
	private function findKey(key:Object):Number {
		for(var i:Number=0;i<size();i++)
			if(_keys[i]==key)
				return i;
		return -1;
	}
}