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
import org.as2lib.test.mock.support.DefaultMethodBehaviour;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodResponse;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.support.TDefaultMethodBehaviour extends TestCase {
	
	public function testNewWithNullArgument(Void):Void {
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(null);
		assertNull(b.getExpectedMethodCall());
	}
	
	public function testNewWithRealArgument(Void):Void {
		var c:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(c);
		assertSame(b.getExpectedMethodCall(), c);
	}
	
	public function testAddActualMethodCallWithNullArgument(Void):Void {
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(null);
		b.addActualMethodCall(null);
		b.addActualMethodCall(null);
		b.addActualMethodCall(null);
		assertSame(b.getActualMethodCalls()[0], null);
		assertSame(b.getActualMethodCalls()[1], null);
		assertSame(b.getActualMethodCalls()[2], null);
	}
	
	public function testAddActualMethodCallWithRealArgument(Void):Void {
		var c1:MethodCall = new MethodCall("methodName", []);
		var c2:MethodCall = new MethodCall("methodName", []);
		var c3:MethodCall = new MethodCall("methodName", []);
		
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(null);
		b.addActualMethodCall(c1);
		b.addActualMethodCall(c2);
		b.addActualMethodCall(c3);
		assertSame(b.getActualMethodCalls()[0], c1);
		assertSame(b.getActualMethodCalls()[1], c2);
		assertSame(b.getActualMethodCalls()[2], c3);
	}
	
	public function testExpectsAnotherMethodCallWithoutExpectedCallRangesAndAddedMethodCalls(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(ec);
		assertFalse(b.expectsAnotherMehodCall());
	}
	
	public function testExpectsAnotherMethodCallWithoutExpectedCallRangesButWithAddedMethodCalls(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(ec);
		b.addActualMethodCall(new MethodCall("methodName", []));
		b.addActualMethodCall(new MethodCall("methodName", []));
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertFalse(b.expectsAnotherMehodCall());
	}
	
	public function testExpectsAnotherMethodCallWithOneMethodCallRange(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(ec);
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(2, 5));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertFalse(b.expectsAnotherMehodCall());
	}
	
	public function testExpectsAnotherMethodCallWithExplicitCallQuantities(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(ec);
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(3));
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(2));
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(5));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertFalse(b.expectsAnotherMehodCall());
	}
	
	public function testExpectsAnotherMethodCallWithMethodCallRanges(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(ec);
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(2, 3));
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(1, 2));
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(3, 5));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMehodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertFalse(b.expectsAnotherMehodCall());
	}
	
	public function testExpectsAnotherMethodCallWithNullMethodCallRange(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(ec);
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(3));
		b.addMethodResponse(new MethodResponse(), null);
		for (var i:Number = 0; i < 100; i++) {
			assertTrue(b.expectsAnotherMehodCall());
			b.addActualMethodCall(new MethodCall("methodName", []));
		}
	}
	
	public function testExpectsAnotherMethodCallWithAnyQuantityMethodCallRange(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(ec);
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(3));
		b.addMethodResponse(new MethodResponse(), new MethodCallRange());
		for (var i:Number = 0; i < 100; i++) {
			assertTrue(b.expectsAnotherMehodCall());
			b.addActualMethodCall(new MethodCall("methodName", []));
		}
	}
	
	public function testResponseWithNullResponse(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(ec);
		b.addMethodResponse(null, new MethodCallRange(1, 3));
		assertUndefined(b.response());
		assertUndefined(b.response());
		assertUndefined(b.response());
		assertUndefined(b.response());
	}
	
	public function testResponse(Void):Void {
		var r1:MethodResponse = new MethodResponse();
		r1.setReturnValue("r1");
		var r2:MethodResponse = new MethodResponse();
		r2.setReturnValue("r2");
		var r3:MethodResponse = new MethodResponse();
		r3.setReturnValue("r3");
		
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehaviour = new DefaultMethodBehaviour(ec);
		b.addMethodResponse(r1, new MethodCallRange(3));
		b.addMethodResponse(r2, new MethodCallRange(2, 5));
		b.addMethodResponse(r3, new MethodCallRange());
		for (var i:Number = 0; i < 3; i++) {
			b.addActualMethodCall(new MethodCall("methodName", []));
			assertSame(b.response(), "r1");
		}
		for (var i:Number = 0; i < 5; i++) {
			b.addActualMethodCall(new MethodCall("methodName", []));
			assertSame(b.response(), "r2");
		}
		for (var i:Number = 0; i < 100; i++) {
			b.addActualMethodCall(new MethodCall("methodName", []));
			assertSame(b.response(), "r3");
		}
	}
	
	public function testVerify(Void):Void {
		// TODO (any tests regarding the verify method)
	}
	
}