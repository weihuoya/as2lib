import org.as2lib.data.Iterator;

class org.as2lib.data.ArrayIterator implements Iterator {
	
	private var _target:Array;
	private var _currentIndex:Number;
	
	public function ArrayIterator(target:Array) {
		_target = target;
		_currentIndex = -1;
	}
	
	public function hasNext():Boolean {
		return _currentIndex<_target.length-1;
	}
	
	public function next():Object {
		return _target[++_currentIndex];
	}
	
	public function remove():Void {
		_target.splice(_currentIndex, 1);
		_currentIndex--;
	}
}