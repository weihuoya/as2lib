import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.AssertFalseInfo extends AbstractAssertInfo {
	
	private var val;
	
	public function AssertFalseInfo(message:String, val) {
		super(message);
		this.val = val;
	}
	
	public function execute(Void):Boolean {
		return(val !== false);
	}
	
	private function getFailureMessage(Void):String {
		var result:String = "assertFalse failed";
		if(hasMessage()) {
			result += " with message: "+message;
		}
		result += "!\n"
				+ "  "+val+" !== false";
		return result;
	}
	
	private function getSuccessMessage(Void):String {
		return ("assertFalse executed.");
	}
}