import org.as2lib.core.BasicInterface;
import org.as2lib.env.event.EventInfo;
import org.as2lib.test.unit.TestRunner;

interface org.as2lib.test.unit.TestRunnerInfo extends EventInfo {
	public function getTestRunner(Void):TestRunner;
}