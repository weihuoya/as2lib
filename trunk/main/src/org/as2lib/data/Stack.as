class org.as2lib.data.Stack {
	private var data:Array;
	
	public function push(object:Object):Object {
		data.push(object);
		return object;
	}
	
	public function pop(Void):Object {
		return data.pop();
	}
	
	public function peek(Void):Object {
		return data[data.length - 1];
	}
	
	public function isEmpty() {
		return (data.length == 0);
	}
}