import org.as2lib.core.BasicClass;
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestResultFactory;

class org.as2lib.test.unit.TestCaseResultFactory extends BasicClass implements TestResultFactory {
	public function createResult(test:Test, runner:TestRunner):TestResult {
		return new TestCaseResult(TestCase(test), runner);
	}
}