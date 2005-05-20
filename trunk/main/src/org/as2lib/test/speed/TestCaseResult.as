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

import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.test.speed.TestResult;
import org.as2lib.test.speed.AbstractTestResult;
import org.as2lib.test.speed.TestCase;
import org.as2lib.test.speed.MethodInvocation;

/**
 * {@code TestCaseResult} holds the result of a test case's execution.
 * 
 * @author Simon Wacker */
class org.as2lib.test.speed.TestCaseResult extends AbstractTestResult implements TestResult {
	
	/** Wrapped test case this is the result of. */
	private var testCase:TestCase;
	
	/** Method invocations. */
	private var methodInvocations:Array;
	
	/**
	 * Constructs a new {@code TestCaseResult} instance.
	 * 
	 * @param testCase the test case this is the result of	 */
	public function TestCaseResult(testCase:TestCase) {
		if (!testCase) throw new IllegalArgumentException("Argument 'testCase' [" + testCase + "] must not be 'null' nor 'undefined'.", this, arguments);
		this.testCase = testCase;
		this.methodInvocations = new Array();
	}
	
	/**
	 * Returns the profiled method.
	 * 
	 * @return the profiled method
	 */
	public function getMethod(Void):MethodInfo {
		return this.testCase.getMethod();
	}
	
	/**
	 * Returns the name of the test case.
	 * 
	 * @return the name of the test case	 */
	public function getName(Void):String {
		return getMethod().toString();
	}
	
	/**
	 * Returns the total invocation time in milliseconds.
	 * 
	 * @return the total invocation time in milliseconds
	 */
	public function getTime(Void):Number {
		var result:Number = 0;
		for (var i:Number = 0; i < this.methodInvocations.length; i++) {
			var mi:MethodInvocation = this.methodInvocations[i];
			result += mi.getTime();
		}
		return result;
	}
	
	/**
	 * Returns all profiled method invocations as {@link MethodInvocation} instances.
	 * 
	 * @return all profiled method invocations as {@code MethodInvocation} instances	 */
	public function getMethodInvocations(Void):Array {
		return this.methodInvocations.concat();
	}
	
	/**
	 * Adds a profiled method invocation.
	 * 
	 * @param methodInvocation the profiled method invocation	 */
	public function addResult(methodInvocation:MethodInvocation):Void {
		this.methodInvocations.push(methodInvocation);
	}
	
	/**
	 * Returns the string representation of this test case result.
	 * 
	 * @param rootTestResult test result that holds the total values needed for
	 * percentage calculations
	 * @return the string representation of this test case result	 */
	public function toString():String {
		var rootTestResult:TestResult = arguments[0];
		if (!rootTestResult) rootTestResult = this;
		var result:String = getTimePercentage(rootTestResult.getTime()) + "%";
		result += ", " + getTime() + " ms";
		result += " - " + getMethodInvocationPercentage(rootTestResult.getMethodInvocationCount()) + "%";
		result += ", " + getMethodInvocationCount() + " inv.";
		result += " - " + getAverageTime() + " ms/inv.";
		result += " - " + getName();
		if (getMethodInvocationCount() > 1) {
			for (var i:Number = 0; i < this.methodInvocations.length; i++) {
				var mi:MethodInvocation = this.methodInvocations[i];
				result += "\n  ";
				result += getPercentage(mi.getTime(), rootTestResult.getTime()) + "%";
				result += ", " + mi.getTime() + " ms";
				// source into MethodInvocation
				result += " - " + getName() + "(" + mi.getArguments() + ")";
				if (mi.wasSuccessful()) {
					if (mi.getReturnValue() !== undefined) {
						result += " returned " + mi.getReturnValue();
					}
				} else {
					result += " threw " + ReflectUtil.getTypeName(mi.getException());
				}
			}
		} else {
			var mi:MethodInvocation = this.methodInvocations[0];
			result += "(" + mi.getArguments() + ")";
			if (mi.wasSuccessful()) {
				if (mi.getReturnValue() !== undefined) {
					result += " returned " + mi.getReturnValue();
				}
			} else {
				result += " threw " + ReflectUtil.getTypeName(mi.getException());
			}
		}
		return result;
	}
	
	// source into MethodInvocation
	private function getPercentage(partTime:Number, totalTime:Number):Number {
		return Math.round((partTime / totalTime) * 10000)/100;
	}
	
}