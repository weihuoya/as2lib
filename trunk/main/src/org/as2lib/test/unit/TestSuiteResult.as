/**
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.util.StringUtil;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestSuite;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * Wrapper for a TestSuite with extended Informations about the run of the TestSuite.
 * 
 * @see org.as2lib.test.unit.TestSuite
 * @autor Martin Heidegger
 */
class org.as2lib.test.unit.TestSuiteResult extends BasicClass implements TestResult {

	/** TestSuite that gets wrapped. */
	private var testSuite:TestSuite;
	
	/** TestResults related to the tests. */
	private var testResults:TypedArray;

	/**
	 * Constructs a new TestSuiteResult.
	 * 
	 * @param testSuite TestSuite to be wrapped
	 * @param testRunner TestRunner that created this Result.
	 */
	public function TestSuiteResult(testSuite:TestSuite, testRunner:TestRunner) {
		this.testSuite = testSuite;
		testResults = new TypedArray(TestResult);
		
		var tests:Array = testSuite.getTests();
		var i:Number = tests.length;
		while(--i-(-1)) {
			if(tests[i] instanceof TestCase) {
				testResults.unshift(new TestCaseResult(tests[i], testRunner));
			} else if(tests[i] instanceof TestSuite) {
				testResults.unshift(new TestSuiteResult(tests[i], testRunner));
			} else {
				throw new IllegalArgumentException("Type " + ClassInfo.forInstance(tests[i]).getFullName()+" not supported!", this, arguments);
			}
		}
	}
	
	/**
	 * Getter for all Test(Results) contained in the TestSuite
	 * 
	 * @return List of all TestResults.
	 */
	public function getTests(Void):TypedArray {
		return this.testResults;
	}
	
	/**
	 * Getter for the Percentage of the execution.
	 * 
	 * @return Percentage of execution.
	 */
	public function getPercentage(Void):Number {
		var result:Number = 0;
		var unit:Number = 100/this.testResults.length;
		for(var i=this.testResults.length-1; i>=0; i--) {
			result += (unit/100*this.testResults[i].getPercentage());
		}
		return result;
	}
	
	/**
	 * @return True if the TestSuite is finished.
	 */
	public function hasFinished(Void):Boolean {
		for(var i=this.testResults.length-1; i>=0; i--) {
			if(!this.testResults[i].isFinished()) {
				return false;
			}
		}
		return true;
	}
	
	/**
	 * @return True if the TestSuite is started.
	 */
	public function hasStarted(Void):Boolean {
		for(var i=this.testResults.length-1; i>=0; i--) {
			if(this.testResults[i].hasStarted()) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Getter for all TestCaseResults (flatten) contained in the TestSuite.
	 * Returns flatten all TestCaseResults.
	 * 
	 * @return TestCaseResults containted in the TestSuite and all SubSuites.
	 */
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
	
	/**
	 * Getter for all TestResults (flatten) contained in the TestSuite.
	 * Returns flatten all TestResults.
	 * 
	 * @return TestResults containted in the TestSuite and all SubSuites.
	 */
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
	
	/**
	 * Getter for the Name of the TestSuite.
	 * 
	 * @return Name of the TestSuite.
	 */
	public function getName(Void):String {
		return this.getTestSuite().getName();
	}
	
	/**
	 * Getter for the total Operation time of the TestSuite.
	 * 
	 * @return Operation Time of the TestSuite in milliseconds..
	 */
	public function getOperationTime(Void):Number {
		var result:Number = 0;
		for(var i=this.testResults.length-1; i>=0; i--) {
			result += this.testResults[i].getOperationTime();
		}
		return result;
	}
	
	/**
	 * @return True if the TestSuite contains errors.
	 */
	public function hasErrors(Void):Boolean {
		for(var i=this.testResults.length-1; i>=0; i--) {
			if(this.testResults[i].hasErrors()) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Getter for the wrapped TestSuite.
	 * 
	 * @return wrapped TestSuite.
	 */
	public function getTestSuite(Void):TestSuite {
		return this.testSuite;
	}


	/**
	 * Extended .toString implementation.
	 * 
	 * @return TestSuiteResult as well formated String.
	 */
	public function toString(Void):String {
		var result:String;
		var titleLength:Number;
		result = "*** TestSuite "+getName()+" ("+testResults.length+" Tests) ["+getOperationTime()+"ms] ***";
		titleLength = result.length;
		for(var i=0; i<testResults.length; i++){
			result += "\n"+StringUtil.addSpaceIndent(this.testResults[i].toString(), 2);
		}
		result += "\n"+StringUtil.multiply("*", titleLength);
		return result;
	}
	
}