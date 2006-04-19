/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 

/**
 * Interface for Vectors.
 */
interface org.aswing.util.IVector {
	public function get(i:Number):Object;
	public function append(obj:Object, index:Number):Void;
	public function appendAll(arr:Array, index:Number):Void;
	public function replaceAt(index:Number, obj:Object):Object;
	public function removeAt(index:Number):Object;
	public function remove(obj:Object):Object;
	public function removeRange(fromIndex:Number, toIndex:Number):Array;
	public function indexOf(obj:Object):Number;
	public function contains(obj:Object):Boolean;
	public function first():Object;
	public function last():Object;
	
	public function size():Number;
	public function clear():Void;
	public function sort(compare:Object, options:Number):Array;
	public function sortOn(key:Object, options:Number):Array;
	
	public function isEmpty():Boolean;
	public function toArray():Array;
}
