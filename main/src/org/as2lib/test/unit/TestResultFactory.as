import org.as2lib.core.BasicInterface;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.Test;

interface org.as2lib.test.unit.TestResultFactory extends BasicInterface {
	public function createResult(test:Test, runner:TestRunner):TestResult;
}