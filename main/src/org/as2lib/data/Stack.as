class org.as2lib.data.Stack {
	private var array:Array;
	
	public function push(object:Object):Object {
		array.push(object);
		return object;
	}
	
	public function pop(Void):Object {
		return array.pop();
	}
	
	public function peek(Void):Object {
		return array[array.length - 1];
	}
	
	public function isEmpty() {
		return (array.length == 0);
	}
}