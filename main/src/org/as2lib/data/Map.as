import org.as2lib.data.Iterator;

interface org.as2lib.data.Map {
	public function containsKey(key:Object):Boolean;
	public function containsValue(value:Object):Boolean;
	public function getKeys(Void):Array;
	public function getValues(Void):Array;
	public function get(key:Object):Object;
	public function put(key:Object, value:Object):Object;
	public function putAll(map:Map):Void;
	public function remove(key:Object):Object;
	public function clear(Void):Void;
	public function iterator(Void):Iterator;
	public function size(Void):Number;
	public function isEmpty(Void):Boolean;
}