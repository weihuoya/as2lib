import org.as2lib.data.Iterator;

class org.as2lib.data.ArrayIterator implements Iterator {
	private var target:Array;
	private var index:Number;
	
	public function ArrayIterator(newTarget:Array) {
		target = newTarget;
		index = -1;
	}
	
	public function hasNext(Void):Boolean {
		return (index < target.length - 1);
	}
	
	public function next(Void):Object {
		return target[++index];
	}
	
	public function remove(Void):Void {
		target.splice(index--, 1);
	}
}