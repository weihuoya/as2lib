import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.AssertUndefinedInfo extends AbstractAssertInfo {
	
	private var val;
	
	public function AssertUndefinedInfo(message:String, val) {
		super(message);
		this.val = val;
	}
	
	public function execute(Void):Boolean {
		return(val !== undefined);
	}
	
	private function getFailureMessage(Void):String {
		var result:String = "assertUndefined failed";
		if(hasMessage()) {
			result += " with message: "+message;
		}
		result += "!\n"
				+ "  "+val+" !== undefined";
		return result;
	}
	
	private function getSuccessMessage(Void):String {
		return ("assertUndefined executed.");
	}
}