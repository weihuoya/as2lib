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
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.test.speed.TestResult;
import org.as2lib.test.speed.TestCase;
import org.as2lib.test.speed.MethodInvocation;

/**
 * {@code TestCaseResult} holds the result of a test case's execution.
 * 
 * @author Simon Wacker */
class org.as2lib.test.speed.TestCaseResult extends BasicClass implements TestResult {
	
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
	 * Returns the method scope of the profiled method.
	 * 
	 * @return the scope of the profiled method
	 */
	public function getMethodScope(Void) {
		return this.testCase.getMethodScope();
	}
	
	/**
	 * Returns the name of the profiled method.
	 * 
	 * @return the name of the profiled method
	 */
	public function getMethodName(Void):String {
		return this.testCase.getMethodName();
	}
	
	/**
	 * Returns the name of the test case.
	 * 
	 * @return the name of the test case	 */
	public function getName(Void):String {
		var info:Array;
		var methodScope = getMethodScope();
		var method:Function = methodScope[getMethodName()];
		if (typeof(methodScope) == "function") {
			info = ReflectUtil.getTypeAndMethodInfoByType(methodScope, method);
		} else {
			info = ReflectUtil.getTypeAndMethodInfoByPrototype(methodScope, method);
			if (info[1] == null) {
				info = ReflectUtil.getTypeAndMethodInfoByInstance(methodScope, method);
			}
		}
		return ((info[0] ? "static " : "") + info[1] + "." + info[2]);
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
	 * Returns whether this result has any method invocations.
	 * 
	 * @return {@code true} if this result has method invocations else {@code false}
	 */
	public function hasMethodInvocations(Void):Boolean {
		return (this.methodInvocations.length > 0);
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
	 * @return the string representation of this test case result	 */
	public function toString():String {
		var result:String = "";
		var totalTime:Number = getTime();
		for (var i:Number = 0; i < this.methodInvocations.length; i++) {
			var mi:MethodInvocation = this.methodInvocations[i];
			if (i > 0) {
				result += "\n";
			}
			if (totalTime == 0) {
				result += "100.00 % - ";
			} else {
				result += Math.round((mi.getTime() / totalTime) * 100).toString() + " % - ";
			}
			result += mi.getTime() + " ms - ";
			result += getName();
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
	
}