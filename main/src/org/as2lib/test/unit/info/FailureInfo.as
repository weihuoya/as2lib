import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.FailureInfo extends AbstractAssertInfo {
	
	private var message:String
	
	public function FailureInfo(message:String) {
		this.message = message;
	}
	
	public function isFailed(Void):Boolean {
		return true;
	}
	
	private function getFailureMessage(Void):String {
		return("Failed with message: "+message);
	}
}