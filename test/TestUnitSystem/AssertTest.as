import org.as2lib.test.unit.TestCase;

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
	}
	
	public function testNotNull(Void):Void {
		assertFalse("NOT FAIL! 1 ", assertNotNull(null));
		assertTrue ("NOT FAIL! 2 ", assertNotNull(undefined));
		assertFalse("NOT FAIL! 3 ", assertNotNull("fail", null));
		assertTrue ("NOT FAIL! 4 ", assertNotNull("NOT FAIL!", undefined));
		assertTrue ("NOT FAIL! 5 ", assertNotNull("NOT FAIL!", 0));
		assertTrue ("NOT FAIL! 6 ", assertNotNull("NOT FAIL!", undefined));
	}
	
	public function testUndefined(Void):Void {
	}
	
	public function testNotUndefined(Void):Void {
	}

	public function testInfinity(Void):Void {
	}
	
	public function testNotInfinity(Void):Void {
	}
	
	public function testEmpty(Void):Void {
	}
	
	public function testNotEmpty(Void):Void {
	}
	
	public function testThrows(Void):Void {
	}
	
	public function testNotThrows(Void):Void {
	}
	
    public function tearDown(Void):Void {
		// Strings thrown to evaluate how it acts with unexcepted Exceptiontypes.
		//throw "My Error @ tear down";
    }
 }