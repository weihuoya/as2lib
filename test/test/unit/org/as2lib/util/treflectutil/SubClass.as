import test.org.as2lib.util.treflectutil.SuperClass;

class test.org.as2lib.util.treflectutil.SubClass extends SuperClass {
	public function firstMethod(Void):Void {
	}
	private function secondMethod(Void):Void {
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