import org.as2lib.data.Iterator;

class org.as2lib.data.ArrayIterator implements Iterator {
	private var target:Array;
	private var currentIndex:Number;
	
	public function ArrayIterator(newTarget:Array) {
		target = newTarget;
		currentIndex = -1;
	}
	
	public function hasNext(Void):Boolean {
		return (currentIndex < target.length - 1);
	}
	
	public function next(Void):Object {
		return target[++currentIndex];
	}
	
	public function remove(Void):Void {
		target.splice(currentIndex, 1);
		currentIndex--;
	}
}