import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.InstanciationError extends AbstractAssertInfo {
	
	public function InstanciationError(message:String) {
		super(message);
	}
	
	private function getFailureMessage(Void):String {
		return message;
	}
}