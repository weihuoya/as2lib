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

import org.as2lib.test.unit.TestCase;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.reflect.ClassInfo;
import test.unit.org.as2lib.env.except.SimpleTestClass;

/**
 * Implementation test for the SimpleStackElement
 *
 * @author Jayaprakash A
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.env.except.AbstractTStackTraceElement extends TestCase {
	
	private var method:Function;
	private var args:Array;
	private var thrower:Object;
	private var callee:Function;
	private var caller:Function;
	
	/**
	 * Flag to block collecting by the TestSuiteFactory of this Abstract class.
	 */
	public static function blockCollecting (Void):Boolean {
		return true;
	}
	
	/**
	 * Template Method to get the specific StackTraceElement implementation.
	 */
	public function getStackTraceElement (thrower:Object, method:Function, args:Array):StackTraceElement {
		return null;
	}
	
	/**
	 * Method to set up the StackTraceElement before running a test.
	 * This method will get called before executing each test
	 */
	public function setUp (Void):Void{
		thrower = new SimpleTestClass();
		args = thrower.normalMethod("param1", "param2");
		method = thrower.normalMethod;
		method = function(){};
		callee = args.callee;
		caller = args.caller;
	}
	
	/**
	 * Method to destroy the StackTraceElement after running a test.
	 * This method will get called after executing each test
	 */
	public function tearDown (Void):Void{
		method = null;
		callee = null;
		caller = null;
		args = null;
		thrower = null;
	}
	
	/**
	 * Test if the thrower is returned properly
	 */
	public function testGetThrower (){
		var stackTraceElement:StackTraceElement;
		
		// Validates that the thrower passed in was properly returned - This is the usual case
		assertEquals ("stackTraceElement.getThrower() should return thrower Object", getStackTraceElement (thrower, method, args).getThrower(), ClassInfo.forObject(thrower));
		
		// Validates that the thrower passed in as null was properly returned as null
		assertNull ("stackTraceElement.getThrower() should return null if it was applied as null", getStackTraceElement (null, method, args).getThrower());
		
		// Validates that the thrower passed in as undefined was properly returned
		assertNull ("stackTraceElement.getThrower() should return null if it was applied as undefined", getStackTraceElement (undefined, method, args).getThrower());
		
		// Validates that the thrower passed in was properly returned if no method was applied
		assertEquals ("stackTraceElement.getThrower() should return thrower Object if no method was applied", getStackTraceElement (thrower, null, args).getThrower(), ClassInfo.forObject(thrower));
		
		// Validates that the thrower passed in was properly returned if no arguments was applied
		assertEquals ("stackTraceElement.getThrower() should return thrower Object if no arguments were applied", getStackTraceElement (thrower, method, null).getThrower(), ClassInfo.forObject(thrower));
		
		// Validates that the thrower passed in was properly returned if both (method and arguments) were applied
		assertEquals ("stackTraceElement.getThrower() should return thrower Object if both were not applied", getStackTraceElement (thrower, method, args).getThrower(), ClassInfo.forObject(thrower));
	}
	
	/**
	 * Test if the method name is returned properly in usual and unusual cases
	 */
	public function testGetMethod (){
		// Placeholder
		var stackTraceElement:StackTraceElement;
		
		// Validates that a public method called was properly returned - This is the usual case
		stackTraceElement = getStackTraceElement (thrower, thrower.normalMethod, args);
		assertSame ("stackTraceElement.getMethod() should return same method", stackTraceElement.getMethod().getMethod(), thrower.normalMethod);
		assertFalse ("stackTraceElement.getMethod should not contain the static flag, because its not a static method", stackTraceElement.getMethod().isStatic());
		
		// Validates that a static method called was properly returned
		stackTraceElement = getStackTraceElement (thrower, SimpleTestClass.staticMethod, args);
		assertEquals ("stackTraceElement.getMethod() should return same, static method", stackTraceElement.getMethod().getMethod(), SimpleTestClass.staticMethod);
		assertTrue ("stackTraceElement.getMethod() should contain the static flag if its a static method", stackTraceElement.getMethod().isStatic());
		
		// Validates that the method will not be returned properly if its not a part of the class
		assertNull ("stackTraceElement.getMethod() should return null if the method is not part of the class", getStackTraceElement(thrower, testGetMethod, args).getMethod());
		
		// Validates that if no method will be used, undefined will be returned
		assertNull ("stackTraceElement.getMethod() should return null if the method is undefined", getStackTraceElement (thrower, undefined, args).getMethod());
		
		// Validates that if no method will be used, undefined will be returned
		assertNull ("stackTraceElement.getMethod() should return null if the method is null", getStackTraceElement (thrower, null, args).getMethod());
		
		// Validates that if thrower is null, the algorythm for getMethod returns null. The StackTraceElement needs the Thrower to return a proper MethodInfo
		assertNull ("stackTraceElement.getMethod() should return null if the thrower(!) is null", getStackTraceElement (null, thrower.normalMethod, args).getMethod());
		
		// Validates that if thrower is undefined, the algorythm for getMethod returns undefined.
		assertNull ("stackTraceElement.getMethod() should return null if the thrower(!) is undefined", getStackTraceElement (undefined, thrower.normalMethod, args).getMethod());
	}
	
	/**
	 * Test if the arguments are returned properly
	 */
	public function testGetArguments (){
		
		// Validates the usual case completly.
		var stackTraceElement:StackTraceElement = getStackTraceElement (thrower, method, args);
		assertEquals ("stackTraceElement.getArguments() should return the args object", stackTraceElement.getArguments(), args);
		assertEquals ("stackTraceElement.getArguments().callee should return the callee", stackTraceElement.getArguments().callee, callee);
		assertEquals ("stackTraceElement.getArguments().caller should return the caller", stackTraceElement.getArguments().caller, caller);
		
		// Validates wrong cases
		assertNull ("stackTraceElement.getArguments() should return null if null is applied for the arguments", getStackTraceElement(thrower, method, null).getArguments() );
		assertNull ("stackTraceElement.getArguments() should return undefined if undefined is applied for the arguments", getStackTraceElement(thrower, method, undefined).getArguments() );
		
		// Validates cases with missing method or thrower
		assertEquals ("stackTraceElement.getArguments() should return the args object, even with missing thrower", getStackTraceElement(null, method, args).getArguments(), args);
		assertEquals ("stackTraceElement.getArguments() should return the args object, even with missing method", getStackTraceElement(thrower, null, args).getArguments(), args);
		assertEquals ("stackTraceElement.getArguments() should return the args object, even with missing thrower and method", getStackTraceElement(null, null, args).getArguments(), args);
		
	}
}
