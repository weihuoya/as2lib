import org.as2lib.core.BasicClass;
import org.as2lib.test.unit.TestRunnerInfo;
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestCaseMethodInfo;

class org.as2lib.test.unit.ProgressInfo extends BasicClass implements TestRunnerInfo {
	
	private var testRunner:TestRunner;
	private var testCaseResult:TestCaseResult;
	private var testCaseMethod:TestCaseMethodInfo;
	
	public function ProgressInfo(testRunner:TestRunner, testCaseResult:TestCaseResult, testCaseMethod:TestCaseMethodInfo) {
		this.testRunner = testRunner;
		this.testCaseResult = testCaseResult;
		this.testCaseMethod = testCaseMethod;
	}
	
	public function getTestRunner(Void):TestRunner {
		return testRunner;
	}
	
	public function getRunningTestCase(Void):TestCaseResult {
		return testCaseResult;
	}
	
	public function getFinishedMethodInfo(Void):TestCaseMethodInfo {
		return testCaseMethod;
	}
	
	public function getName(Void):String {
		return "onProgress";
	}
}