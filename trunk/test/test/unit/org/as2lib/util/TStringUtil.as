/*
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
import org.as2lib.util.StringUtil;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * Validates the most common use cases for the StringUtil.
 * 
 * @author Martin Heidegger
 * @author Christophe Herreman
 */
class test.unit.org.as2lib.util.TStringUtil extends TestCase {
	
	/**
	 * Uses Spaceindent with multi and single line contents and validates them.
	 */
	private function testAddSpaceIndent (Void):Void {		
		// Validating for different contents
		assertEquals("SpaceIndent added to nothing should be simply used", StringUtil.addSpaceIndent(null,2), "  ");
		assertEquals("SpaceIndent added to a empty string should be simply added", StringUtil.addSpaceIndent("",2), "  ");
		assertEquals("SpaceIndent added to ab should be used once", StringUtil.addSpaceIndent("ab",2), "  ab");
		assertEquals("SpaceIndent to multiple lines should be used for every line", StringUtil.addSpaceIndent("ab\nab", 2), "  ab\n  ab");
		
		// Validating for different lengths
		assertEquals("SpaceIndent of length 0 should be valid", StringUtil.addSpaceIndent("ab", 0), "ab");
		assertEquals("SpaceIndent of length 1 should be valid", StringUtil.addSpaceIndent("ab", 1), " ab");
		assertEquals("Multiline Spaceindent of length 1 should be valid", StringUtil.addSpaceIndent("ab\nab", 1), " ab\n ab");
		assertEquals("SpaceIndent of length 10 should be valid", StringUtil.addSpaceIndent("ab", 10), "          ab");
		assertThrows("SpaceIndent of length < 0 should throw a IllegalArgumentException", IllegalArgumentException, StringUtil, "addSpaceIndent", ["ab", -1]);
		assertEquals("Not given Spaceindent should be length of 0", StringUtil.addSpaceIndent("ab"), "ab");
	}
	
	/**
	 * assureLength for different cases.
	 */
	private function testAssureLength (Void):Void {
		assertThrows("Exception should be thrown if only the length is not available", IllegalArgumentException, StringUtil, "assureLength", ['',undefined]);
		assertTrue("Content: ''/0", StringUtil.assureLength('',0));
		assertFalse("Content: 'ha'/3", StringUtil.assureLength('ha',3));
		assertTrue("Content: 'hase'/3", StringUtil.assureLength('hase',3));
		assertTrue("Content: 'hase'/4", StringUtil.assureLength('hase',4));
		assertTrue("undefined/null should be length of 0", StringUtil.assureLength(undefined,0));
		assertThrows("Content: '', -1 should throw a exception because -1 is not wanted", IllegalArgumentException, StringUtil, "assureLength", ['', -1]);
	}
	
	/**
	 * Passes a lot of invalid and valid email adresse to the checkEmail method.
	 */
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
	
	/**
	 * Validates the documentation method and special cases.
	 */
	private function testContains (Void):Void {
		// Testing the cases of the documentation
		assertTrue("Content: 'monkey', 'kzj0'", StringUtil.contains("monkey", "kzj0"));
		assertTrue("Content: 'monkey', 'yek'", StringUtil.contains("monkey", "yek"));
		assertFalse("Content: 'monkey', 'a'", StringUtil.contains("monkey", "a"));
		
		// Testing of cases with special arguments
		assertFalse("Content: 'monkey', ''", StringUtil.contains("monkey", ''));
		assertFalse("Content: 'monkey', null", StringUtil.contains("monkey", null));
		assertFalse("Content: null, 'a'", StringUtil.contains(null, 'a'));
		assertFalse("Content: null, null", StringUtil.contains(null, null));
	}
	
	private function testEndsWith (Void):Void {
		assertTrue("Content: 'monkey', 'key'", StringUtil.endsWith('monkey', 'key'));
		assertFalse("Content: 'monkey', 'ke'", StringUtil.endsWith('monkey', 'ke'));
		assertFalse("Content: 'monkey', null", StringUtil.endsWith('monkey', null));
	}
	private function testReplace (Void):Void {
		assertUndefined("Replace of nothing", StringUtil.replace(undefined, "as", "da"));
		assertEquals("Replace of something that is not available", StringUtil.replace("hallo", "j", "a"), "hallo");
		assertEquals("Simple Replace", StringUtil.replace("hilli", "l", "i"), "hiiii");
		assertEquals("Replace of more chars", StringUtil.replace("hollallallajdkalalasjfella", "lla", "*"), "ho***jdkalalasjfe*");
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
	private function testUcFirst(Void):Void{
		assertEquals("Content: hello world", StringUtil.ucFirst("hello world"), "Hello world");
		assertEquals("Content: Hello world", StringUtil.ucFirst("Hello world"), "Hello world");
	}
	private function testUcWords(Void):Void{
		assertEquals("Content: hello world", StringUtil.ucWords("hello world"), "Hello World");
		assertEquals("Content: Hello world", StringUtil.ucWords("Hello world"), "Hello World");
	}
}