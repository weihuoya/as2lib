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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.test.speed.TestResultLayout;
import org.as2lib.test.speed.TestSuiteResult;
import org.as2lib.test.speed.MethodInvocation;
import org.as2lib.test.speed.MethodInvocationTestSuiteResult;
import org.as2lib.test.speed.ConfigurableTestSuiteResult;
import org.as2lib.test.speed.SimpleTestSuiteResult;

/**
 * @author Simon Wacker */
class org.as2lib.test.speed.layout.MethodInvocationTreeLayout extends BasicClass implements TestResultLayout {
	
	/** */
	private var allMethodInvocations:Array;
	
	/**
	 * Constructs a new {@code MethodInvocationTreeLayout} instance.	 */
	public function MethodInvocationTreeLayout(Void) {
	}
	
	/**
	 * Lays the passed-in {@code testResult} out and returns a new lay-outed test
	 * result.
	 * 
	 * @param testResult the test result to lay-out
	 * @return the lay-outed test result
	 */
	public function layOut(testSuiteResult:TestSuiteResult):TestSuiteResult {
		if (!testSuiteResult) throw new IllegalArgumentException("Argument 'testSuiteResult' [" + testSuiteResult + "] must not be 'null' nor 'undefined'.", this, arguments);
		var result:SimpleTestSuiteResult = new SimpleTestSuiteResult(testSuiteResult.getName());
		this.allMethodInvocations = testSuiteResult.getAllMethodInvocations();
		if (this.allMethodInvocations) {
			var rootMethodInvocations:Array = findRootMethodInvocations();
			buildMethodInvocationTree(result, rootMethodInvocations);
		}
		result.sort(SimpleTestSuiteResult.METHOD_INVOCATION_SUCCESSION);
		return result;
	}
	
	private function findRootMethodInvocations(Void):Array {
		return findChildMethodInvocations(null);
	}
	
	private function findChildMethodInvocations(parentMethodInvocation:MethodInvocation):Array {
		var result:Array = new Array();
		for (var i:Number = 0; i < this.allMethodInvocations.length; i++) {
			var methodInvocation:MethodInvocation = this.allMethodInvocations[i];
			if (methodInvocation.getCaller() == parentMethodInvocation) {
				result.push(methodInvocation);
			}
		}
		return result;
	}
	
	private function buildMethodInvocationTree(testSuiteResult:ConfigurableTestSuiteResult, parentMethodInvocations:Array):Void {
		if (testSuiteResult && parentMethodInvocations) {
			for (var i:Number = 0; i < parentMethodInvocations.length; i++) {
				var parentMethodInvocation:MethodInvocation = parentMethodInvocations[i];
				var p:MethodInvocationTestSuiteResult = new MethodInvocationTestSuiteResult(parentMethodInvocation);
				testSuiteResult.addTestResult(p);
				var childMethodInvocations:Array = findChildMethodInvocations(parentMethodInvocation);
				buildMethodInvocationTree(p, childMethodInvocations);
			}
		}
	}
	
}