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

import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.Throwable;
import org.as2lib.test.unit.TestCase;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.Call;

/**
 * This is a test to proof if all TestUnit Methods work
 * correctly. It examines and proofs all assert methods
 * and it contains test during set up and tear down.
 * 
 * If you run this test you should never see any Output that
 * contains "NOT FAIL!". This output means a test didn't fail
 * but it should have failed, or a test failed but it shouldn't.
 * 
 * It is also a example for all available output stringifier.
 * 
 * @author Martin Heideggers
 */
class AssertTest extends TestCase {
	
    public var interval:Number; // Holder for testPause Method
	
	private static var NOT_FAIL_MESSAGE:String = "NOT FAIL!";
	private static var FAIL_MESSAGE:String = "fail";
	
	private static function failMessage(number:Number):String {
		return NOT_FAIL_MESSAGE+number;
	}
	
    public function AssertTest(Void) {
		// Only for a test
		// Strings thrown to evaluate how it acts with unexcepted Exceptiontypes.
		// throw "My Error @ constructor";
	}
	
	
	public function testPause(Void):Void {
		pause();
		fail("Failed before pause.");
		interval = setInterval(resumePause, 200, this);
	}
	
	public function resumePause(that:AssertTest):Void {
		that.fail("Failed by another Method after pause.");
		clearInterval(that.interval);
		that.resume();
	}
	
	public function dontTestMe(Void):Void {
		fail(NOT_FAIL_MESSAGE+", this method should not be called");
	}
	
    public function setUp(Void):Void {
		// Only for a test
		// Strings thrown to evaluate how it acts with unexcepted Exceptiontypes.
		// throw "My Error @ set up";
	}
	
    public function testError(Void):Void {		
		// Strings thrown to evaluate how it acts with unexcepted Exceptiontypes.
		throw "My Error @ test Me ";
    }

	public function testFail(Void):Void {
		fail(FAIL_MESSAGE);
		fail();
	}
	
	public function testTrue(Void):Void {
		assertFalse(failMessage(1 ), assertTrue(false));
		assertFalse(failMessage(2 ), assertTrue(FAIL_MESSAGE, false));
		assertFalse(failMessage(3 ), assertTrue());
		assertTrue (failMessage(4 ), assertTrue(NOT_FAIL_MESSAGE, true));
		assertTrue (failMessage(5 ), assertTrue(true));
	}
	
    public function testFalse(Void):Void {
		assertFalse(failMessage(1 ), assertFalse(true));
		assertFalse(failMessage(2 ), assertFalse(FAIL_MESSAGE, true));
		assertFalse(failMessage(3 ), assertFalse());
		assertTrue (failMessage(4 ), assertFalse(NOT_FAIL_MESSAGE, false));
		assertTrue (failMessage(5 ), assertFalse(false));
	}
	
	public function testEquals(Void):Void {
		assertTrue (failMessage(1 ), assertEquals(NOT_FAIL_MESSAGE, undefined, undefined));
		assertTrue (failMessage(2 ), assertEquals(NOT_FAIL_MESSAGE, undefined, null));
		assertFalse(failMessage(3 ), assertEquals(FAIL_MESSAGE, undefined, 1));
		assertTrue (failMessage(4 ), assertEquals(NOT_FAIL_MESSAGE, null, undefined));
		assertFalse(failMessage(5 ), assertEquals(FAIL_MESSAGE, 1, undefined));
		assertTrue (failMessage(6 ), assertEquals(NOT_FAIL_MESSAGE, undefined));
		assertFalse(failMessage(7 ), assertEquals(FAIL_MESSAGE, 1, 2));
		assertTrue (failMessage(8 ), assertEquals(NOT_FAIL_MESSAGE, 1, 1));
		assertFalse(failMessage(9 ), assertEquals(FAIL_MESSAGE, 1));
		assertFalse(failMessage(10), assertEquals("fail!", null));
		assertTrue (failMessage(11), assertEquals(undefined, undefined));
		assertTrue (failMessage(12), assertEquals(undefined, null));
		assertFalse(failMessage(13), assertEquals(undefined, 1));
		assertTrue (failMessage(14), assertEquals(undefined));
		assertTrue (failMessage(15), assertEquals(null, null));
		assertTrue (failMessage(16), assertEquals(null));
		assertTrue (failMessage(17), assertEquals(1, 1));
		assertFalse(failMessage(18), assertEquals(1));
		assertTrue (failMessage(19), assertEquals());
		assertTrue (failMessage(20), assertEquals(NOT_FAIL_MESSAGE, NOT_FAIL_MESSAGE+""));
		assertFalse(failMessage(21), assertEquals(null, FAIL_MESSAGE));
	}
	
