import org.as2lib.core.BasicClass
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestSuite;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestSuiteResult;
import org.as2lib.test.unit.TestResultFactory;

class org.as2lib.test.unit.TestSuiteResultFactory extends BasicClass implements TestResultFactory {
	public function createResult(test:Test, runner:TestRunner):TestResult {
		return new TestSuiteResult(TestSuite(test), runner);
	}
}