import org.as2lib.test.unit.TestCase;
import org.as2lib.util.ArrayUtil;
import org.as2lib.env.except.IllegalArgumentException;
/**
 * 
 */
class test.unit.org.as2lib.util.TArrayUtil extends TestCase {
	public function testIndexOf() {
		var test:Array = [1,2,3,4,5,6,7,8,9,10];
		assertEquals("Wrong Content at the found Index", test[ArrayUtil.indexOf(test, 5)], 5);
		assertEquals("Wrong Index found", ArrayUtil.indexOf(test, 5), 4);
	}
}