	public function testAlmostEquals(Void):Void {
		assertTrue (failMessage(1 ), assertAlmostEquals(NOT_FAIL_MESSAGE, 1, 1/3*3, 0.1));
		assertTrue (failMessage(2 ), assertAlmostEquals(NOT_FAIL_MESSAGE, 1, 0, 1));
		assertFalse(failMessage(3 ), assertAlmostEquals(FAIL_MESSAGE, 1, 0.8));
		assertFalse(failMessage(4 ), assertAlmostEquals(FAIL_MESSAGE, 0.8, 1));
		assertTrue (failMessage(5 ), assertAlmostEquals(NOT_FAIL_MESSAGE, 1/3*3, 1));
		assertTrue (failMessage(6 ), assertAlmostEquals(1/3*3, 1));
		assertTrue (failMessage(7 ), assertAlmostEquals(1/3*3, 1, 0));
		assertTrue (failMessage(8 ), assertAlmostEquals(1, 0, 1));
		assertFalse(failMessage(9 ), assertAlmostEquals(1, 0.899999, 0.1));
	}
	
	public function testNotEquals(Void):Void {
		assertFalse(failMessage(1 ), assertNotEquals(FAIL_MESSAGE, undefined, undefined));
		assertFalse(failMessage(2 ), assertNotEquals(FAIL_MESSAGE, undefined, null));
		assertTrue (failMessage(3 ), assertNotEquals(NOT_FAIL_MESSAGE, undefined, 1));
		assertFalse(failMessage(4 ), assertNotEquals(FAIL_MESSAGE, null, undefined));
		assertTrue (failMessage(5 ), assertNotEquals(NOT_FAIL_MESSAGE, 1, undefined));
		assertFalse(failMessage(6 ), assertNotEquals(FAIL_MESSAGE, undefined));
		assertTrue (failMessage(7 ), assertNotEquals(NOT_FAIL_MESSAGE, 1, 2));
		assertFalse(failMessage(8 ), assertNotEquals(FAIL_MESSAGE, 1, 1));
		assertTrue (failMessage(9 ), assertNotEquals(FAIL_MESSAGE, 1));
		assertTrue (failMessage(10), assertNotEquals(FAIL_MESSAGE, null));
		assertFalse(failMessage(11), assertNotEquals(undefined, undefined));
		assertFalse(failMessage(12), assertNotEquals(undefined, null));
		assertTrue (failMessage(13), assertNotEquals(undefined, 1));
		assertFalse(failMessage(14), assertNotEquals(undefined));
		assertFalse(failMessage(15), assertNotEquals(null, null));
		assertFalse(failMessage(16), assertNotEquals(null));
		assertFalse(failMessage(17), assertNotEquals(1, 1));
		assertTrue (failMessage(18), assertNotEquals(1));
		assertFalse(failMessage(19), assertNotEquals());
		assertFalse(failMessage(20), assertNotEquals(FAIL_MESSAGE, FAIL_MESSAGE));
		assertTrue (failMessage(21), assertNotEquals(null, NOT_FAIL_MESSAGE+""));
	}
	
