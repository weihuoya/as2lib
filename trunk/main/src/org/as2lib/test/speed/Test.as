import org.as2lib.env.out.OutAccess;
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
	private var out:OutAccess;
	
	/**
	 * Constructs a new Test.
	 */
	function Test(Void) {
		this.speedTestCases = new TypedArray(TestCaseInformation);
	}
	
	/**
	 * Runs all applied tests.
	 * 
	 * @see #printResult
	 * @param true if it should print the result immediatly.
	 */
	public function run(printResult:Boolean):Void {
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
	 * Adds a testcase to get tested.
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
	 * @see org.aslib.env.out.Out
	 * @param Output Device
	 */
	public function setOut(to:OutAccess):Void {
		this.out = to;
	}
	
	/**
	 * Defines the times how often all Testcases should be processed.
	 *
	 * @see #run
	 */
	public function setCalls(to:Number):Void {
		this.calls = to;
	}
	
	/**
	 * Evaluates the fastest testcase out of all available testcases.
	 *
	 * @return the fastest testcase.
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
	 * Redirects the result as a string to the output writer.
	 * 
	 * @see #run
	 */
	public function printResult(Void):Void {
		this.out.info(this.resultAsString());
	}
	
	/**
	 * Generates a comparison using all available informations.
	 *
	 * @returns A string containing all relevant informations.
	 */
	public function resultAsString(Void):String {
		var fastest:TestCaseInformation = this.getFastestTestCase();
		var result:String = "\n          -- Testresult ["+this.calls+" calls] -- \n";
		for(var i:Number=0; i<this.speedTestCases.length; i++) {
			var obj:TestCaseInformation = TestCaseInformation(this.speedTestCases.getValue(i));
			if(fastest == obj) {
				result += "[fastest] "+Math.round(this.getPercent(obj, fastest))+"% "+obj.getName()+": total time:"+obj.getTotalTime()+"ms; calls/second:"+obj.getMaxCallsPerSecond()+"; average time:"+obj.getAverageTime()+"ms;\n";
			} else {
				result += "          "+Math.round(this.getPercent(obj, fastest))+"% "+obj.getName()+": total time:"+obj.getTotalTime()+"ms; calls/second:"+obj.getMaxCallsPerSecond()+"; average time:"+obj.getAverageTime()+"ms; (+"+Math.round(this.getAverageTimeDifference(obj, fastest)*1000)/1000+"ms)\n";
			}
		}
		return result;
	}
	
	/**
	 * Calculates the percentage of the speed from a testCaseInfo depending to a base.
	 *
	 * @param TestcaseInfo that should get compared.
	 * @param TestcaseInfo that represents the base.
	 * @returns Number in Percent (100%=100).
	 * @see org.as2lib.test.speed.TestInformation
	 */
	private function getPercent(from:TestCaseInformation, base:TestCaseInformation):Number{
		return(from.getTotalTime()/base.getTotalTime()*100);
	}
	
	/**
	 * Calulates the average time difference between the average time of a testcaseinformation depending to a base.
	 * 
	 * @param Testcaseinfo that should get compared.
	 * @param TestcaseInfo that represents the base.
	 * @returns The timedifference in milliseconds.
	 * @see org.as2ib.test.speed.TestInformation
	 */
	private function getAverageTimeDifference(from:TestCaseInformation, base:TestCaseInformation):Number {
		return(from.getAverageTime()-base.getAverageTime());
	}
}