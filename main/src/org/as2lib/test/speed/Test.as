import org.as2lib.out.Out;
import org.as2lib.data.holder.TypedArray;
import org.as2lib.test.speed.TestCaseInformation;
import org.as2lib.test.speed.TestCase;

/**
 * Main class to run speedtests.
 * This class can contain tests and run them with
 * defined calls.
 * Simply add so much tests you want and call "run".
 * 
 * @autor Martin Heidegger
 * @version 1.0 
 * @see #run
 * @see #addTestCase
 * @see #setCalls
 * @see #setOut
 */
class org.as2lib.test.speed.Test {
	/** Contains all Testcases to work with. */
	private var speedTestCases:TypedArray;
	/** Times of calls by running a Test */
 	private var calls:Number = 0;
    /** Output Device to display the result */
	private var out:Out;
	
	/**
	 * Constructs a new Test.
	 */
	function Test(Void) {
		trace ("aha");
		this.speedTestCases = new TypedArray(TestCaseInformation);
	}
	
	/**
	 * Runs all applied tests.
	 * 
	 * @see #printResult
	 * @param true if it should print the result immediatly.
	 */
	public function run(printResult:Boolean):Void {
		trace ("aha");
		var i:Number;
		for(i=0; i<this.speedTestCases.length; i++) {
			for(var j=0; j<this.calls; j++) {
				this.speedTestCases.getValue(i).run();
			}			
		}
		if(printResult) {
			this.printResult();
		}
	}
	
	/**
	 * Adds a Testcase to get tested.
	 *
	 * @param Testcase that should be added.
	 */
	public function addTestCase(obj:TestCase):Void {
		if (!obj) {
			throw new Error("Muh");
		}
		this.speedTestCases.push(new TestCaseInformation(obj));
	}
	
	/**
	 * Sets the output device to print the result.
	 * 
	 * @see #printResult
	 * @see org.aslib.basic.Out
	 * @param Output Device
	 */
	public function setOut(to:Out):Void {
		this.out = to;
	}
	
	/**
	 * Defines the times how often all Testcases should
	 * be run by defining run.
	 *
	 * @see #run
	 */
	public function setCalls(to:Number):Void {
		this.calls = to;
	}
	
	/**
	 * @return the fastest Testcase.
	 * @see TestCase
	 */
	private function getFastestTestCase(Void):TestCaseInformation {
		var fastest:TestCaseInformation = null;
		var fastestTime:Number = -1;
		for(var i:Number=0; i<this.speedTestCases.length; i++) {
			var obj:TestCaseInformation = TestCaseInformation(this.speedTestCases.getValue(i));
			if(fastestTime == -1 || obj.getTotalTime() < fastestTime) {
				fastest = obj;
				fastestTime = obj.getTotalTime();
			}
		}
		return fastest;
	}
	
	/**
	 * Prints the Result from all Tests.
	 */
	public function printResult(Void):Void {
		var fastest:TestCaseInformation = this.getFastestTestCase();
		var result:String = "-- Testresult ["+this.calls+" calls] -- \n";
		for(var i:Number=0; i<this.speedTestCases.length; i++) {
			var obj:TestCaseInformation = TestCaseInformation(this.speedTestCases.getValue(i));
			if(fastest == obj) {
				result += "[fastest] "+Math.round(this.getPercent(obj, fastest))+"% "+obj.getName()+": total time:"+obj.getTotalTime()+"ms; average time:"+obj.getAverageTime()+"ms;\n";
			} else {
				result += "          "+Math.round(this.getPercent(obj, fastest))+"% "+obj.getName()+": total time:"+obj.getTotalTime()+"ms; average time:"+obj.getAverageTime()+"ms;\n";
			}
		}
		this.out.info(result);
	}
	
	/**
	 * Returns the percentage from a testCaseInfo dependting to a base.
	 *
	 * @param TestcaseInfo that should get Compared
	 * @param TestcaseInfo that repesents the base
	 * @returns Number in Percent (100%=100) 
	 * @see org.as2lib.test.speed.TestInformation
	 */
	private function getPercent(from:TestCaseInformation, base:TestCaseInformation):Number{
		return(from.getTotalTime()/base.getTotalTime()*100);
	}
}