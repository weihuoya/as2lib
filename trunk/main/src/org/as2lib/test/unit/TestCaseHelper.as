import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestRunner;

class org.as2lib.test.unit.TestCaseHelper extends TestCase {
	private var testCase:TestCase;
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	public function TestCaseHelper(testCase:TestCase) {
		this.testCase = testCase;
	}
	public function getTestRunner(Void):TestRunner {
		return testCase.getTestRunner();
	}
}