	public function testSame(Void):Void {
		assertTrue (failMessage(1 ), assertSame(NOT_FAIL_MESSAGE, undefined, undefined));
		assertFalse(failMessage(2 ), assertSame(FAIL_MESSAGE, undefined, null));
		assertFalse(failMessage(3 ), assertSame(FAIL_MESSAGE, undefined, 1));
		assertFalse(failMessage(4 ), assertSame(FAIL_MESSAGE, null, undefined));
		assertFalse(failMessage(5 ), assertSame(FAIL_MESSAGE, 1, undefined));
		assertTrue (failMessage(6 ), assertSame(FAIL_MESSAGE, undefined));
		assertFalse(failMessage(7 ), assertSame(FAIL_MESSAGE, 1, 2));
		assertTrue (failMessage(8 ), assertSame(NOT_FAIL_MESSAGE, 1, 1));
		assertFalse(failMessage(9 ), assertSame(FAIL_MESSAGE, 1));
		assertFalse(failMessage(10), assertSame(FAIL_MESSAGE, null));
		assertTrue (failMessage(11), assertSame(undefined, undefined));
		assertFalse(failMessage(12), assertSame(undefined, null));
		assertFalse(failMessage(13), assertSame(undefined, 1));
		assertTrue (failMessage(14), assertSame(undefined));
		assertTrue (failMessage(15), assertSame(null, null));
		assertFalse(failMessage(16), assertSame(null));
		assertTrue (failMessage(17), assertSame(1, 1));
		assertFalse(failMessage(18), assertSame(1));
		assertTrue (failMessage(19), assertSame());
	}
	
	public function testNotSame(Void):Void {
		assertFalse(failMessage(1 ), assertNotSame(FAIL_MESSAGE, undefined, undefined));
		assertTrue (failMessage(2 ), assertNotSame(NOT_FAIL_MESSAGE, undefined, null));
		assertTrue (failMessage(3 ), assertNotSame(NOT_FAIL_MESSAGE, undefined, 1));
		assertTrue (failMessage(4 ), assertNotSame(NOT_FAIL_MESSAGE, null, undefined));
		assertTrue (failMessage(5 ), assertNotSame(NOT_FAIL_MESSAGE, 1, undefined));
		assertFalse(failMessage(6 ), assertNotSame(FAIL_MESSAGE, undefined));
		assertTrue (failMessage(7 ), assertNotSame(NOT_FAIL_MESSAGE, 1, 2));
		assertFalse(failMessage(8 ), assertNotSame(FAIL_MESSAGE, 1, 1));
		assertTrue (failMessage(9 ), assertNotSame(NOT_FAIL_MESSAGE, 1));
		assertTrue (failMessage(10), assertNotSame(NOT_FAIL_MESSAGE, null));
		assertFalse(failMessage(11), assertNotSame(undefined, undefined));
		assertTrue (failMessage(12), assertNotSame(undefined, null));
		assertTrue (failMessage(13), assertNotSame(undefined, 1));
		assertFalse(failMessage(14), assertNotSame(undefined));
		assertFalse(failMessage(15), assertNotSame(null, null));
		assertTrue (failMessage(16), assertNotSame(null));
		assertFalse(failMessage(17), assertNotSame(1, 1));
		assertTrue (failMessage(18), assertNotSame(1));
		assertFalse(failMessage(19), assertNotSame());
	}
	
	public function testNull(Void):Void {
		assertTrue (failMessage(1 ), assertNull(null));
		assertFalse(failMessage(2 ), assertNull(undefined));
		assertTrue (failMessage(3 ), assertNull(NOT_FAIL_MESSAGE, null));
		assertFalse(failMessage(4 ), assertNull(FAIL_MESSAGE, undefined));
		assertFalse(failMessage(5 ), assertNull(FAIL_MESSAGE, 3));
		assertFalse(failMessage(6 ), assertNull(FAIL_MESSAGE, undefined));
		assertFalse(failMessage(7 ), assertNull(FAIL_MESSAGE));
		assertFalse(failMessage(8 ), assertNull(2));
		assertFalse(failMessage(9 ), assertNull());
	}
	
	public function testNotNull(Void):Void {
		assertFalse(failMessage(1 ), assertNotNull(null));
		assertTrue (failMessage(2 ), assertNotNull(undefined));
		assertFalse(failMessage(3 ), assertNotNull(FAIL_MESSAGE, null));
		assertTrue (failMessage(4 ), assertNotNull(NOT_FAIL_MESSAGE, undefined));
		assertTrue (failMessage(5 ), assertNotNull(NOT_FAIL_MESSAGE, 0));
		assertTrue (failMessage(6 ), assertNotNull(FAIL_MESSAGE));
		assertTrue (failMessage(7 ), assertNotNull(2));
		assertTrue (failMessage(8 ), assertNotNull());
	}
	
