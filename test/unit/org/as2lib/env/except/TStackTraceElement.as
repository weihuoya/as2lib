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
import org.as2lib.env.except.SimpleTestClass;

/**
 * Implementation test for the SimpleStackElement
 *
 * @author Jayaprakash A
 * @author Martin Heidegger
 */
class org.as2lib.env.except.TStackTraceElement extends TestCase {
	
	private var method:Function;
	private var args:Array;
	private var thrower:Object;
	private var callee:Function;
	private var caller:Function;
	
	/**
	 * Template Method to get the specific StackTraceElement implementation.
	 */
	public function getStackTraceElement (thrower:Object, method:Function, args:Array):StackTraceElement {
		return new StackTraceElement(thrower, method, args);
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
		assertEquals ("stackTraceElement.getThrower() should return thrower Object", getStackTraceElement (thrower, method, args).getThrower(), thrower);
		
		// Validates that the thrower passed in as null was properly returned as null
		assertNull ("stackTraceElement.getThrower() should return null if it was applied as null", getStackTraceElement (null, method, args).getThrower());
		
		// Validates that the thrower passed in as undefined was properly returned
		assertNull ("stackTraceElement.getThrower() should return null if it was applied as undefined", getStackTraceElement (undefined, method, args).getThrower());
		
		// Validates that the thrower passed in was properly returned if no method was applied
		assertEquals ("stackTraceElement.getThrower() should return thrower Object if no method was applied", getStackTraceElement (thrower, null, args).getThrower(), thrower);
		
		// Validates that the thrower passed in was properly returned if no arguments was applied
		assertEquals ("stackTraceElement.getThrower() should return thrower Object if no arguments were applied", getStackTraceElement (thrower, method, null).getThrower(), thrower);
		
		// Validates that the thrower passed in was properly returned if both (method and arguments) were applied
		assertEquals ("stackTraceElement.getThrower() should return thrower Object if both were not applied", getStackTraceElement (thrower, method, args).getThrower(), thrower);
	}
	
	/**
	 * Test if the method name is returned properly in usual and unusual cases
	 */
	public function testGetMethod (){
		// Placeholder
		var stackTraceElement:StackTraceElement;
		
		// Validates that a public method called was properly returned - This is the usual case
		stackTraceElement = getStackTraceElement (thrower, thrower.normalMethod, args);
		assertSame ("stackTraceElement.getMethod() should return same method", stackTraceElement.getMethod(), thrower.normalMethod);
		
		// Validates that a static method called was properly returned
		stackTraceElement = getStackTraceElement (thrower, SimpleTestClass.staticMethod, args);
		assertEquals ("stackTraceElement.getMethod() should return same, static method", stackTraceElement.getMethod(), SimpleTestClass.staticMethod);
		
		// Validates that if no method will be used, undefined will be returned
		assertNull ("stackTraceElement.getMethod() should return null if the method is undefined", getStackTraceElement (thrower, undefined, args).getMethod());
		
		// Validates that if no method will be used, undefined will be returned
		assertNull ("stackTraceElement.getMethod() should return null if the method is null", getStackTraceElement (thrower, null, args).getMethod());
	}
	
	/**
	 * Test if the arguments are returned properly
	 */
	public function testGetArguments (){
		// Validates the usual case completly.
		var stackTraceElement:StackTraceElement = getStackTraceElement (thrower, method, args);
		var returnedArgs:Array = stackTraceElement.getArguments();
		for (var i:Number = 0; i < returnedArgs.length; i++) {
			assertSame("element '" + i + "' of arguments are not the same", returnedArgs[i], args[i]);
		}
		
		// Validates wrong cases
		assertEmpty("stackTraceElement.getArguments() should return null or undefined if null is applied for the arguments", getStackTraceElement(thrower, method, null).getArguments() );
		assertEmpty("stackTraceElement.getArguments() should return null or undefined if undefined is applied for the arguments", getStackTraceElement(thrower, method, undefined).getArguments() );
		
		// Validates cases with missing method or thrower
		assertTrue("stackTraceElement.getArguments() should return the args object, even with missing thrower", compareArguments(getStackTraceElement(null, method, args).getArguments(), args));
		assertTrue("stackTraceElement.getArguments() should return the args object, even with missing method", compareArguments(getStackTraceElement(thrower, null, args).getArguments(), args));
		assertTrue("stackTraceElement.getArguments() should return the args object, even with missing thrower and method", compareArguments(getStackTraceElement(null, null, args).getArguments(), args));
	}
	
	private function compareArguments(args1:Array, args2:Array):Boolean {
		if (args1.length != args2.length) return false;
		for (var i:Number = 0; i < args1.length; i++) {
			if (args1[i] != args2[i]) return false;
		}
		return true;
	}
	
}
