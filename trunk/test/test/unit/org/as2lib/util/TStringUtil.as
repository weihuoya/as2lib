import org.as2lib.test.unit.TestCase;
import org.as2lib.util.StringUtil;
import org.as2lib.env.except.IllegalArgumentException;
/**
 * 
 */
class test.unit.org.as2lib.util.TStringUtil extends TestCase {
	
	private function testReplace (Void):Void {
		assertUndefined("Replace of nothing", StringUtil.replace(undefined, "as", "da"));
		assertEquals("Replace from something not available", StringUtil.replace("hallo", "j", "a"), "hallo");
		assertEquals("Simple Replace", StringUtil.replace("hilli", "l", "i"), "hiiii");
		assertEquals("Replace from more chars", StringUtil.replace("hollallallajdkalalasjfella", "lla", "*"), "ho***jdkalalasjfe*");
	}
	
	private function testTrim(Void):Void {
		assertEquals("Content: Empty", StringUtil.trim(""), "");
		assertEquals("Content: hallo", StringUtil.trim("hallo"), "hallo");
		assertEquals("Content:  h a ll o ", StringUtil.trim(" h a llo "), "h a llo");
		assertEquals("Content: \\n\\thallo", StringUtil.trim("\n\thallo\n\t"), "hallo");
	}
	private function testRightTrim (Void):Void {
		assertUndefined("Content: Undefined", StringUtil.rightTrim(undefined));
		assertEquals("Content: Empty", StringUtil.rightTrim(""), "");
		assertEquals("Content: hallo", StringUtil.rightTrim("hallo"), "hallo");
		assertEquals("Content:  h a ll o ", StringUtil.rightTrim(" h a llo  "), " h a llo");
		assertEquals("Content: \\n\\thallo\\n\\t", StringUtil.rightTrim("\n\thallo\n\t"), "\n\thallo");
	}
	
	private function testLeftTrim (Void):Void {
		assertUndefined("Content: Undefined", StringUtil.leftTrim(undefined));
		assertEquals("Content: Empty", StringUtil.leftTrim(""), "");
		assertEquals("Content: hallo", StringUtil.leftTrim("hallo"), "hallo");
		assertEquals("Content:   h a ll o ", StringUtil.leftTrim("  h a ll o "), "h a ll o ");
		assertEquals("Content: \\n\\thallo", StringUtil.leftTrim("\n\thallo"), "hallo");
	}
	
	private function testCheckEmail (Void):Void {
		assertFalse("Content: Undefined", StringUtil.checkEmail(undefined));
		assertFalse("Content: null", StringUtil.checkEmail(undefined));
		assertFalse("Content: hallo", StringUtil.checkEmail("hallo"));
		assertFalse("Content: hallo.", StringUtil.checkEmail("hallo."));
		assertFalse("Content: hallo.co", StringUtil.checkEmail("hallo.co"));
		assertFalse("Content: hallo@", StringUtil.checkEmail("hallo@"));
		assertFalse("Content: hallo@.com", StringUtil.checkEmail("hallo@.com"));
		assertFalse("Content: @.com", StringUtil.checkEmail("@.com"));
		assertFalse("Content: h@hase.c", StringUtil.checkEmail("h@hase.c"));
		assertFalse("Content: ha@.chh@hase.c", StringUtil.checkEmail("ha@.chh@hase.c"));
		assertFalse("Content: h@hase.c", StringUtil.checkEmail("h@hase.c"));
		assertFalse("Content: ha@.chh@hase.c", StringUtil.checkEmail("ha@.chh@hase.c"));
		assertTrue("Content: ha@c.com", StringUtil.checkEmail("ha@c.com"));
		assertTrue("Content: h.gah@hase.com", StringUtil.checkEmail("h.gah@hase.com"));
		assertTrue("Content: hase@hase.com", StringUtil.checkEmail("hase@hase.com"));
		assertTrue("Content: h.gah@hase.com", StringUtil.checkEmail("h.gah@hase.com"));
	}
	
	private function testCheckLength (Void):Void {
		assertThrows(IllegalArgumentException, StringUtil, "assureLength", [undefined,undefined]);
		assertThrows(IllegalArgumentException, StringUtil, "assureLength", ['',undefined]);
		assertTrue("Content: ''/0", StringUtil.assureLength('',0));
		assertFalse("Content: 'ha'/3", StringUtil.assureLength('ha',3));
		assertTrue("Content: 'hase'/3", StringUtil.assureLength('hase',3));
		assertTrue("Content: 'hase'/4", StringUtil.assureLength('hase',4));
		assertThrows(IllegalArgumentException, StringUtil, "assureLength", ['hase', 0]);
	}
	
	private function testContains (Void):Void {
	}
}