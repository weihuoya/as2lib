import org.as2lib.env.reflect.treflect.SuperClass;

class org.as2lib.env.reflect.treflect.SubClass extends SuperClass {
	public static function publicStaticMethod(Void):Void {
	}
	private static function privateStaticMethod(Void):Void {
	}
	
	public function publicMethod(Void):Void {
	}
	private function privateMethod(Void):Void {
	}
	
	public static function set staticSetAndGetProperty(p:String):Void {
	}
	public static function get staticSetAndGetProperty():String {
		return "";
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