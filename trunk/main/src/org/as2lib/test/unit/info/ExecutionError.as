import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.ExecutionError extends AbstractAssertInfo {
	
	public function ExecutionError(message:String) {
		super(message);
	}
	
	private function getFailureMessage(Void):String {
		return message;
	}
}