import org.as2lib.test.unit.TestCase;
import org.as2lib.lang.MessageFormat;

/**
 * @author HeideggerMartin
 */
class org.as2lib.lang.TMessageFormat extends TestCase {

	private var mF:MessageFormat;

	public function setUp() {
		mF = new MessageFormat();
	}

	public function testNormal() {
		assertEquals("Using null", mF.format(), "");
		assertEquals("Using undefined", mF.format(undefined), "");

		assertEquals("No special values", mF.format(null, "Hello this is Martin Heidegger"), "Hello this is Martin Heidegger");
		assertEquals("Using placeholder without argument", mF.format(null, "{0}"), "");
		assertEquals("Using no placeholder with argument", mF.format(["Martin"], ""), "");

		assertEquals("Using placeholder with integer argument", mF.format([1], "{0}"), "1");
		assertEquals("Using placeholder with floating point argument", mF.format([1.2345], "{0}"), "1.2345");
		assertEquals("Using placeholder with string argument", mF.format(["hello"], "{0}"), "hello");
		assertEquals("Using placeholder with boolean argument", mF.format([true], "{0}"), "true");
		assertEquals("Using placeholder with array argument", mF.format([[1,2,3]], "{0}"), "1,2,3");

		assertEquals("Using placehodler with in front text", mF.format(["Martin"], "Hello {0}"), "Hello Martin");
		assertEquals("Using placeholder with in back text", mF.format(["Martin"], "{0} is smiling"), "Martin is smiling");
		assertEquals("Using placeholder with text", mF.format(["Martin Heidegger"], "Hello - I am {0}, pleased to meet you"), "Hello - I am Martin Heidegger, pleased to meet you");

		assertEquals("Using 2 placeholders without arguments", mF.format(null, "{0}{1}"), "");
		assertEquals("Using 2 placeholders without arguments with some text", mF.format(null, "Hello {0}, do you know {1}?"), "Hello , do you know ?");
		assertEquals("Using 2 placeholders with one argument with some text", mF.format(["Martin"], "Hello {0}, do you know {1}?"), "Hello Martin, do you know ?");
		assertEquals("Using 2 placeholders with one last argument with some text", mF.format([null, "Martin"], "Hello {0}, do you know {1}?"), "Hello , do you know Martin?");
		assertEquals("Using 2 placeholders with two arguments with some text", mF.format(["Jörg","Martin"], "Hello {0}, do you know {1}?"), "Hello Jörg, do you know Martin?");

		assertEquals("Using 2 same placeholders without arguments", mF.format(null, "{0}{0}"), "");
		assertEquals("Using 2 same placeholders with argument", mF.format(["Martin"], "{0}{0}"), "MartinMartin");
		assertEquals("Using 2 same placeholders with wrong arguments", mF.format(["Martin"], "{1}{1}"), "");

		assertEquals("one single quote", mF.format(["zero"], "'{0}'"), "{0}");
		assertEquals("multiple single quotes", mF.format(null, "'''{0}'''"), "'{0}'");
		//assertEquals("multiple single quotes", mF.format(null, "'''{'0}''"), "'{0}'");
		assertEquals("mixed quotes", mF.format(["zero", "one", "two", "three"], " a'' b ''{0}'{1}'''{1}'''' {3}  {2} ' {3} '''"), " a' b 'zero{1}'one'' three  two  {3} '");
	}

	public function testDates() {
		assertEquals("Using date with default format", mF.format([new Date(2005, 3, 2, 1)], "{0,date}"), "Apr 02, 2005, 01:00");
		assertEquals("Using date with full format", mF.format([new Date(2005, 3, 2, 1)], "{0,date,full}"), "Saturday, April 02, 2005, 01:00:00");
		assertEquals("Using date with long format", mF.format([new Date(2005, 3, 2, 1)], "{0,date,long}"), "April 02, 2005, 01:00");
		assertEquals("Using date with medium format", mF.format([new Date(2005, 3, 2, 1)], "{0,date,medium}"), "Apr 02, 2005, 01:00");
		assertEquals("Using date with short format", mF.format([new Date(2005, 3, 2, 1)], "{0,date,short}"), "02.04.05 01:00");
		assertEquals("Using date with custom format", mF.format([new Date(2005, 3, 2, 1)], "{0,date,dd.mm.yy}"), "02.04.05");
	}

}