	public function testUndefined(Void):Void {
		assertFalse(failMessage(1 ), assertUndefined(null));
		assertTrue (failMessage(2 ), assertUndefined(undefined));
		assertFalse(failMessage(3 ), assertUndefined(FAIL_MESSAGE, null));
		assertTrue (failMessage(4 ), assertUndefined(NOT_FAIL_MESSAGE, undefined));
		assertFalse(failMessage(5 ), assertUndefined(FAIL_MESSAGE, 3));
		assertFalse(failMessage(6 ), assertUndefined(FAIL_MESSAGE));
		assertFalse(failMessage(7 ), assertUndefined(2));
		assertTrue (failMessage(8 ), assertUndefined());
	}
	
	public function testNotUndefined(Void):Void {
		assertTrue (failMessage(1 ), assertNotUndefined(null));
		assertFalse(failMessage(2 ), assertNotUndefined(undefined));
		assertTrue (failMessage(3 ), assertNotUndefined(NOT_FAIL_MESSAGE, null));
		assertFalse(failMessage(4 ), assertNotUndefined(FAIL_MESSAGE, undefined));
		assertTrue (failMessage(5 ), assertNotUndefined(NOT_FAIL_MESSAGE, 3));
		assertTrue (failMessage(6 ), assertNotUndefined(NOT_FAIL_MESSAGE+""));
		assertTrue (failMessage(7 ), assertNotUndefined(2));
		assertFalse(failMessage(8 ), assertNotUndefined());
	}

	public function testInfinity(Void):Void {
		assertTrue (failMessage(1 ), assertInfinity(NOT_FAIL_MESSAGE, Infinity));
		assertFalse(failMessage(2 ), assertInfinity(FAIL_MESSAGE, 1000000000));
		assertFalse(failMessage(3 ), assertInfinity(FAIL_MESSAGE, 1));
		assertFalse(failMessage(4 ), assertInfinity(FAIL_MESSAGE, undefined));
		assertFalse(failMessage(5 ), assertInfinity(FAIL_MESSAGE));
		assertTrue (failMessage(6 ), assertInfinity(Infinity));
		assertFalse(failMessage(7 ), assertInfinity(1));
		assertFalse(failMessage(8 ), assertInfinity());
	}
	
	public function testNotInfinity(Void):Void {
		assertFalse(failMessage(1 ), assertNotInfinity(FAIL_MESSAGE, Infinity));
		assertTrue (failMessage(2 ), assertNotInfinity(NOT_FAIL_MESSAGE, 1000000000));
		assertTrue (failMessage(3 ), assertNotInfinity(NOT_FAIL_MESSAGE, 1));
		assertTrue (failMessage(4 ), assertNotInfinity(NOT_FAIL_MESSAGE, undefined));
		assertTrue (failMessage(5 ), assertNotInfinity(NOT_FAIL_MESSAGE+""));
		assertFalse(failMessage(6 ), assertNotInfinity(Infinity));
		assertTrue (failMessage(7 ), assertNotInfinity(1));
		assertTrue (failMessage(8 ), assertNotInfinity());
	}
	
	public function testEmpty(Void):Void {
		assertTrue (failMessage(1 ), assertEmpty(null));
		assertTrue (failMessage(2 ), assertEmpty(undefined));
		assertTrue (failMessage(3 ), assertEmpty(NOT_FAIL_MESSAGE, null));
		assertTrue (failMessage(4 ), assertEmpty(NOT_FAIL_MESSAGE, undefined));
		assertFalse(failMessage(5 ), assertEmpty(FAIL_MESSAGE, 3));
		assertFalse(failMessage(6 ), assertEmpty(FAIL_MESSAGE));
		assertFalse(failMessage(7 ), assertEmpty(2));
		assertTrue (failMessage(8 ), assertEmpty());
	}
	
	public function testNotEmpty(Void):Void {
		assertFalse(failMessage(1 ), assertNotEmpty(null));
		assertFalse(failMessage(2 ), assertNotEmpty(undefined));
		assertFalse(failMessage(3 ), assertNotEmpty(FAIL_MESSAGE, null));
		assertFalse(failMessage(4 ), assertNotEmpty(FAIL_MESSAGE, undefined));
		assertTrue (failMessage(5 ), assertNotEmpty(NOT_FAIL_MESSAGE, 3));
		assertTrue (failMessage(6 ), assertNotEmpty(FAIL_MESSAGE));
		assertTrue (failMessage(7 ), assertNotEmpty(2));
		assertFalse(failMessage(8 ), assertNotEmpty());
	}
	
