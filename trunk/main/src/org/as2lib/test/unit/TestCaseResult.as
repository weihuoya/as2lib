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
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.data.holder.Iterator;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestCaseMethodInfo;
import org.as2lib.test.unit.TestConfig;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.StringUtil;

/**
 * Wrapper for a TestCase that contains a API to all Informations to the execution of the Testcase.
 * 
 * @author Martin Heidegger.
 */
class org.as2lib.test.unit.TestCaseResult extends BasicClass implements TestResult {
	
	/** Holder for the internal testcase. */
	private var testCase:TestCase;
	
	/** Holder for the runner of the testcase. */
	private var testRunner:TestRunner;
	
	/** Internal list of all Methods contained in the Testcase. */
	private var testCaseMethodInfos:TypedArray;
	
	/** Flag if the TestCase has been finished. */
	private var finished:Boolean;
	
	/** Flag if the TestCase has been started. */
	private var started:Boolean;
	
	/**
	 * Constructs a new TestCaseResult.
	 * 
	 * @param testCase TestCase to wrap.
	 * @param testRunner TestRunner that initialized the TestCaseResult.
	 */
	public function TestCaseResult(testCase:TestCase, testRunner:TestRunner) {
		this.testRunner = testRunner;
		this.testCase = testCase;
		this.started = false;
		this.finished = false;
	}
	
	/**
	 * Getter for all Informations about the methods contained within the TestCase.
	 * Test method get recognized by the pattern: "test*"
	 * 
	 * @return List of all methods contained within this TestCase.
	 */
	public function getMethodInfos(Void):TypedArray {
		// Lacy Initialisation for load balancing. All Methods get evaluated by starting this TestCaseResult
		// But not by starting all Available TestCaseResult, as it wood if this would be directly inside the
		// Constructor.
		if(!testCaseMethodInfos){
			testCaseMethodInfos = fetchTestCaseMethodInfos();
		}
		return testCaseMethodInfos;
	}
	
	/**
	 * Fetches all methods starting with "test" within the testcase.
	 * 
	 * @return List containing all methodinformations.
	 */
	private function fetchTestCaseMethodInfos(Void):TypedArray {
		var result:TypedArray = new TypedArray(TestCaseMethodInfo);
		var methods:Array = ReflectUtil.getClassInfo(testCase).getMethods();
		for (var i:Number = methods.length-1; i >= 0; i--) {
			var method:MethodInfo = methods[i];
			if (StringUtil.startsWith(method.getName(), 'test')) {
				result.push(new TestCaseMethodInfo(method, getTestRunner()));
			}
		}
		return result;
	}
	
	/**
	 * Getter for the Testrunner that executed the TestCase.
	 * 
	 * @return Testrunner that executed the TestCase.
	 */
	public function getTestRunner(Void):TestRunner {
		return testRunner;
	}
	
	/**
	 * Getter for the wrapped TestCase.
	 * 
	 * @return Wrapped TestCase.
	 */
	public function getTestCase(Void):TestCase {
		return testCase;
	}
	
	/**
	 * Getter for the name of the TestCase.
	 * 
	 * @return name of the TestCase.
	 */
	public function getName(Void):String {
		return ReflectUtil.getClassInfo(getTestCase()).getFullName();
	}
	
	/**
	 * Implementation of @see TestResult#getTestResults.
	 * 
	 * @return This TestCaseResult in a new list for Results.
	 */
	public function getTestResults(Void):TypedArray {
		var result = new TypedArray(TestResult);
		result.push(this);
		return result;
	}
	
	/**
	 * Getter for the total percentage of the execution.
	 * 
	 * @return Percentage of execution.
	 */
	public function getPercentage(Void):Number {
		var finished:Number = 0;
		
		var a:Array = getMethodInfos();
		var total:Number = a.length;
		var i:Number = a.length;
		
		while(--i-(-1)) {
			if(a[i].isFinished()) {
				finished ++;
			}
		}
		
		return (100/total*finished);
	}
	
	/**
	 * @return true if the TestCase has been finished.
	 */
	public function isFinished(Void):Boolean {
		if(finished) return true; // Caching of a true result as performance enhancement.
		var methodIterator:Iterator = new ArrayIterator(getMethodInfos());
		while(methodIterator.hasNext()) {
			if(!methodIterator.next().isFinished()) {
				return false;
			}
		}
		return (finished=true);
	}
	
	/**
	 * @return true if the TestCase has been started.
	 */
	public function isStarted(Void):Boolean {
		if(started) return true; // Caching of a true result as performance enhancement.
		var methodIterator:Iterator = new ArrayIterator(getMethodInfos());
		while(methodIterator.hasNext()) {
			if(methodIterator.next().isFinished()) {
				return (started=true);
			}
		}
		return false;
	}
	
	/**
	 * Getter for the total operation time.
	 * 
	 * @return Total operation time in milliseconds.
	 */
	public function getOperationTime(Void):Number {
		var result:Number = 0;
		var methodIterator:Iterator = new ArrayIterator(getMethodInfos());
		while(methodIterator.hasNext()) {
			result += methodIterator.next().getStopWatch().getTimeInMilliSeconds();
		}
		return result;
	}
	
	/**
	 * @return True if the Testcase has errors.
	 */
	public function hasErrors(Void):Boolean {
		var methodIterator:Iterator = new ArrayIterator(getMethodInfos());
		while(methodIterator.hasNext()) {
			if(methodIterator.next().hasErrors()) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Getter for all TestCase results.
	 * Implementation of @see TestResult#getTestCaseResults.
	 * 
	 * @return The Testcase in a list of TestCaseResults.
	 */
	public function getTestCaseResults(Void):TypedArray {
		var result:TypedArray = new TypedArray(TestCaseResult);
		result.push(this);
		return result;
	}
	
	/**
	 * Extended .toString implementation.
	 * 
	 * @return TestCaseResult as well formated String.
	 */
	public function toString(Void):String {
		var result:String;
		var methodResult:String="";
		var ms:Number=0;
		var errors:Number=0;
		
		var iter:Iterator=new ArrayIterator(getMethodInfos());
		while(iter.hasNext()) {
			var method:TestCaseMethodInfo = TestCaseMethodInfo(iter.next());
			ms += method.getStopWatch().getTimeInMilliSeconds();
			if(method.hasErrors()) {
				errors += method.getErrors().length;
				methodResult += "\n"+StringUtil.addSpaceIndent(method.toString(), 3);
			}
		}
		
		var result = getName()+" run in ["+ms+"ms]. ";
		
		result += (errors>0) ? errors + ((errors > 1) ? " errors" : " error") + " occured" + methodResult : "no error occured";
		
		return result;
	}
	
	/**
	 * Prints the TestCaseResult to a standard Outputdevice.
	 * It is possible to change the output device by @see TestConfig#setOut.
	 */
	public function print(Void):Void {
		TestConfig.getOut().info(toString());
	}
}