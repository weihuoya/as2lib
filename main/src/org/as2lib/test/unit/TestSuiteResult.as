import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.TypedArray;
import org.as2lib.data.holder.Stack;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.ArrayUtil;
import org.as2lib.util.StringUtil;
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestSuite;
import org.as2lib.env.out.OutAccess;
import org.as2lib.env.out.Out;
import org.as2lib.env.out.handler.TraceHandler;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * 
 * 
 * @see org.as2lib.test.unit.TestSuite
 * @autor Martin Heidegger
 */
class org.as2lib.test.unit.TestSuiteResult extends BasicClass implements TestResult {

	private var tests:TypedArray;
	private var testRunner:TestRunner;
	private var testSuite:TestSuite;
	private var testResults:TypedArray;
	private static var out:OutAccess;

	/**
	 * Constructs 
	 */
	public function TestSuiteResult(testSuite:TestSuite, testRunner:TestRunner) {
		this.testSuite = testSuite;
		this.testRunner = testRunner;
		this.testResults = new TypedArray(TestResult);
		var tests:Array = testSuite.getTests();
		for(var i=0; i<tests.length; i++) {
			if(ObjectUtil.isInstanceOf(tests[i], TestCase)) {
				this.testResults.push(new TestCaseResult(tests[i], testRunner));
			} else if(ObjectUtil.isInstanceOf(tests[i], TestSuite)) {
				this.testResults.push(new TestSuiteResult(tests[i], testRunner));
			} else {
				throw new IllegalArgumentException("Type not handled!", this, arguments);
			}
		}
	}
	
	public function getTests(Void):TypedArray {
		return this.testResults;
	}
	
	public function getPercentage(Void):Number {
		var result:Number = 0;
		var unit:Number = 100/this.testResults.length;
		for(var i=this.testResults.length-1; i>=0; i--) {
			result += (unit/100*this.testResults[i].getPercentage());
		}
		return result;
	}
	
	public function isFinished(Void):Boolean {
		for(var i=this.testResults.length-1; i>=0; i--) {
			if(!this.testResults[i].isFinished()) {
				return false;
			}
		}
		return true;
	}
	
	public function isStarted(Void):Boolean {
		for(var i=this.testResults.length-1; i>=0; i--) {
			if(this.testResults[i].isStarted()) {
				return true;
			}
		}
		return false;
	}
	
	public function getTestCaseResults(Void):TypedArray {
		var result:TypedArray = new TypedArray(TestCaseResult);
		for(var i:Number=0; i<this.testResults.length; i++) {
			// TODO: Bug? Why can't i use .concat ???
			var testCases:Array = this.testResults[i].getTestCaseResults();
			for(var j:Number=0; j<testCases.length; j++) {
				result.push(testCases[j]);
			}
		}
		return result;
	}
	
	public function getName(Void):String {
		return this.getTestSuite().getName();
	}
	
	public function getOperationTime(Void):Number {
		var result:Number = 0;
		for(var i=this.testResults.length-1; i>=0; i--) {
			result += this.testResults[i].getOperationTime();
		}
		return result;
	}
	
	public function hasErrors(Void):Boolean {
		for(var i=this.testResults.length-1; i>=0; i--) {
			if(this.testResults[i].hasErrors()) {
				return true;
			}
		}
		return false;
	}
	
	public function getTestSuite(Void):TestSuite {
		return this.testSuite;
	}
	
	public function getTestResults(Void):TypedArray {
		var result:TypedArray = new TypedArray(TestResult);
		for(var i:Number=0; i<this.testResults.length; i++) {
			// TODO: Bug? Why can't i use .concat ???
			var testResults:Array = this.testResults[i].getTestResults();
			for(var j:Number=0; j<testResults.length; j++) {
				result.push(testResults[i]);
			}
		}
		return result;
	}
	
	public function toString(Void):String {
		var result:String = "";
		result += "*** TestSuite "+getName()+" ["+getOperationTime()+"ms] ***";
		for(var i=0; i<this.testResults.length; i++){
			result += "\n"+StringUtil.addSpaceIndent(this.testResults[i].toString(), 2);
		}
		result += "\n*********************************"
		return result;
	}
	
	public static function setOut(to:OutAccess):Void {
		out = to;
	}
	public static function getOut(Void):OutAccess {
		if(!out) {
			out = new Out();
			Out(out).addHandler(new TraceHandler());
		}
		return out;
	}
	public function print(Void):Void {
		getOut().info(this.toString());
	}
	
}