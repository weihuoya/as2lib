import org.as2lib.data.iterator.Iterator;
import org.as2lib.core.BasicInterface;

interface org.as2lib.data.holder.Map extends BasicInterface {
	public function containsKey(key):Boolean;
	public function containsValue(value):Boolean;
	public function getKeys(Void):Array;
	public function getValues(Void):Array;
	public function get(key);
	public function put(key, value);
	public function putAll(map:Map):Void;
	public function remove(key);
	public function clear(Void):Void;
	public function iterator(Void):Iterator;
	public function getIterator(Void):Iterator;
	public function size(Void):Number;
	public function getSize(Void):Number;
	public function isEmpty(Void):Boolean;
}