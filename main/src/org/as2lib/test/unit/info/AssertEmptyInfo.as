﻿import org.as2lib.test.unit.AbstractAssertInfo;

class org.as2lib.test.unit.info.AssertEmptyInfo extends AbstractAssertInfo {
	
	private var val;
	
	public function AssertEmptyInfo(message:String, val) {
		super(message);
		this.val = val;
	}
	
	public function execute(Void):Boolean {
		return(val != null);
	}
	
	private function getFailureMessage(Void):String {
		var result:String = "assertEmpty failed";
		if(hasMessage()) {
			result += " with message: "+message;
		}
		result += "!\n"
				+ "  "+val+" != null";
		return result;
	}
	
	private function getSuccessMessage(Void):String {
		return ("assertEmpty executed.");
	}
}