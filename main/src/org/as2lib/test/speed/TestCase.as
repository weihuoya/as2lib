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
import org.as2lib.env.overload.Overload;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.ClassInfo;
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
	
	/** The profiled method. */
	private var method:MethodInfo;
	
	/** Result of this test cases' up to now performed speed tests. */
	private var result:TestCaseResult;
	
	/**
	 * @overload #TestCaseByMethod
	 * @overload #TestCaseByClassAndMethod
	 * @overload #TestCaseByInstanceAndMethod
	 */
	public function TestCase() {
		var o:Overload = new Overload(this);
		o.addHandler([MethodInfo], TestCaseByMethod);
		o.addHandler([Function, Function], TestCaseByClassAndMethod);
		o.addHandler([Object, Function], TestCaseByInstanceAndMethod);
		o.forward(arguments);
	}
	
	/**
	 * Constructs a new {@code TestCase} instance by method.
	 * 
	 * <p>If {@code method} is {@code null} or {@code undefined} the method named
	 * {@code "doRun"} that must be declared on this instance will be used instead if
	 * it exists.
	 * 
	 * @param method the method to profile
	 * @throws IllegalArgumentException if the passed-in {@code method} is {@code null}
	 * or {@code undefined} and this instance has not method named {@code "doRun"}
	 */
	private function TestCaseByMethod(method:MethodInfo):Void {
		if (!method) method = ClassInfo.forInstance(this).getMethodByName("doRun");
		if (!method) {
			throw new IllegalArgumentException("Argument 'method' [" + method + "] must not be 'null' nor 'undefined' or this instance must declare a method named 'doRun'.", this, arguments);
		}
		this.method = method;
		this.result = new TestCaseResult(this);
	}
	
	/**
	 * Constructs a new {@code TestCase} instance by class and method.
	 * 
	 * <p>If {@code clazz} is {@code null} or {@code undefined} the class of this
	 * instance will be used instead. If {@code method} is {@code null} or
	 * {@code undefined} a method named {@code "doRun"} that must be declared on the
	 * class is used instead if it exists.
	 * 
	 * @param clazz the class the declares the method to profile
	 * @param method the method to profile
	 */
	private function TestCaseByClassAndMethod(clazz:Function, method:Function):Void {
		var c:ClassInfo;
		if (clazz) {
			c = ClassInfo.forClass(clazz);
		} else {
			c = ClassInfo.forInstance(this);
		}
		if (method) {
			TestCaseByMethod(c.getMethodByMethod(method));	
		} else {
			TestCaseByMethod(c.getMethodByName("doRun"));
		}
	}
	
	/**
	 * Constructs a new {@code TestCase} instance by instance and method.
	 * 
	 * <p>If {@code instance} is {@code null} or {@code undefined}, {@code this} will
	 * be used instead. If {@code method} is {@code null} or {@code undefined} a method
	 * named {@code "doRun"} that must be declared by the instance's class is used
	 * instead.
	 * 
	 * @param instance the instance whose class declares the method to profile
	 * @param method the method to profile
	 */
	private function TestCaseByInstanceAndMethod(instance, method:Function):Void {
		if (instance == null) instance = this;
		var c:ClassInfo = ClassInfo.forInstance(instance);
		if (method) {
			TestCaseByMethod(c.getMethodByMethod(method));
		} else {
			TestCaseByMethod(c.getMethodByName("doRun"));
		}
	}
	
	/**
	 * Returns the profiled method.
	 * 
	 * @return the profiled method
	 */
	public function getMethod(Void):MethodInfo {
		return this.method;
	}
	
	/**
	 * Runs this performance test case.
	 */
	public function run(Void):Void {
		if (this.method.isStatic()) {
			this.method.getDeclaringType().getType()[this.method.getName()] = createClosure();
		} else {
			this.method.getDeclaringType().getType().prototype[this.method.getName()] = createClosure();
		}
	}
	
	/**
	 * Creates a closure, that is a wrapper method, for the method to profile.
	 * 
	 * @return the created closure
	 */
	private function createClosure(Void):Function {
		var t:TestCase = this;
		var m:Function = this.method.getMethod();
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
		var mi:MethodInvocation = new MethodInvocation(time, args, this.method);
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
		var mi:MethodInvocation = new MethodInvocation(time, args, this.method);
		mi.setException(exception);
		this.result.addResult(mi);
	}
	
	/**
	 * Returns the test result of this test case.
	 * 
	 * @return this test case's result
	 */
	public function getResult(Void):TestResult {
		return this.result;
	}
	
}