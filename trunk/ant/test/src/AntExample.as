class AntExample {
	function AntExample() {
		_root.createTextField("tf",10,120,200,600,800);
		_root.tf.text = "Hello world !";
		
		_root.attachMovie("test", "test_mc", 20);
		_root.test_mc._x = 60;
		_root.test_mc._y = 20;
	}
	
	static function main() {
		var t = new AntExample();
	}
}