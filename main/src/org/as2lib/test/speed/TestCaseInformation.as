import org.as2lib.test.speed.TestCase;
import org.as2lib.env.util.ReflectUtil;

/**
 * Wrapper arround a Testcase that evaluates all informations.
 * This class wrapps additional Informations around a TestCase.
 * It saves the time of the executing and provides various methods
 * to get informations.
 * 
 * @autor Martin Heidegger
 * @version 1.0
 * @see org.as2lib.test.speed.Test
 * @see org.as2lib.test.speed.TestCase
 */
class org.as2lib.test.speed.TestCaseInformation {
	/** Internal testcaseholder */
	private var testCase:TestCase;
	/** Total time executed */
	private var totalTime:Number;
	/** Times that run was executed */
	private var runs:Number;
	
	/**
	 * Constructs a TestCaseInformation.
	 *
	 * @param Testcase that should get wrapped
	 */
	function TestCaseInformation(testCase:TestCase) {
		this.testCase = testCase;
		this.totalTime = 0;
		this.runs = 0;
	}
	
	/**
	 * Runs the testcase and saves the executing time.
	 */
	public function run(Void):Void {
		var beforeRun:Number = getTimer();
		this.testCase.run();
		var afterRun:Number = getTimer();
		this.runs++;
		this.totalTime += afterRun-beforeRun;
	}
	
	/**
	 * @return total executing time from all calls in ms.
	 */
	public function getTotalTime(Void):Number {
		return this.totalTime;
	}
	
	/** 
	 * @return times how often this testcase was run.
	 */
	public function getRuns(Void):Number {
		return this.runs;
	}
	
	/**
	 * @return average executing time in ms.
	 */
	public function getAverageTime(Void):Number {
		return this.getTotalTime()/this.getRuns();
	}
	
	/**
	 * @return name from the wrapped object.
	 */
	public function getName(Void):String {
		return ReflectUtil.getClassInfo(this.testCase).getName();
	}
}