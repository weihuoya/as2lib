import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.AssertNotInfinityInfo extends AbstractAssertInfo {
	
	private var val;
	
	public function AssertNotInfinityInfo(message:String, val) {
		super(message);
		this.val = val;
	}
	
	public function execute(Void):Boolean {
		return(val === Infinity);
	}
	
	private function getFailureMessage(Void):String {
		var result:String = "assertNotInfinity failed";
		if(hasMessage()) {
			result += " with message: "+message;
		}
		result += "!\n"
				+ "  "+val+" === Infinity";
		return result;
	}
	
	private function getSuccessMessage(Void):String {
		return ("assertNotInfinity executed. "+val+" !== Infinity.");
	}
}