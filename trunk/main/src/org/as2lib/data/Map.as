import org.as2lib.data.Iterator;

interface org.as2lib.data.Map {
	public function clear():Void;
	public function containsKey(key:Object):Boolean;
	public function containsValue(value:Object):Boolean;
	public function get(key:Object):Object;
	public function getKeys():Array;
	public function getValues():Array;
	public function isEmpty():Boolean;
	public function iterator():Iterator;
	public function set(key:Object, value:Object):Object;
	public function putAll(map:Map):Void;
	public function remove(key:Object):Object;
	public function size():Number;
}