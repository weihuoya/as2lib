import org.as2lib.core.BasicClass;

class test.org.as2lib.core.overload.Dummy extends BasicClass {
	public function Dummy(Void) {
	}
	
	public function execute():Number {
		var result:Number = Number(overload(arguments, [newOverloadHandler([Number, String, BasicClass], execute1),
								   						newOverloadHandler([Function, Number], execute2)]));
		return result;
	}
	
	public function execute1(a:Number, b:String, c:BasicClass):Number {
		return 1;
	}
	
	public function execute2(a:Function, b:Number):Number {
		return 2;
	}
}