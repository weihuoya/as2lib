import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.MapIterator;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.HolderConfig;

/**
 * ?
 *
 * @author Michael Hermann
 * @author Simon Wacker
 */
class org.as2lib.data.holder.HashMap extends BasicClass implements Map {
	/** Contains the keys. */
	private var keys:Array;
	
	/** Contains the values. */
	private var values:Array;
	
	/**
	 * Constructs a new HashMap.
	 */
	public function HashMap(Void) {
		keys = new Array();
		values = new Array();
		keys[-1] = values[-1] = null;
	}

	/**
	 * @see org.as2lib.data.holder.Map#containsKey()
	 */
	public function containsKey(key):Boolean {
		return (findKey(key) != -1);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#containsValue()
	 */
	public function containsValue(value):Boolean {
		return (findValue(value) != -1);
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#getKeys()
	 */
	public function getKeys(Void):Array {
		return keys.slice();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#getValues()
	 */
	public function getValues(Void):Array {
		return values.slice();
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#get()
	 */
	public function get(key) {
		return values[findKey(key)];
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#put()
	 */
	public function put(key, value) {
		var result = null;
		var i:Number = findKey(key);
		if(i != -1) {
			result = values[i];
			values[i] = value;
		} else {
			keys.push(key);
			values.push(value);
		}
		return result;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#clear()
	 */
	public function clear(Void):Void {
		keys = new Array();
		values = new Array();
		keys[-1] = values[-1] = null;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#putAll()
	 */
	public function putAll(map:Map):Void {
		var valueIterator:ArrayIterator = new ArrayIterator(map.getValues());
		var keyIterator:ArrayIterator = new ArrayIterator(map.getKeys())
		while (keyIterator.hasNext()) {
			put(keyIterator.next(), valueIterator.next());
		}
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#remove()
	 */
	public function remove(key) {
		var result = null;
		var i:Number = findKey(key);
		if(i!=-1) {
			result = values[i];
			values.splice(i, 1);
			keys.splice(i, 1);
		}
		return result;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#iterator()
	 */
	public function iterator(Void):Iterator {
		return (new MapIterator(this));
	}

	/**
	 * @see org.as2lib.data.holder.Map#size()
	 */
	public function size(Void):Number {
		return keys.length;
	}
	
	/**
	 * @see org.as2lib.data.holder.Map#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return (size() == 0);
	}
	
	/**
	 * Searches for the value and returns the index where it is stored.
	 *
	 * @return the index where the value is stored
	 */
	private function findValue(value):Number {
		var l = values.length;
		while (values[--l] != value && l>-1);
		return l;
	}
	
	/**
	 * Searches for the key and returns the index where it is stored.
	 *
	 * @return the index where the key is stored
	 */
	private function findKey(key):Number {
		var l = keys.length;
		while (keys[--l] != key && l>-1);
		return l;
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return HolderConfig.getMapStringifier().execute(this);
	}
}