	public function testThrows(Void):Void {
		// All tests with a example exception
		assertTrue (failMessage(1 ), assertThrows(NOT_FAIL_MESSAGE, IllegalArgumentException, this, "throwIllegalArgumentException", []));
		assertTrue (failMessage(2 ), assertThrows(NOT_FAIL_MESSAGE, IllegalArgumentException, this, throwIllegalArgumentException, []));
		assertTrue (failMessage(3 ), assertThrows(NOT_FAIL_MESSAGE, IllegalArgumentException, new Call(this, throwIllegalArgumentException), []));
		assertTrue (failMessage(4 ), assertThrows(IllegalArgumentException, this, "throwIllegalArgumentException", []));
		assertTrue (failMessage(5 ), assertThrows(IllegalArgumentException, this, throwIllegalArgumentException, []));
		assertTrue (failMessage(6 ), assertThrows(IllegalArgumentException, new Call(this, throwIllegalArgumentException), []));
		
		// Tests with an interface
		assertTrue (failMessage(7 ), assertThrows(NOT_FAIL_MESSAGE, Throwable, this, "throwIllegalArgumentException", []));
		assertTrue (failMessage(8 ), assertThrows(NOT_FAIL_MESSAGE, Throwable, this, throwIllegalArgumentException, []));
		assertTrue (failMessage(9 ), assertThrows(NOT_FAIL_MESSAGE, Throwable, new Call(this, throwIllegalArgumentException), []));
		assertTrue (failMessage(10), assertThrows(Throwable, this, "throwIllegalArgumentException", []));
		assertTrue (failMessage(11), assertThrows(Throwable, this, throwIllegalArgumentException, []));
		assertTrue (failMessage(12), assertThrows(Throwable, new Call(this, throwIllegalArgumentException), []));
		
		// Additional Tests
		assertFalse(failMessage(13), assertThrows(FAIL_MESSAGE, Throwable, this, throwNothing, []));
		assertTrue (failMessage(14), assertThrows(FAIL_MESSAGE, Throwable, this, throwSomethingByNoParams, []));
		assertFalse(failMessage(15), assertThrows(FAIL_MESSAGE, Throwable, this, throwSomethingByNoParams, [{a:""},"b"]));
		assertFalse(failMessage(16), assertThrows(FAIL_MESSAGE, Throwable, this, "here", []))
		assertFalse(failMessage(17), assertThrows(FAIL_MESSAGE, String, this, throwIllegalArgumentException, []))
		
		// Tests without Type
		assertTrue (failMessage(18), assertThrows(NOT_FAIL_MESSAGE, this, "throwIllegalArgumentException", []));
		assertTrue (failMessage(19), assertThrows(NOT_FAIL_MESSAGE, this, throwIllegalArgumentException, []));
		assertTrue (failMessage(20), assertThrows(NOT_FAIL_MESSAGE, new Call(this, throwIllegalArgumentException), []));
		assertTrue (failMessage(21), assertThrows(this, "throwIllegalArgumentException", []));
		assertTrue (failMessage(22), assertThrows(this, throwIllegalArgumentException, []));
		assertTrue (failMessage(23), assertThrows(new Call(this, throwIllegalArgumentException), []));
	}
	
