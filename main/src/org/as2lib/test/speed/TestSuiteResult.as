/*
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
import org.as2lib.util.StringUtil;
import org.as2lib.test.speed.TestResult;
import org.as2lib.test.speed.TestSuite;
import org.as2lib.test.speed.Test;

/**
 * {@code TestSuiteResult} holds the result of all tests contained by a test suite.
 * 
 * @author Simon Wacker */
class org.as2lib.test.speed.TestSuiteResult extends BasicClass implements TestResult {
	
	/** Wrapped test suite this instance is the result of. */
	private var testSuite:TestSuite;
	
	/**
	 * Constructs a new {@code TestSuiteResult} instance.
	 * 
	 * @param testSuite the test suite this instance is the result of	 */
	public function TestSuiteResult(testSuite:TestSuite) {
		this.testSuite = testSuite;
	}
	
	/**
	 * Returns the name of the wrapped test suite.
	 * 
	 * @return the name of the wrapped test suite	 */
	public function getName(Void):String {
		return this.testSuite.getName();
	}
	
	/**
	 * Returns the total invocation time in milliseconds.
	 * 
	 * @return the total invocation time in milliseconds
	 */
	public function getTime(Void):Number {
		var result:Number = 0;
		var tests:Array = testSuite.getAllTests();
		for (var i:Number = 0; i < tests.length; i++) {
			var test:Test = tests[i];
			result += test.getResult().getTime();
		}
		return result;
	}
	
	/**
	 * Returns all profiled method invocations as {@link MethodInvocation} instances.
	 * 
	 * @return all profiled method invocations as {@code MethodInvocation} instances	 */
	public function getMethodInvocations(Void):Array {
		var result:Array = new Array();
		var tests:Array = this.testSuite.getAllTests();
		for (var i:Number = 0; i < tests.length; i++) {
			var test:Test = tests[i];
			result = result.concat(test.getResult().getMethodInvocations());
		}
		return result;
	}
	
	/**
	 * Returns whether this result has any method invocations.
	 * 
	 * @return {@code true} if this result has method invocations else {@code false}
	 */
	public function hasMethodInvocations(Void):Boolean {
		return (getMethodInvocations().length > 0);
	}
	
	/**
	 * Returns all test results of all sub-tests. These include test results from test
	 * suites and test cases. The test reults are instances of type {@link TestResult}.
	 * 
	 * @return all test results of all sub-tests	 */
	public function getTestResults(Void):Array {
		var result:Array = new Array();
		var tests:Array = this.testSuite.getAllTests();
		for (var i:Number = 0; i < tests.length; i++) {
			result.push(Test(tests[i]).getResult());
		}
		return result;
	}
	
	/**
	 * Returns the string representation of this test suite result. This includes the
	 * string representation of all tests added to the wrapped test suite.
	 * 
	 * @return the string representation of this test suite result	 */
	public function toString():String {
		var result:String = getName();
		var tests:Array = testSuite.getAllTests();
		if (tests.length == 0) {
			result += "\n  No tests.";
		} else {
			var totalTime:Number = getTime();
			for (var i:Number = 0; i < tests.length; i++) {
				var testResult:TestResult = Test(tests[i]).getResult();
				if (testResult.hasMethodInvocations()) {
					result += "\n";
					result += StringUtil.addSpaceIndent(((Math.round((testResult.getTime() / totalTime) * 10000))/100).toString() + " % - " + testResult.toString(), 2);
				}
			}
		}
		return result;
	}
	
}