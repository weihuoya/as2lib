import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.AssertEqualsInfo extends AbstractAssertInfo {
	
	private var val;
	private var compareTo;
	
	public function AssertEqualsInfo(message:String, val, compareTo) {
		super(message);
		this.val = val;
		this.compareTo = compareTo;
	}
	
	public function execute(Void):Boolean {
		return(val != compareTo);
	}
	
	private function getFailureMessage(Void):String {
		var result:String = "assertEquals failed";
		if(hasMessage()) {
			result += " with message: "+message;
		}
		result += "!\n"
				+ "  "+val+" != "+compareTo;
		return result;
	}
	
	private function getSuccessMessage(Void):String {
		return ("assertEquals executed. "+val+" == "+compareTo+".");
	}
}