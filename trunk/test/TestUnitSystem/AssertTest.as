﻿/**
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
    public function AssertTest(Void) {
		// Only for a test
		// Strings thrown to evaluate how it acts with unexcepted Exceptiontypes.
		// throw "My Error @ constructor";
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
		fail("fail");
		fail();
	}
	
	public function testTrue(Void):Void {
		assertFalse("NOT Fail! 1 ", assertTrue(false));
		assertFalse("NOT Fail! 2 ", assertTrue("fail", false));
		assertFalse("NOT Fail! 3 ", assertTrue());
		assertTrue ("NOT Fail! 4 ", assertTrue("NOT FAIL!", true));
		assertTrue ("NOT Fail! 5 ", assertTrue(true));
	}
	
    public function testFalse(Void):Void {
		assertFalse("NOT FAIL! 1 ", assertFalse(true));
		assertFalse("NOT FAIL! 2 ", assertFalse("fail", true));
		assertFalse("NOT FAIL! 3 ", assertFalse());
		assertTrue ("NOT FAIL! 4 ", assertFalse("NOT FAIL!", false));
		assertTrue ("NOT FAIL! 5 ", assertFalse(false));
	}
	
	public function testEquals(Void):Void {
		assertTrue ("NOT FAIL! 1 ", assertEquals("NOTFAIL!", undefined, undefined));
		assertTrue ("NOT FAIL! 2 ", assertEquals("NOTFAIL!", undefined, null));
		assertFalse("NOT FAIL! 3 ", assertEquals("fail", undefined, 1));
		assertTrue ("NOT FAIL! 4 ", assertEquals("NOTFAIL!", null, undefined));
		assertFalse("NOT FAIL! 5 ", assertEquals("fail", 1, undefined));
		assertTrue ("NOT FAIL! 6 ", assertEquals("NOTFAIL!", undefined));
		assertFalse("NOT FAIL! 7 ", assertEquals("fail", 1, 2));
		assertTrue ("NOT FAIL! 8 ", assertEquals("NOTFAIL!", 1, 1));
		assertFalse("NOT FAIL! 9 ", assertEquals("fail", 1));
		assertTrue ("NOT FAIL! 10", assertEquals("NOTFAIL!", null));
		assertTrue ("NOT FAIL! 11", assertEquals(undefined, undefined));
		assertTrue ("NOT FAIL! 12", assertEquals(undefined, null));
		assertFalse("NOT FAIL! 13", assertEquals(undefined, 1));
		assertTrue ("NOT FAIL! 14", assertEquals(undefined));
		assertTrue ("NOT FAIL! 15", assertEquals(null, null));
		assertTrue ("NOT FAIL! 16", assertEquals(null));
		assertTrue ("NOT FAIL! 17", assertEquals(1, 1));
		assertFalse("NOT FAIL! 18", assertEquals(1));
		assertTrue ("NOT FAIL! 19", assertEquals());
	}
	
	public function testNotEquals(Void):Void {
		assertFalse("NOT FAIL! 1 ", assertNotEquals("fail", undefined, undefined));
		assertFalse("NOT FAIL! 2 ", assertNotEquals("fail", undefined, null));
		assertTrue ("NOT FAIL! 3 ", assertNotEquals("NOTFAIL!", undefined, 1));
		assertFalse("NOT FAIL! 4 ", assertNotEquals("fail", null, undefined));
		assertTrue ("NOT FAIL! 5 ", assertNotEquals("NOTFAIL!", 1, undefined));
		assertFalse("NOT FAIL! 6 ", assertNotEquals("fail", undefined));
		assertTrue ("NOT FAIL! 7 ", assertNotEquals("NOTFAIL!", 1, 2));
		assertFalse("NOT FAIL! 8 ", assertNotEquals("fail", 1, 1));
		assertTrue ("NOT FAIL! 9 ", assertNotEquals("NOTFAIL!", 1));
		assertFalse("NOT FAIL! 10", assertNotEquals("fail", null));
		assertFalse("NOT FAIL! 11", assertNotEquals(undefined, undefined));
		assertFalse("NOT FAIL! 12", assertNotEquals(undefined, null));
		assertTrue ("NOT FAIL! 13", assertNotEquals(undefined, 1));
		assertFalse("NOT FAIL! 14", assertNotEquals(undefined));
		assertFalse("NOT FAIL! 15", assertNotEquals(null, null));
		assertFalse("NOT FAIL! 16", assertNotEquals(null));
		assertFalse("NOT FAIL! 17", assertNotEquals(1, 1));
		assertTrue ("NOT FAIL! 18", assertNotEquals(1));
		assertFalse("NOT FAIL! 19", assertNotEquals());
	}
	
	public function testSame(Void):Void {
		assertTrue ("NOT FAIL! 1 ", assertSame("NOTFAIL!", undefined, undefined));
		assertFalse("NOT FAIL! 2 ", assertSame("fail", undefined, null));
		assertFalse("NOT FAIL! 3 ", assertSame("fail", undefined, 1));
		assertFalse("NOT FAIL! 4 ", assertSame("fail", null, undefined));
		assertFalse("NOT FAIL! 5 ", assertSame("fail", 1, undefined));
		assertTrue ("NOT FAIL! 6 ", assertSame("fail", undefined));
		assertFalse("NOT FAIL! 7 ", assertSame("fail", 1, 2));
		assertTrue ("NOT FAIL! 8 ", assertSame("NOTFAIL!", 1, 1));
		assertFalse("NOT FAIL! 9 ", assertSame("fail", 1));
		assertFalse("NOT FAIL! 10", assertSame("fail", null));
		assertTrue ("NOT FAIL! 11", assertSame(undefined, undefined));
		assertFalse("NOT FAIL! 12", assertSame(undefined, null));
		assertFalse("NOT FAIL! 13", assertSame(undefined, 1));
		assertTrue ("NOT FAIL! 14", assertSame(undefined));
		assertTrue ("NOT FAIL! 15", assertSame(null, null));
		assertFalse("NOT FAIL! 16", assertSame(null));
		assertTrue ("NOT FAIL! 17", assertSame(1, 1));
		assertFalse("NOT FAIL! 18", assertSame(1));
		assertTrue ("NOT FAIL! 19", assertSame());
	}
	
	public function testNotSame(Void):Void {
		assertFalse("NOT FAIL! 1 ", assertNotSame("fail", undefined, undefined));
		assertTrue ("NOT FAIL! 2 ", assertNotSame("NOTFAIL!", undefined, null));
		assertTrue ("NOT FAIL! 3 ", assertNotSame("NOTFAIL!", undefined, 1));
		assertTrue ("NOT FAIL! 4 ", assertNotSame("NOTFAIL!", null, undefined));
		assertTrue ("NOT FAIL! 5 ", assertNotSame("NOTFAIL!", 1, undefined));
		assertFalse("NOT FAIL! 6 ", assertNotSame("fail", undefined));
		assertTrue ("NOT FAIL! 7 ", assertNotSame("NOTFAIL!", 1, 2));
		assertFalse("NOT FAIL! 8 ", assertNotSame("fail", 1, 1));
		assertTrue ("NOT FAIL! 9 ", assertNotSame("NOTFAIL!", 1));
		assertTrue ("NOT FAIL! 10", assertNotSame("NOTFAIL!", null));
		assertFalse("NOT FAIL! 11", assertNotSame(undefined, undefined));
		assertTrue ("NOT FAIL! 12", assertNotSame(undefined, null));
		assertTrue ("NOT FAIL! 13", assertNotSame(undefined, 1));
		assertFalse("NOT FAIL! 14", assertNotSame(undefined));
		assertFalse("NOT FAIL! 15", assertNotSame(null, null));
		assertTrue ("NOT FAIL! 16", assertNotSame(null));
		assertFalse("NOT FAIL! 17", assertNotSame(1, 1));
		assertTrue ("NOT FAIL! 18", assertNotSame(1));
		assertFalse("NOT FAIL! 19", assertNotSame());
	}
	
	public function testNull(Void):Void {
		assertTrue ("NOT FAIL! 1 ", assertNull(null));
		assertFalse("NOT FAIL! 2 ", assertNull(undefined));
		assertTrue ("NOT FAIL! 3 ", assertNull("NOT FAIL!", null));
		assertFalse("NOT FAIL! 4 ", assertNull("fail", undefined));
		assertFalse("NOT FAIL! 5 ", assertNull("fail", 3));
		assertFalse("NOT FAIL! 6 ", assertNull("fail", undefined));
		assertFalse("NOT FAIL! 7 ", assertNull("fail"));
		assertFalse("NOT FAIL! 8 ", assertNull(2));
		assertFalse("NOT FAIL! 9 ", assertNull());
	}
	
	public function testNotNull(Void):Void {
		assertFalse("NOT FAIL! 1 ", assertNotNull(null));
		assertTrue ("NOT FAIL! 2 ", assertNotNull(undefined));
		assertFalse("NOT FAIL! 3 ", assertNotNull("fail", null));
		assertTrue ("NOT FAIL! 4 ", assertNotNull("NOT FAIL!", undefined));
		assertTrue ("NOT FAIL! 5 ", assertNotNull("NOT FAIL!", 0));
		assertTrue ("NOT FAIL! 6 ", assertNotNull("fail"));
		assertTrue ("NOT FAIL! 7 ", assertNotNull(2));
		assertTrue ("NOT FAIL! 8 ", assertNotNull());
	}
	
	public function testUndefined(Void):Void {
		assertFalse("NOT FAIL! 1 ", assertUndefined(null));
		assertTrue ("NOT FAIL! 2 ", assertUndefined(undefined));
		assertFalse("NOT FAIL! 3 ", assertUndefined("fail", null));
		assertTrue ("NOT FAIL! 4 ", assertUndefined("NOT FAIL!", undefined));
		assertFalse("NOT FAIL! 5 ", assertUndefined("fail", 3));
		assertFalse("NOT FAIL! 6 ", assertUndefined("fail"));
		assertFalse("NOT FAIL! 7 ", assertUndefined(2));
		assertTrue ("NOT FAIL! 8 ", assertUndefined());
	}
	
	public function testNotUndefined(Void):Void {
		assertTrue ("NOT FAIL! 1 ", assertNotUndefined(null));
		assertFalse("NOT FAIL! 2 ", assertNotUndefined(undefined));
		assertTrue ("NOT FAIL! 3 ", assertNotUndefined("NOT FAIL!", null));
		assertFalse("NOT FAIL! 4 ", assertNotUndefined("fail", undefined));
		assertTrue ("NOT FAIL! 5 ", assertNotUndefined("NOT FAIL!", 3));
		assertTrue ("NOT FAIL! 6 ", assertNotUndefined("NOT FAIL!"));
		assertTrue ("NOT FAIL! 7 ", assertNotUndefined(2));
		assertFalse("NOT FAIL! 8 ", assertNotUndefined());
	}

	public function testInfinity(Void):Void {
		assertTrue ("NOT FAIL! 1 ", assertInfinity("NOT FAIL!", Infinity));
		assertFalse("NOT FAIL! 2 ", assertInfinity("fail", 1000000000));
		assertFalse("NOT FAIL! 3 ", assertInfinity("fail", 1));
		assertFalse("NOT FAIL! 4 ", assertInfinity("fail", undefined));
		assertFalse("NOT FAIL! 5 ", assertInfinity("fail"));
		assertTrue ("NOT FAIL! 6 ", assertInfinity(Infinity));
		assertFalse("NOT FAIL! 7 ", assertInfinity(1));
		assertFalse("NOT FAIL! 8 ", assertInfinity());
	}
	
	public function testNotInfinity(Void):Void {
		assertFalse("NOT FAIL! 1 ", assertNotInfinity("fail", Infinity));
		assertTrue ("NOT FAIL! 2 ", assertNotInfinity("NOT FAIL!", 1000000000));
		assertTrue ("NOT FAIL! 3 ", assertNotInfinity("NOT FAIL!", 1));
		assertTrue ("NOT FAIL! 4 ", assertNotInfinity("NOT FAIL!", undefined));
		assertTrue ("NOT FAIL! 5 ", assertNotInfinity("NOT FAIL!"));
		assertFalse("NOT FAIL! 6 ", assertNotInfinity(Infinity));
		assertTrue ("NOT FAIL! 7 ", assertNotInfinity(1));
		assertTrue ("NOT FAIL! 8 ", assertNotInfinity());
	}
	
	public function testEmpty(Void):Void {
		assertTrue ("NOT FAIL! 1 ", assertEmpty(null));
		assertTrue ("NOT FAIL! 2 ", assertEmpty(undefined));
		assertTrue ("NOT FAIL! 3 ", assertEmpty("NOT FAIL!", null));
		assertTrue ("NOT FAIL! 4 ", assertEmpty("NOT FAIL!", undefined));
		assertFalse("NOT FAIL! 5 ", assertEmpty("fail", 3));
		assertFalse("NOT FAIL! 6 ", assertEmpty("fail"));
		assertFalse("NOT FAIL! 7 ", assertEmpty(2));
		assertTrue ("NOT FAIL! 8 ", assertEmpty());
	}
	
	public function testNotEmpty(Void):Void {
		assertFalse("NOT FAIL! 1 ", assertNotEmpty(null));
		assertFalse("NOT FAIL! 2 ", assertNotEmpty(undefined));
		assertFalse("NOT FAIL! 3 ", assertNotEmpty("fail", null));
		assertFalse("NOT FAIL! 4 ", assertNotEmpty("fail", undefined));
		assertTrue ("NOT FAIL! 5 ", assertNotEmpty("NOT FAIL!", 3));
		assertTrue ("NOT FAIL! 6 ", assertNotEmpty("fail"));
		assertTrue ("NOT FAIL! 7 ", assertNotEmpty(2));
		assertFalse("NOT FAIL! 8 ", assertNotEmpty());
	}
	
	public function testThrows(Void):Void {
		assertTrue ("NOT FAIL! 1 ", assertThrows("NOT FAIL!", IllegalArgumentException, "throwIllegalArgumentException", []));
		assertTrue ("NOT FAIL! 2 ", assertThrows("NOT FAIL!", IllegalArgumentException, throwIllegalArgumentException, []));
		assertTrue ("NOT FAIL! 3 ", assertThrows("NOT FAIL!", IllegalArgumentException, new Call(this, throwIllegalArgumentException), []));
		assertTrue ("NOT FAIL! 4 ", assertThrows(IllegalArgumentException, "throwIllegalArgumentException", []));
		assertTrue ("NOT FAIL! 5 ", assertThrows(IllegalArgumentException, throwIllegalArgumentException, []));
		assertTrue ("NOT FAIL! 6 ", assertThrows(IllegalArgumentException, new Call(this, throwIllegalArgumentException), []));
		
		assertTrue ("NOT FAIL! 7 ", assertThrows("NOT FAIL!", Throwable, "throwIllegalArgumentException", []));
		assertTrue ("NOT FAIL! 8 ", assertThrows("NOT FAIL!", Throwable, throwIllegalArgumentException, []));
		assertTrue ("NOT FAIL! 9 ", assertThrows("NOT FAIL!", Throwable, new Call(this, throwIllegalArgumentException), []));
		assertTrue ("NOT FAIL! 10", assertThrows(Throwable, "throwIllegalArgumentException", []));
		assertTrue ("NOT FAIL! 11", assertThrows(Throwable, throwIllegalArgumentException, []));
		assertTrue ("NOT FAIL! 12", assertThrows(Throwable, new Call(this, throwIllegalArgumentException), []));
		
		assertFalse("NOT FAIL! 13", assertThrows("fail", Throwable, throwNothing, []));
		assertTrue ("NOT FAIL! 14", assertThrows("fail", Throwable, throwSomethingByNoParams, []));
		assertFalse("NOT FAIL! 15", assertThrows("fail", Throwable, throwSomethingByNoParams, [{a:""},"b"]));
		assertFalse("NOT FAIL! 16", assertThrows("fail", Throwable, "here", []))
		assertFalse("NOT FAIL! 17", assertThrows("fail", String, throwIllegalArgumentException, []))
	}
	
	public function testNotThrows(Void):Void {
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