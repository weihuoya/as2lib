import org.as2lib.core.BasicInterface;
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.util.Stringifier;

interface org.as2lib.test.unit.TestResult extends BasicInterface {
	public function getPercentage(Void):Number;
	public function isFinished(Void):Boolean;
	public function isStarted(Void):Boolean;
	public function getName(Void):String;
	public function getOperationTime(Void):Number;
	public function hasErrors(Void):Boolean;
	public function getTestResults(Void):TypedArray;
	public function getTestCaseResults(Void):TypedArray;
	public function print(Void):Void;
}