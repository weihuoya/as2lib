import org.as2lib.test.unit.Test;
import org.as2lib.util.StringUtil;
import org.as2lib.env.except.IllegalArgumentException;
/**
 * 
 */
class test.org.as2lib.util.TStringUtil extends Test {
	
	private function testReplace (Void):Void {
		assertUndefinedWithMessage("Replace of nothing", StringUtil.replace(undefined, "as", "da"));
		assertEqualsWithMessage("Replace from something not available", StringUtil.replace("hallo", "j", "a"), "hallo");
		assertEqualsWithMessage("Simple Replace", StringUtil.replace("hilli", "l", "i"), "hiiii");
		assertEqualsWithMessage("Replace from more chars", StringUtil.replace("hollallallajdkalalasjfella", "lla", "*"), "ho***jdkalalasjfe*");
	}
	
	private function testTrim(Void):Void {
		assertEqualsWithMessage("Content: Empty", StringUtil.trim(""), "");
		assertEqualsWithMessage("Content: hallo", StringUtil.trim("hallo"), "hallo");
		assertEqualsWithMessage("Content:  h a ll o ", StringUtil.trim(" h a llo "), "h a llo");
		assertEqualsWithMessage("Content: \\n\\thallo", StringUtil.trim("\n\thallo\n\t"), "hallo");
	}
	private function testRightTrim (Void):Void {
		assertUndefinedWithMessage("Content: Undefined", StringUtil.rightTrim(undefined));
		assertEqualsWithMessage("Content: Empty", StringUtil.rightTrim(""), "");
		assertEqualsWithMessage("Content: hallo", StringUtil.rightTrim("hallo"), "hallo");
		assertEqualsWithMessage("Content:  h a ll o ", StringUtil.rightTrim(" h a llo  "), " h a llo");
		assertEqualsWithMessage("Content: \\n\\thallo\\n\\t", StringUtil.rightTrim("\n\thallo\n\t"), "\n\thallo");
	}
	
	private function testLeftTrim (Void):Void {
		assertUndefinedWithMessage("Content: Undefined", StringUtil.leftTrim(undefined));
		assertEqualsWithMessage("Content: Empty", StringUtil.leftTrim(""), "");
		assertEqualsWithMessage("Content: hallo", StringUtil.leftTrim("hallo"), "hallo");
		assertEqualsWithMessage("Content:   h a ll o ", StringUtil.leftTrim("  h a ll o "), "h a ll o ");
		assertEqualsWithMessage("Content: \\n\\thallo", StringUtil.leftTrim("\n\thallo"), "hallo");
	}
	
	private function testCheckEmail (Void):Void {
		assertFalseWithMessage("Content: Undefined", StringUtil.checkEmail(undefined));
		assertFalseWithMessage("Content: null", StringUtil.checkEmail(undefined));
		assertFalseWithMessage("Content: hallo", StringUtil.checkEmail("hallo"));
		assertFalseWithMessage("Content: hallo.", StringUtil.checkEmail("hallo."));
		assertFalseWithMessage("Content: hallo.co", StringUtil.checkEmail("hallo.co"));
		assertFalseWithMessage("Content: hallo@", StringUtil.checkEmail("hallo@"));
		assertFalseWithMessage("Content: hallo@.com", StringUtil.checkEmail("hallo@.com"));
		assertFalseWithMessage("Content: @.com", StringUtil.checkEmail("@.com"));
		assertFalseWithMessage("Content: h@hase.c", StringUtil.checkEmail("h@hase.c"));
		assertFalseWithMessage("Content: ha@.chh@hase.c", StringUtil.checkEmail("ha@.chh@hase.c"));
		assertFalseWithMessage("Content: h@hase.c", StringUtil.checkEmail("h@hase.c"));
		assertFalseWithMessage("Content: ha@.chh@hase.c", StringUtil.checkEmail("ha@.chh@hase.c"));
		assertTrueWithMessage("Content: ha@c.com", StringUtil.checkEmail("ha@c.com"));
		assertTrueWithMessage("Content: h.gah@hase.com", StringUtil.checkEmail("h.gah@hase.com"));
		assertTrueWithMessage("Content: hase@hase.com", StringUtil.checkEmail("hase@hase.com"));
		assertTrueWithMessage("Content: h.gah@hase.com", StringUtil.checkEmail("h.gah@hase.com"));
	}
	
	private function testCheckLength (Void):Void {
		assertFalseWithMessage("Content: undefined/undefined", StringUtil.assureLength(undefined,undefined));
		assertFalseWithMessage("Content: ''/undefined", StringUtil.assureLength('',undefined));
		assertFalseWithMessage("Content: ''/0", StringUtil.assureLength('',0));
		assertFalseWithMessage("Content: 'ha'/3", StringUtil.assureLength('ha',3));
		assertTrueWithMessage("Content: 'hase'/3", StringUtil.assureLength('hase',3));
		assertTrueWithMessage("Content: 'hase'/4", StringUtil.assureLength('hase',4));
		assertThrows(IllegalArgumentException, StringUtil, "assureLength", ['hase', 0]);
	}
	
	private function testContains (Void):Void {
	}
}