import org.as2lib.basic.BasicClass;

class test.org.as2lib.basic.reflect.DummieClass extends BasicClass {
	public static function set muh(muh:String) {
		
	}
	
	public function helloWorld () {
		trace("here i am");
	}
	
	public function set name(name:String) {
	}
	
	public function get name():String {
		return "name";
	}
	
	public function get number():Number {
		return 2;
	}
	
	public function set string(string:String):Void {
	}
}