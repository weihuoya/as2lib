import org.as2lib.core.BasicClass;
import org.as2lib.test.unit.TestRunnerInfo;
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestRunner;

class org.as2lib.test.unit.ResumeInfo extends BasicClass implements TestRunnerInfo {
	
	private var testRunner:TestRunner;
	
	public function ResumeInfo(testRunner:TestRunner) {
		this.testRunner = testRunner;
	}
	
	public function getTestRunner(Void):TestRunner {
		return testRunner;
	}
	
	public function getName(Void):String {
		return "onResume";
	}
}