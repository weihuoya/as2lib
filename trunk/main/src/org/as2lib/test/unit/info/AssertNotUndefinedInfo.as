import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.AssertNotUndefinedInfo extends AbstractAssertInfo {
	
	private var val;
	
	public function AssertNotUndefinedInfo(message:String, val) {
		super(message);
		this.val = val;
	}
	
	public function execute(Void):Boolean {
		return(val === undefined);
	}
	
	private function getFailureMessage(Void):String {
		var result:String = "assertNotUndefined failed";
		if(hasMessage()) {
			result += " with message: "+message;
		}
		result += "!\n"
				+ "  "+val+" === undefined";
		return result;
	}
	
	private function getSuccessMessage(Void):String {
		return ("assertNotUndefined executed. "+val+" !== undefined.");
	}
}