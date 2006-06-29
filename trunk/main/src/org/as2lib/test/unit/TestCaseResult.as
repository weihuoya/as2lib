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
import org.as2lib.data.type.Time;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestMethod;
import org.as2lib.test.unit.TestResult;
import org.as2lib.util.StringUtil;

/**
 * {@code TestCaseResult} contains information about the execution of a test case.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 * @see TestCase
 */
class org.as2lib.test.unit.TestCaseResult extends BasicClass implements TestResult {

	/** The corresponding test case */
	private var testCase:TestCase;

	/** All {@link TestCaseMethodInfo} instances of the corresponding test case. */
	private var testCaseMethods:TypedArray;

	/** Has the test runner finished execution? */
	private var finished:Boolean;

	/** Has the test runner started execution? */
	private var started:Boolean;

	/**
	 * Constructs a new {@code TestCaseResult} instance.
	 *
	 * @param testCase the test case this result corresponds to
	 */
	public function TestCaseResult(testCase:TestCase) {
		this.testCase = testCase;
		started = false;
		finished = false;
	}

	/**
	 * Returns all {@link TestCaseMethodInfo} instances of the corresponding test
	 * case.
	 *
	 * <p>Only methods with the prefix "test" are regarded as test methods.
	 *
	 * @return all {@link TestCaseMethodInfo} instances of the corresponding test
	 * case
	 */
	public function getMethodInfos(Void):TypedArray {
		if (testCaseMethods == null) {
			testCaseMethods = fetchTestCaseMethods();
		}
		return testCaseMethods;
	}

	/**
	 * Fetches all methods with the prefix "test" of the corresponding test case.
	 *
	 * @return all {@code test*} methods of the corresponding test case wrapped by
	 * {@link TestCaseMethodInfo} instances
	 */
	private function fetchTestCaseMethods(Void):TypedArray {
		var result:TypedArray = new TypedArray(TestMethod);
		var methods:Array = ClassInfo.forInstance(testCase).getMethods();
		if (methods != null) {
			for (var i:Number = methods.length - 1; i >= 0; i--) {
				var method:MethodInfo = methods[i];
				if (StringUtil.startsWith(method.getName(), "test")) {
					result.push(new TestMethod(method));
				}
			}
		}
		return result;
	}

	/**
	 * Returns the test case corresponding to this test result.
	 *
	 * @return the corresponding test case
	 */
	public function getTestCase(Void):TestCase {
		return testCase;
	}

	/**
	 * Returns the fully qualified class name of the corresponding test case.
	 *
	 * @return the fully qualified class name of the corresponding test case
	 */
	public function getName(Void):String {
		return ClassInfo.forInstance(getTestCase()).getFullName();
	}

	/**
	 * Returns an array containing only this test case result.
	 *
	 * @return an array containing only this test case result
	 */
	public function getTestResults(Void):TypedArray {
		var result:TypedArray = new TypedArray(TestResult);
		result.push(this);
		return result;
	}

	/**
	 * Returns an array containing only this test case result.
	 *
	 * @return an array containing only this test case result
	 */
	public function getTestCaseResults(Void):TypedArray {
		var result:TypedArray = new TypedArray(TestCaseResult);
		result.push(this);
		return result;
	}

	public function getPercentage(Void):Number {
		var finished:Number = 0;
		var a:Array = getMethodInfos();
		var total:Number = a.length;
		var i:Number = a.length;
		while (--i-(-1)) {
			if (a[i].hasFinished()) {
				finished++;
			}
		}
		return (100 / total * finished);
	}

	public function hasFinished(Void):Boolean {
		if (finished) {
			return true;
		}
		var methodInfos:Array = getMethodInfos();
		for (var i:Number = 0; i < methodInfos.length; i++) {
			var methodInfo:TestMethod = methodInfos[i];
			if (!methodInfo.isExecuted()) {
				return false;
			}
		}
		return (finished = true);
	}

	public function hasStarted(Void):Boolean {
		if (started) {
			return true;
		}
		var methodInfos:Array = getMethodInfos();
		for (var i:Number = 0; i < methodInfos.length; i++) {
			var methodInfo:TestMethod = methodInfos[i];
			if (methodInfo.isExecuted()) {
				return (started = true);
			}
		}
		return false;
	}

	public function getOperationTime(Void):Time {
		var result:Number = 0;
		var methodInfos:Array = getMethodInfos();
		for (var i:Number = 0; i < methodInfos.length; i++) {
			var methodInfo:TestMethod = methodInfos[i];
			result += methodInfo.getStopWatch().getTimeInMilliSeconds();
		}
		return new Time(result);
	}

	public function hasErrors(Void):Boolean {
		var methodInfos:Array = getMethodInfos();
		for (var i:Number = 0; i < methodInfos.length; i++) {
			var methodInfo:TestMethod = methodInfos[i];
			if (methodInfo.hasErrors()) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Returns the string representation of this test case result. It is properly
	 * formatted and may be used to show the test result in text based consoles.
	 *
	 * @return the string representation of this test case result
	 */
	public function toString():String {
		var result:String;
		var methodResult:String = "";
		var ms:Number = 0;
		var errors:Number = 0;
		var methodInfos:Array = getMethodInfos();
		for (var i:Number = 0; i < methodInfos.length; i++) {
			var method:TestMethod = methodInfos[i];
			ms += method.getStopWatch().getTimeInMilliSeconds();
			if(method.hasErrors()) {
				errors += method.getErrors().length;
				methodResult += "\n" + StringUtil.addSpaceIndent(method.toString(), 2);
			}
		}
		result = getName() + " ran " + methodInfos.length + " methods in [" + ms + "ms]: ";
		result += (errors>0) ? errors + ((errors > 1) ? " errors" : " error") +
				" occurred" + methodResult : "no error occurred";
		return result;
	}

}