import test.unit.org.as2lib.env.reflect.treflect.SuperClass;

class test.unit.org.as2lib.env.reflect.treflect.SubClass extends SuperClass {
	public static function publicStaticMethod(Void):Void {
	}
	private static function privateStaticMethod(Void):Void {
	}
	
	public function publicMethod(Void):Void {
	}
	private function privateMethod(Void):Void {
	}
	
	public function set setOnlyProperty(p:String):Void {
	}
	public function get getOnlyProperty():String {
		return "";
	}
	
	public function set setAndGetProperty(p:String):Void {
	}
	public function get setAndGetProperty():String {
		return "";
	}
}