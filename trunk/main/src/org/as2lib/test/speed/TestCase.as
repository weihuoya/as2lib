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

import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.ConstructorInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.test.speed.AbstractTest;
import org.as2lib.test.speed.Test;
import org.as2lib.test.speed.SimpleTestSuiteResult;
import org.as2lib.test.speed.MethodInvocation;

/**
 * {@code TestCase} is the core interface for standardized performance test
 * cases.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.test.speed.TestCase extends AbstractTest implements Test {
	
	/** Makes the static variables of the super-class accessible through this class. */
	private static var __proto__:Function = AbstractTest;
	
	/** The previous method invocation. */
	private static var p:MethodInvocation;
	
	/** The profiled method. */
	private var method:MethodInfo;
	
	/** Scope of profiled method. */
	private var s;
	
	/** Name of profiled method. */
	private var n:String;
	
	/**
	 * @overload #TestCaseByVoid
	 * @overload #TestCaseByMethod
	 * @overload #TestCaseByObjectAndMethod
	 * @overload #TestCaseByObjectAndName
	 */
	public function TestCase() {
		var o:Overload = new Overload(this);
		o.addHandler([], TestCaseByVoid);
		o.addHandler([MethodInfo], TestCaseByMethod);
		o.addHandler([MethodInfo, Object, String], TestCaseByMethod);
		o.addHandler([Object, Function], TestCaseByObjectAndMethod);
		o.addHandler([Object, String], TestCaseByObjectAndName);
		o.forward(arguments);
	}
	
	private function TestCaseByVoid(Void):Void {
		TestCaseByObjectAndName(this, "doRun");
	}
	
	/**
	 * Constructs a new {@code TestCase} instance by method.
	 * 
	 * <p>If {@code method} is {@code null} or {@code undefined} the method named
	 * {@code "doRun"} that must be declared on this instance will be used instead if
	 * it exists.
	 * 
	 * <p>If you want to profile a method, referenced from a different scope and with a
	 * different name you can specify thse with the last two arguments. Note that if
	 * specified the method declared on the class will not be profiled.
	 * 
	 * @param method the method to profile
	 * @param referenceScope (optional) the scope of the method reference to profile
	 * @param referenceName (optional) the name of the method reference to profile
	 * @throws IllegalArgumentException if the passed-in {@code method} is {@code null}
	 * or {@code undefined} and this instance has no method named {@code "doRun"}
	 */
	private function TestCaseByMethod(method:MethodInfo, referenceScope, referenceName:String):Void {
		if (!method) {
			throw new IllegalArgumentException("Argument 'method' [" + method + "] must not be 'null' nor 'undefined' or this instance must declare a method named 'doRun'.", this, arguments);
		}
		this.method = method;
		if (referenceScope) {
			this.s = referenceScope;
		} else {
			if (method instanceof ConstructorInfo) {
				this.s = method.getDeclaringType().getPackage().getPackage();
			} else if (method.isStatic()) {
				this.s = method.getDeclaringType().getType();
			} else {
				this.s = method.getDeclaringType().getType().prototype;
			}
		}
		if (referenceName) {
			this.n = referenceName;
		} else {
			if (method instanceof ConstructorInfo) {
				this.n = method.getDeclaringType().getName();
			} else {
				this.n = method.getName();
			}
		}
		setResult(new SimpleTestSuiteResult(method.getFullName()));
	}
	
	/**
	 * Constructs a new {@code TestCase} instance by class and method.
	 * 
	 * @param clazz the class the declares the method to profile
	 * @param method the method to profile
	 */
	private function TestCaseByObjectAndMethod(object, method:Function):Void {
		if (object == null || !method) {
			throw new IllegalArgumentException("Neither argument 'object' [" + object + "] nor 'method' [" + method + "] is allowed to be 'null' or 'undefined'.");
		}
		var c:ClassInfo = ClassInfo.forObject(object);
		TestCaseByMethod(c.getMethodByMethod(method));	
	}
	
	private function TestCaseByObjectAndName(object, methodName:String):Void {
		if (!object[methodName]) {
			throw new IllegalArgumentException("Method [" + object[methodName] + "] with name '" + methodName + "' on object [" + object + "] must not be 'null' nor 'undefined'.");
		}
		if (typeof(object[methodName]) != "function") {
			throw new IllegalArgumentException("Method [" + object[methodName] + "] with name '" + methodName + "' on object [" + object + "] must be of type 'function'.");
		}
		var c:ClassInfo = ClassInfo.forObject(object);
		if (c.hasMethod(methodName)) {
			TestCaseByMethod(c.getMethodByName(methodName));
		} else {
			var m:MethodInfo = new MethodInfo(methodName, object[methodName], c, false);
			TestCaseByMethod(m, object, methodName);
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
		this.s[this.n] = createClosure();
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
			var i:MethodInvocation = t["c"]();
			i.setPreviousMethodInvocation(TestCase["p"]);
			i.setArguments(arguments);
			i.setCaller(arguments.caller.__as2lib__i);
			m.__as2lib__i = i;
			var b:Number;
			try {
				// enables proper handling of super calls and recursions inside of closured methods
				var o:Function = arguments.callee;
				var s = t["s"];
				var n:String = t["n"];
				// if the method uses recursion
				this[n] = o;
				// if there is a possibility that super might be called support it
				if (s.__proto__[n]) {
					s[n] = function() {
						t["s"].__proto__[t["n"]].apply(this, arguments);
					};
				}
				s[n].__as2lib__i = i;
				b = getTimer();
				var r = m.apply(this, arguments);
				i.setTime(getTimer() - b);
				// reset methods
				s[n] = o;
				delete this[n];
				// set time directly after invocation to reduce adulteration of the result
				i.setReturnValue(r);
				return r;
			} catch (e) {
				i.setTime(getTimer() - b);
				i.setException(e);
				throw e;
			} finally {
				t["a"](i);
				TestCase["p"] = i;
				delete m.__as2lib__i;
			}
		};
		closure.valueOf = function():Object {
			return m;
		};
		// sets class specific variables needed for closures of classes
		closure.__proto__ = m.__proto__;
		closure.prototype = m.prototype;
		closure.__constructor__ = m.__constructor__;
		closure.constructor = m.constructor;
		return closure;
	}
	
	/**
	 * Creates a new method invocation configured for this test case.
	 * 
	 * @return a new configured method invocation
	 */
	private function c(Void):MethodInvocation {
		return new MethodInvocation(this.method);
	}
	
	/**
	 * Adds a new method invocation profile result.
	 * 
	 * @return the newly added method invocation profile result
	 */
	private function a(methodInvocation:MethodInvocation):Void {
		this.result.addTestResult(methodInvocation);
	}
	
}