	public function testNotThrows(Void):Void {
		// All tests with a example exception
		assertTrue (failMessage(1 ), assertNotThrows(NOT_FAIL_MESSAGE, IllegalArgumentException, this, "throwNothing", []));
		assertTrue (failMessage(2 ), assertNotThrows(NOT_FAIL_MESSAGE, IllegalArgumentException, this, throwNothing, []));
		assertTrue (failMessage(3 ), assertNotThrows(NOT_FAIL_MESSAGE, IllegalArgumentException, new Call(this, throwNothing), []));
		assertTrue (failMessage(4 ), assertNotThrows(IllegalArgumentException, this, "throwNothing", []));
		assertTrue (failMessage(5 ), assertNotThrows(IllegalArgumentException, this, throwNothing, []));
		assertTrue (failMessage(6 ), assertNotThrows(IllegalArgumentException, new Call(this, throwNothing), []));
		
		// Tests with an interface
		assertFalse(failMessage(7 ), assertNotThrows(FAIL_MESSAGE, Throwable, this, "throwIllegalArgumentException", []));
		assertFalse(failMessage(8 ), assertNotThrows(FAIL_MESSAGE, Throwable, this, throwIllegalArgumentException, []));
		assertFalse(failMessage(9 ), assertNotThrows(FAIL_MESSAGE, Throwable, new Call(this, throwIllegalArgumentException), []));
		assertFalse(failMessage(10), assertNotThrows(Throwable, this, "throwIllegalArgumentException", []));
		assertFalse(failMessage(11), assertNotThrows(Throwable, this, throwIllegalArgumentException, []));
		assertFalse(failMessage(12), assertNotThrows(Throwable, new Call(this, throwIllegalArgumentException), []));
		
		// Additional Tests
		assertTrue (failMessage(13), assertNotThrows(NOT_FAIL_MESSAGE, Throwable, this, throwNothing, []));
		assertFalse(failMessage(14), assertNotThrows(FAIL_MESSAGE, Throwable, this, throwSomethingByNoParams, []));
		assertTrue (failMessage(15), assertNotThrows(NOT_FAIL_MESSAGE, Throwable, this, throwSomethingByNoParams, [{a:""},"b"]));
		assertFalse(failMessage(16), assertNotThrows(FAIL_MESSAGE, Throwable, this, "here", []))
		assertTrue (failMessage(17), assertNotThrows(FAIL_MESSAGE, String, this, throwIllegalArgumentException, []))
		
		// Tests without Type
		assertFalse(failMessage(18), assertNotThrows(FAIL_MESSAGE, this, "throwIllegalArgumentException", []));
		assertFalse(failMessage(19), assertNotThrows(FAIL_MESSAGE, this, throwIllegalArgumentException, []));
		assertFalse(failMessage(20), assertNotThrows(FAIL_MESSAGE, new Call(this, throwIllegalArgumentException), []));
		assertFalse(failMessage(21), assertNotThrows(this, "throwIllegalArgumentException", []));
		assertFalse(failMessage(22), assertNotThrows(this, throwIllegalArgumentException, []));
		assertFalse(failMessage(23), assertNotThrows(new Call(this, throwIllegalArgumentException), []));
	}
	
