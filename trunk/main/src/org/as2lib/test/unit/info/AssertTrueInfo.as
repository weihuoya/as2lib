import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.AssertTrueInfo extends AbstractAssertInfo {
	
	private var val;
	
	public function AssertTrueInfo(message:String, val) {
		super(message);
		this.val = val;
	}
	
	public function execute(Void):Boolean {
		return(val !== true);
	}
	
	private function getFailureMessage(Void):String {
		var result:String = "assertTrue failed";
		if(hasMessage()) {
			result += " with message: "+message;
		}
		result += "!\n"
				+ "  "+val+" !== true";
		return result;
	}
	
	private function getSuccessMessage(Void):String {
		return ("assertTrue executed.");
	}
}