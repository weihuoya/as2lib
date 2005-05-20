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
import org.as2lib.test.speed.Test;
import org.as2lib.test.speed.TestResult;
import org.as2lib.test.speed.TestCaseResult;
import org.as2lib.test.speed.MethodInvocation;

/**
 * {@code TestCase} is the core interface for standardized performance test
 * cases.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.test.speed.TestCase extends BasicClass implements Test {
	
	/** Scope of method to profile. */
	private var methodScope;
	
	/** Name of method to profile. */
	private var methodName:String;
	
	/** Result of this test cases' up to now performed speed tests. */
	private var result:TestCaseResult;
	
	/**
	 * Constructs a new {@code TestCase} instance.
	 * 
	 * <p>If {@code methodScope} is {@code null} or {@code undefined} it will be set to
	 * {@code this}. If {@code methodName} is {@code null} or {@code undefined} it will
	 * be set to {@code "doRun"}. This means you can extend this class without passing
	 * arguments to the super-constructor, but with implementing a {@code doRun}
	 * method.
	 * 
	 * @param methodScope (optional) the scope of the method to profile
	 * @param methodName (optional) the name of the method to profile
	 */
	public function TestCase(methodScope, methodName:String) {
		if (methodScope === null || methodScope === undefined) methodScope = this;
		if (methodName == null) methodName = "doRun";
		if (typeof(methodScope[methodName]) != "function") {
			throw new IllegalArgumentException("Method '" + ReflectUtil.getTypeName(methodScope) + "." + methodName + "' [" + methodScope[methodName] + "] must not be 'null' nor 'undefined' nor not of type 'function'.", this, arguments);
		}
		this.methodScope = methodScope;
		this.methodName = methodName;
		this.result = new TestCaseResult(this);
	}
	
	/**
	 * Returns the method scope of the profiled method.
	 * 
	 * @return the scope of the profiled method
	 */
	public function getMethodScope(Void) {
		return this.methodScope;
	}
	
	/**
	 * Returns the name of the profiled method.
	 * 
	 * @return the name of the profiled method
	 */
	public function getMethodName(Void):String {
		return this.methodName;
	}
	
	/**
	 * Runs this performance test case.
	 */
	public function run(Void):Void {
		methodScope[methodName] = createClosure();
	}
	
	/**
	 * Creates a closure, that is a wrapper method, for the method to profile.
	 * 
	 * @return the created closure
	 */
	private function createClosure(Void):Function {
		var t:TestCase = this;
		var s = this.methodScope;
		var n:String = this.methodName;
		var m:Function = this.methodScope[methodName];
		var closure:Function = function() {
			var b:Number = getTimer();
			try {
				var r = m.apply(this, arguments);
				t["addReturnResult"](getTimer() - b, arguments, r);
				return r;
			} catch (e) {
				t["addExceptionResult"](getTimer() - b, arguments, e);
				throw e;
			}
		};
		// sets class specific variables needed for closures of classes
		closure.__proto__ = m.__proto__;
		closure.prototype = m.prototype;
		closure.__constructor__ = m.__constructor__;
		closure.constructor = m.constructor;
		return closure;
	}
	
	/**
	 * Adds a new profile result that resulted in a proper return value.
	 * 
	 * @param time the time needed to execute the profiled method
	 * @param args the arguments used for the method execution
	 * @param returnValue the value the executed method returned
	 */
	private function addReturnResult(time:Number, args:Array, returnValue):Void {
		var mi:MethodInvocation = new MethodInvocation(time, args);
		mi.setReturnValue(returnValue);
		this.result.addResult(mi);
	}
	
	/**
	 * Adds a new profile result that resulted in an exception.
	 * 
	 * @param time the time needed to execute the profiled method
	 * @param args the arguments used for the method execution
	 * @param exception the exception the executed method threw
	 */
	private function addExceptionResult(time:Number, args:Array, exception):Void {
		var mi:MethodInvocation = new MethodInvocation(time, args);
		mi.setException(exception);
		this.result.addResult(mi);
	}
	
	/**
	 * Returns the test result of this test case.
	 * 
	 * <p>Note that if this test case is currently running, the returned result is only
	 * a snapshot.
	 * 
	 * @return this test case's result
	 */
	public function getResult(Void):TestResult {
		return this.result;
	}
	
}