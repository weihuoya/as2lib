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

/**
 * @author Jayaprakash A
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
		method = function(){};
		callee = function(){};
		caller = function(){};
		args = new Array();
		args.push ("param1");
		args.push ("param2");
		args.callee = callee;
		args.caller = caller;
		thrower = {};
		thrower.prototype.method = callee;
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
		var stackTraceElement:StackTraceElement = getStackTraceElement (thrower, method, args);

		//Validates that the thrower passed in was properly returned
		assertEquals ("stackTraceElement.getThrower() should return thrower Object.", stackTraceElement.getThrower(), ClassInfo.forObject(thrower));
	}
	
	/**
	 * Test if the method name is returned properly
	 */
	public function testGetMethod (){
		var stackTraceElement:StackTraceElement = getStackTraceElement (thrower, method, args);
		
		//Validates that the method called was properly returned
		assertEquals ("stackTraceElement.getMethod() should return same method.", stackTraceElement.getMethod().getMethod(), method);
	}
	
	/**
	 * Test if the arguments are returned properly
	 */
	public function testGetArguments (){
		var stackTraceElement:StackTraceElement = getStackTraceElement (thrower, method, args);
		
		//Validates that the thrower passed in was properly returned
		assertEquals ("stackTraceElement.getArguments() should return the args object.", stackTraceElement.getArguments(), args);
		
		//TODO Are these really required??
		//Validates that the callee was properly returned
		assertEquals ("stackTraceElement.getArguments().callee should return the callee .", stackTraceElement.getArguments().callee, callee);
		//Validates that the caller was properly returned
		assertEquals ("stackTraceElement.getArguments().caller should return the caller .", stackTraceElement.getArguments().caller, caller);
	}
}
