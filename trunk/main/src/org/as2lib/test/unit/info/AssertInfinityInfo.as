import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.AssertInfinityInfo extends AbstractAssertInfo {
	
	private var val;
	
	public function AssertInfinityInfo(message:String, val) {
		super(message);
		this.val = val;
	}
	
	public function execute(Void):Boolean {
		return(val !== Infinity);
	}
	
	private function getFailureMessage(Void):String {
		var result:String = "assertInfinity failed";
		if(hasMessage()) {
			result += " with message: "+message;
		}
		result += "!\n"
				+ "  "+val+" !== Infinity";
		return result;
	}
	
	private function getSuccessMessage(Void):String {
		return ("assertInfinity executed.");
	}
}