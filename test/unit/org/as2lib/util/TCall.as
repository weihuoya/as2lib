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
import org.as2lib.app.exec.Call;
import org.as2lib.util.ConstructorCall;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * Test of all methods in Call.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.util.TCall extends TestCase {
	// Instance for the current scope.
	private static var instance:TCall;
	
	/**
	 * Setting the current instance to the static instance.
	 */
	public function setUp(Void):Void {
		instance = this;
	}
	
	/**
	 * Validates that invalid Arguments really throw a exception
	 */
	public function testInvalidArguments(Void):Void {
		assertThrows("Both have to be given", IllegalArgumentException, new ConstructorCall(Call),
			[null, null]);
		assertThrows("Method has to be given", IllegalArgumentException, new ConstructorCall(Call),
			[{}]);
		assertThrows("Scope has to be given", IllegalArgumentException, new ConstructorCall(Call),
			[null, function(){}]);
	}
	
	/**
	 * Creates a new call and executes it.
	 */
	public function testCall(Void):Void {
		var call:Call = new Call(this, internalCall);
		call.execute("a", "b");
	}
	
	/**
	 * Testmethod to be executed.
	 */
	public function internalCall(s1:String, s2:String):Void {
		assertEquals("The first argument should match the call arguments", s1, "a");
		assertEquals("The second argument should match the call arguments", s2, "b");
		assertSame("The scope may not change by calling the Call", this, instance);
	}
	
	/**
	 * Removing the static instance
	 */
	public function tearDown(Void):Void {
		delete instance;
	}
}