	public function testTypeOf(Void):Void {
		// Tests with correct Types
		assertTrue (failMessage(1 ), assertTypeOf("String", ObjectUtil.TYPE_STRING));
		assertTrue (failMessage(2 ), assertTypeOf(NOT_FAIL_MESSAGE, "String", ObjectUtil.TYPE_STRING));
		assertTrue (failMessage(3 ), assertTypeOf([], ObjectUtil.TYPE_OBJECT));
		assertTrue (failMessage(4 ), assertTypeOf(NOT_FAIL_MESSAGE, [], ObjectUtil.TYPE_OBJECT));
		assertTrue (failMessage(5 ), assertTypeOf({}, ObjectUtil.TYPE_OBJECT));
		assertTrue (failMessage(6 ), assertTypeOf(NOT_FAIL_MESSAGE, {}, ObjectUtil.TYPE_OBJECT));
		assertTrue (failMessage(7 ), assertTypeOf(_root, ObjectUtil.TYPE_MOVIECLIP));
		assertTrue (failMessage(8 ), assertTypeOf(NOT_FAIL_MESSAGE, _root, ObjectUtil.TYPE_MOVIECLIP));
		assertTrue (failMessage(9 ), assertTypeOf(-1, ObjectUtil.TYPE_NUMBER));
		assertTrue (failMessage(10), assertTypeOf(NOT_FAIL_MESSAGE, -1, ObjectUtil.TYPE_NUMBER));
		assertTrue (failMessage(11), assertTypeOf(true, ObjectUtil.TYPE_BOOLEAN));
		assertTrue (failMessage(12), assertTypeOf(NOT_FAIL_MESSAGE, true, ObjectUtil.TYPE_BOOLEAN));
		assertTrue (failMessage(13), assertTypeOf(null, ObjectUtil.TYPE_NULL));
		assertTrue (failMessage(14), assertTypeOf(NOT_FAIL_MESSAGE, null, ObjectUtil.TYPE_NULL));
		assertTrue (failMessage(15), assertTypeOf(undefined, ObjectUtil.TYPE_UNDEFINED));
		assertTrue (failMessage(16), assertTypeOf(NOT_FAIL_MESSAGE, undefined, ObjectUtil.TYPE_UNDEFINED));
		
		// Tests with incorrect Types
		assertFalse(failMessage(1 ), assertTypeOf("String", ObjectUtil.TYPE_NUMBER));
		assertFalse(failMessage(2 ), assertTypeOf(FAIL_MESSAGE, "String", ObjectUtil.TYPE_NUMBER));
		assertFalse(failMessage(3 ), assertTypeOf([], ObjectUtil.TYPE_STRING));
		assertFalse(failMessage(4 ), assertTypeOf(FAIL_MESSAGE, [], ObjectUtil.TYPE_STRING));
		assertFalse(failMessage(5 ), assertTypeOf({}, ObjectUtil.TYPE_MOVIECLIP));
		assertFalse(failMessage(6 ), assertTypeOf(FAIL_MESSAGE, {}, ObjectUtil.TYPE_MOVIECLIP));
		assertFalse(failMessage(7 ), assertTypeOf(_root, ObjectUtil.TYPE_OBJECT));
		assertFalse(failMessage(8 ), assertTypeOf(FAIL_MESSAGE, _root, ObjectUtil.TYPE_OBJECT));
		assertFalse(failMessage(9 ), assertTypeOf(-1, ObjectUtil.TYPE_UNDEFINED));
		assertFalse(failMessage(10), assertTypeOf(FAIL_MESSAGE, -1, ObjectUtil.TYPE_UNDEFINED));
		assertFalse(failMessage(11), assertTypeOf(true, ObjectUtil.TYPE_OBJECT));
		assertFalse(failMessage(12), assertTypeOf(FAIL_MESSAGE, true, ObjectUtil.TYPE_OBJECT));
		assertFalse(failMessage(13), assertTypeOf(null, ObjectUtil.TYPE_NUMBER));
		assertFalse(failMessage(14), assertTypeOf(FAIL_MESSAGE, null, ObjectUtil.TYPE_NUMBER));
		assertFalse(failMessage(15), assertTypeOf(undefined, ObjectUtil.TYPE_NUMBER));
		assertFalse(failMessage(16), assertTypeOf(FAIL_MESSAGE, undefined, ObjectUtil.TYPE_NUMBER));
	}
	
	public function testInstanceOf(Void):Void {
		assertTrue (failMessage(1 ), assertInstanceOf("hase", String));
		assertTrue (failMessage(2 ), assertInstanceOf(NOT_FAIL_MESSAGE, "hase", Object));
		assertTrue (failMessage(3 ), assertInstanceOf(NOT_FAIL_MESSAGE, {}, Object));
		assertTrue (failMessage(4 ), assertInstanceOf(NOT_FAIL_MESSAGE, 1, Object));
		assertTrue (failMessage(5 ), assertInstanceOf(NOT_FAIL_MESSAGE, null, Object));
		assertTrue (failMessage(6 ), assertInstanceOf(NOT_FAIL_MESSAGE, undefined, Object));
		assertFalse(failMessage(7 ), assertInstanceOf("hase", Number));
		assertFalse(failMessage(8 ), assertInstanceOf({}, Number));
	}
	
	/**
	 * Helper method for testThrows
	 */
	public function throwNothing(Void):Void {
	}
	
	/**
	 * Helper method for testThrows
	 */
	public function throwSomethingByNoParams(a:Object, b:String):Void {
		if(!a || !b) {
			throw new IllegalArgumentException("A or B not provided", this, arguments);
		}
	}
	
	/**
	 * Helper method for testThrows
	 */
	public function throwIllegalArgumentException(Void):Void {
		throw new IllegalArgumentException("Simply thrown.", this, arguments);
	}
	
	/**
	 * Tears down the application. Usually outcomment.
	 */
    public function tearDown(Void):Void {
		// Strings thrown to evaluate how it acts with unexcepted Exceptiontypes.
		//throw "My Error @ tear down";
    }
 }