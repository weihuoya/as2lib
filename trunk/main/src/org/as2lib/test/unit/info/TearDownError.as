import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.TearDownError extends AbstractAssertInfo {
	
	public function TearDownError(message:String) {
		super(message);
	}
	
	private function getFailureMessage(Void):String {
		return message;
	}
}