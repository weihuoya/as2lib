/**
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
import org.as2lib.test.mock.MethodCall;
import test.unit.org.as2lib.test.mock.ArgumentsMatcherMock;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.TMethodCall extends TestCase {
	
	public function testMatchesWithNullArgument(Void):Void {
		var c:MethodCall = new MethodCall("name", []);
		c.setArgumentsMatcher(new ArgumentsMatcherMock(this));
		assertFalse(c.matches(null));
	}
	
	public function testMatchesWithDifferentMethodNames(Void):Void {
		var c:MethodCall = new MethodCall("name", []);
		c.setArgumentsMatcher(new ArgumentsMatcherMock(this));
		assertFalse(c.matches(new MethodCall("anotherName", [])));
	}
	
	public function testMatchesWithNullReturningGetArgumentsMethodOfPassedInMethodCall(Void):Void {
		// MethodCallMock needed!
	}
	
	public function testMatchesWithSameArguments(Void):Void {
		var args1:Array = [new Object(), new Array(), true, "lol"];
		var args2:Array = [new Object(), new Array(), true, "lol"];
		
		var a:ArgumentsMatcherMock = new ArgumentsMatcherMock(this);
		a.setExpectedCallToMatchArguments();
		a.setReturnValueForMatchArguments(true);
		a.setExpectedExpectedArguments(args1);
		a.setExpectedActualArguments(args2);
		
		var c:MethodCall = new MethodCall("name", args1);
		c.setArgumentsMatcher(a);
		assertTrue(c.matches(new MethodCall("name", args2)));
	}
	
	public function testMatchesWithDifferentArguments(Void):Void {
		var args1:Array = [new Object(), new Array(), true, "lol"];
		var args2:Array = [new Object(), new Array(), true, "lol"];
		
		var a:ArgumentsMatcherMock = new ArgumentsMatcherMock(this);
		a.setExpectedCallToMatchArguments();
		a.setReturnValueForMatchArguments(false);
		a.setExpectedExpectedArguments(args1);
		a.setExpectedActualArguments(args2);
		
		var c:MethodCall = new MethodCall("name", args1);
		c.setArgumentsMatcher(a);
		assertFalse(c.matches(new MethodCall("name", args2)));
	}
	
}