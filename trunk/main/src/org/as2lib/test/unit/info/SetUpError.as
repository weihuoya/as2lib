import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.SetUpError extends AbstractAssertInfo {
	
	public function SetUpError(message:String) {
		super(message);
	}
	
	private function getFailureMessage(Void):String {
		return message;
	}
}