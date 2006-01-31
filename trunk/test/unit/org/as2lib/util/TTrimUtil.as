import org.as2lib.test.unit.TestCase;
import org.as2lib.util.TrimUtil;

/**
 * @author HeideggerMartin
 */
class org.as2lib.util.TTrimUtil extends TestCase {
	private function testTrim(Void):Void {
		assertEquals("Content: Empty", TrimUtil.trim(""), "");
		assertEquals("Content: hallo", TrimUtil.trim("hallo"), "hallo");
		assertEquals("Content:  h a ll o ", TrimUtil.trim(" h a llo "), "h a llo");
		assertEquals("Content: \\n\\thallo", TrimUtil.trim("\n\thallo\n\t"), "hallo");
	}
	private function testRightTrim (Void):Void {
		assertUndefined("Content: Undefined", TrimUtil.rightTrim(undefined));
		assertEquals("Content: Empty", TrimUtil.rightTrim(""), "");
		assertEquals("Content: hallo", TrimUtil.rightTrim("hallo"), "hallo");
		assertEquals("Content:  h a ll o ", TrimUtil.rightTrim(" h a llo  "), " h a llo");
		assertEquals("Content: \\n\\thallo\\n\\t", TrimUtil.rightTrim("\n\thallo\n\t"), "\n\thallo");
	}
	private function testLeftTrim (Void):Void {
		assertUndefined("Content: Undefined", TrimUtil.leftTrim(undefined));
		assertEquals("Content: Empty", TrimUtil.leftTrim(""), "");
		assertEquals("Content: hallo", TrimUtil.leftTrim("hallo"), "hallo");
		assertEquals("Content:   h a ll o ", TrimUtil.leftTrim("  h a ll o "), "h a ll o ");
		assertEquals("Content: \\n\\thallo", TrimUtil.leftTrim("\n\thallo"), "hallo");
	}
}