import org.as2lib.test.unit.AbstractAssertInfo;
import org.as2lib.util.Call;
import org.as2lib.util.StringUtil;
import org.as2lib.env.util.ReflectUtil;

class org.as2lib.test.unit.info.AssertNotThrowsInfo extends AbstractAssertInfo {
	
	private var type;
	private var args:Array;
	private var exception;
	private var exceptionThrown:Boolean = false;
	private var toCall:Call;
	
	public function AssertNotThrowsInfo(message:String, type, toCall:Call, args:Array) {
		super(message);
		this.type = type;
		this.toCall = toCall;
		this.args = args;
	}
	
	public function execute(Void):Boolean {
		try {
			toCall.execute(args);
		} catch(e) {
			exception = e;
			exceptionThrown = true;
			if(type != null) {
				return (e instanceof type);
			} else {
				return true;
			}
		}
		return (type == null);
	}
	
	private function getFailureMessage(Void):String {
		var result:String = "assertNotThrows failed";
		if(hasMessage()) {
			result += " with message: "+message;
		}
		result += "!\n";
		if(typeof type == "function") {
			result += "  - Expected exception:\n      "+ReflectUtil.getClassInfo(type).getFullName();
		} else if(type == null) {
			result += "  - No exception expected.";
		} else {
			result += "  - Expected exception:\n      "+type;
		}
		if(exceptionThrown) {
			result += "\n  - Thrown exception:\n"+StringUtil.addSpaceIndent(exception.toString(), 6);
		} else {
			result += "\n  - No exception thrown.";
		}
		return result;
	}
	
	private function getSuccessMessage(Void):String {
		var result:String = "assertNotThrows executed. ";
		
		if(typeof type == "function") {
			result += ReflectUtil.getClassInfo(type).getFullName();
		} else {
			result += type;
		}
		
		result += "was not thrown by calling "+toCall.toString()+".";
		
		return result;
	}
}