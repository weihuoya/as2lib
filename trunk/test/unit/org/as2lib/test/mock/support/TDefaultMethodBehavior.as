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
import org.as2lib.test.mock.support.DefaultMethodBehavior;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodResponse;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.TDefaultMethodBehavior extends TestCase {
	
	public function testVerifyWithMultipleMethodCallRanges(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(new MethodCall("m", []));
		b.addMethodResponse(null, new MethodCallRange(2, 5));
		b.addMethodResponse(null, new MethodCallRange(0, 2));
		b.addMethodResponse(null, new MethodCallRange(3));
		b.addMethodResponse(null, new MethodCallRange(1, 2));
		try {
			b.verify();
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.addActualMethodCall(new MethodCall("m", []));
		try {
			b.verify();
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.addActualMethodCall(new MethodCall("m", []));
		try {
			b.verify();
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.addActualMethodCall(new MethodCall("m", []));
		try {
			b.verify();
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.addActualMethodCall(new MethodCall("m", []));
		try {
			b.verify();
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.addActualMethodCall(new MethodCall("m", []));
		try {
			b.verify();
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.addActualMethodCall(new MethodCall("m", []));
		b.verify();
		b.addActualMethodCall(new MethodCall("m", []));
		b.verify();
		b.addActualMethodCall(new MethodCall("m", []));
		b.verify();
		b.addActualMethodCall(new MethodCall("m", []));
		b.verify();
		b.addActualMethodCall(new MethodCall("m", []));
		b.verify();
		b.addActualMethodCall(new MethodCall("m", []));
		b.verify();
		b.addActualMethodCall(new MethodCall("m", []));
		b.verify();
		try {
			b.addActualMethodCall(new MethodCall("m", []));
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.verify();
	}
	
	public function testVerifyWithNullExpectedMethodCall(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(null);
		b.verify();
		try {
			b.addActualMethodCall(new MethodCall("m", []));
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.verify();
	}
	
	public function testVerify(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(new MethodCall("m", []));
		b.addMethodResponse(null, new MethodCallRange(2, 5));
		try {
			b.verify();
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.addActualMethodCall(new MethodCall("m", []));
		try {
			b.verify();
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.addActualMethodCall(new MethodCall("m", []));
		b.verify();
		b.addActualMethodCall(new MethodCall("m", []));
		b.verify();
		b.addActualMethodCall(new MethodCall("m", []));
		b.verify();
		b.addActualMethodCall(new MethodCall("m", []));
		b.verify();
		try {
			b.addActualMethodCall(new MethodCall("m", []));
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.verify();
		try {
			b.addActualMethodCall(new MethodCall("m", []));
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
		b.verify();
	}
	
	public function testAddMethodResponseWithNullExpectedMethodCall(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(null);
		try {
			b.addMethodResponse(null, null);
			fail("Expected IllegalStateException.");
		} catch (e:org.as2lib.env.except.IllegalStateException) {
		}
	}
	
	public function testNewWithNullArgument(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(null);
		assertNull(b.getExpectedMethodCall());
	}
	
	public function testNewWithRealArgument(Void):Void {
		var c:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(c);
		assertSame(b.getExpectedMethodCall(), c);
	}
	
	public function testAddActualMethodCallWithNullArgument(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(null);
		try {
			b.addActualMethodCall(null);
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testAddActualMethodCallWithNotMatchingActualMethodCall(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(new MethodCall("methodName", []));
		try {
			b.addActualMethodCall(new MethodCall("methodName1", [";)"]));
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
	}
	
	public function testAddActualMethodCallWithMatchingCall(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(new MethodCall("methodName", []));
		b.addActualMethodCall(new MethodCall("methodName", []));
	}
	
	public function testAddActualMethodCallWithMatchingCallAndExpectedRangeOfZero(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(new MethodCall("methodName", []));
		b.addMethodResponse(null, new MethodCallRange(0));
		try {
			b.addActualMethodCall(new MethodCall("methodName", []));
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
	}
	
	public function testAddActualMethodCallWithMatchingCallAndExplicitCallCount(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(new MethodCall("methodName", []));
		b.addMethodResponse(null, new MethodCallRange(3));
		b.addActualMethodCall(new MethodCall("methodName", []));
		b.addActualMethodCall(new MethodCall("methodName", []));
		b.addActualMethodCall(new MethodCall("methodName", []));
		try {
			b.addActualMethodCall(new MethodCall("methodName", []));
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
	}
	
	public function testAddActualMethodCallWithMatchingCallAndMultipleExplicitCallCounts(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(new MethodCall("methodName", []));
		b.addMethodResponse(null, new MethodCallRange(0));
		b.addMethodResponse(null, new MethodCallRange(2));
		b.addMethodResponse(null, new MethodCallRange(1));
		b.addMethodResponse(null, new MethodCallRange(3));
		b.addActualMethodCall(new MethodCall("methodName", []));
		b.addActualMethodCall(new MethodCall("methodName", []));
		b.addActualMethodCall(new MethodCall("methodName", []));
		b.addActualMethodCall(new MethodCall("methodName", []));
		b.addActualMethodCall(new MethodCall("methodName", []));
		b.addActualMethodCall(new MethodCall("methodName", []));
		try {
			b.addActualMethodCall(new MethodCall("methodName", []));
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
	}
	
	public function testAddActualMethodCallWithNullExpectedMethodCall(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(null);
		try {
			b.addActualMethodCall(new MethodCall("methodName", []));
			fail("Expected MethodCallRangeError.");
		} catch (e:org.as2lib.test.mock.MethodCallRangeError) {
		}
	}
	
	public function testExpectsAnotherMethodCallWithoutExpectedMethodCall(Void):Void {
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(null);
		assertFalse(b.expectsAnotherMethodCall());
	}
	
	public function testExpectsAnotherMethodCallWithoutExpectedCallRangesAndAddedMethodCalls(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(ec);
		assertTrue(b.expectsAnotherMethodCall());
	}
	
	public function testExpectsAnotherMethodCallWithoutExpectedCallRangesButWithAddedMethodCall(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(ec);
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertFalse(b.expectsAnotherMethodCall());
	}
	
	public function testExpectsAnotherMethodCallWithOneMethodCallRange(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(ec);
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(2, 5));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertFalse(b.expectsAnotherMethodCall());
	}
	
	public function testExpectsAnotherMethodCallWithExplicitCallQuantities(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(ec);
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(3));
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(2));
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(5));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertFalse(b.expectsAnotherMethodCall());
	}
	
	public function testExpectsAnotherMethodCallWithMethodCallRanges(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(ec);
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(2, 3));
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(1, 2));
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(3, 5));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertTrue(b.expectsAnotherMethodCall());
		b.addActualMethodCall(new MethodCall("methodName", []));
		assertFalse(b.expectsAnotherMethodCall());
	}
	
	public function testExpectsAnotherMethodCallWithNullMethodCallRange(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(ec);
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(3));
		b.addMethodResponse(new MethodResponse(), null);
		for (var i:Number = 0; i < 100; i++) {
			assertTrue(b.expectsAnotherMethodCall());
			b.addActualMethodCall(new MethodCall("methodName", []));
		}
	}
	
	public function testExpectsAnotherMethodCallWithAnyQuantityMethodCallRange(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(ec);
		b.addMethodResponse(new MethodResponse(), new MethodCallRange(3));
		b.addMethodResponse(new MethodResponse(), new MethodCallRange());
		for (var i:Number = 0; i < 100; i++) {
			assertTrue(b.expectsAnotherMethodCall());
			b.addActualMethodCall(new MethodCall("methodName", []));
		}
	}
	
	public function testResponseWithNullResponse(Void):Void {
		var ec:MethodCall = new MethodCall("methodName", []);
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(ec);
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
		var b:DefaultMethodBehavior = new DefaultMethodBehavior(ec);
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
	
}