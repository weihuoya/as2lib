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
		
		assertEquals("No special values", mF.format("Hello this is Martin Heidegger"), "Hello this is Martin Heidegger"); 
		assertEquals("Using placeholder without argument", mF.format("{0}"), "");
		assertEquals("Using no placeholder with argument", mF.format("", ["Martin"]), "");
		
		assertEquals("Using placeholder with integer argument", mF.format("{0}", [1]), "1");
		assertEquals("Using placeholder with floating point argument", mF.format("{0}", [1.2345]), "1.2345");
		assertEquals("Using placeholder with string argument", mF.format("{0}", ["hello"]), "hello");
		assertEquals("Using placeholder with boolean argument", mF.format("{0}", [true]), "true");
		assertEquals("Using placeholder with array argument", mF.format("{0}", [[1,2,3]]), "1,2,3");
		
		assertEquals("Using placehodler with in front text", mF.format("Hello {0}", ["Martin"]), "Hello Martin");
		assertEquals("Using placeholder with in back text", mF.format("{0} is smiling", ["Martin"]), "Martin is smiling");
		assertEquals("Using placeholder with text", mF.format("Hello - I am {0}, pleased to meet you", ["Martin Heidegger"]), "Hello - I am Martin Heidegger, pleased to meet you");
		
		assertEquals("Using 2 placeholders without arguments", mF.format("{0}{1}"), "");
		assertEquals("Using 2 placeholders without arguments with some text", mF.format("Hello {0}, do you know {1}?"), "Hello , do you know ?");
		assertEquals("Using 2 placeholders with one argument with some text", mF.format("Hello {0}, do you know {1}?", ["Martin"]), "Hello Martin, do you know ?");
		assertEquals("Using 2 placeholders with one last argument with some text", mF.format("Hello {0}, do you know {1}?", [null,"Martin"]), "Hello , do you know Martin?");
		assertEquals("Using 2 placeholders with two arguments with some text", mF.format("Hello {0}, do you know {1}?", ["Jörg","Martin"]), "Hello Jörg, do you know Martin?");
		
		assertEquals("Using 2 same placeholders without arguments", mF.format("{0}{0}"), "");
		assertEquals("Using 2 same placeholders with argument", mF.format("{0}{0}", ["Martin"]), "MartinMartin");
		assertEquals("Using 2 same placeholders with wrong arguments", mF.format("{1}{1}", ["Martin"]), "");
	}
	
	public function testDates() {
		assertEquals("Using date with default format", mF.format("{0,date}", [new Date(2005, 3, 2, 1)]), "Apr 02, 2005, 01:00");
		assertEquals("Using date with full format", mF.format("{0,date,full}", [new Date(2005, 3, 2, 1)]), "Sathurday, April 02, 2005, 01:00:00");
		assertEquals("Using date with long format", mF.format("{0,date,long}", [new Date(2005, 3, 2, 1)]), "April 02, 2005, 01:00");
		assertEquals("Using date with medium format", mF.format("{0,date,medium}", [new Date(2005, 3, 2, 1)]), "Apr 02, 2005, 01:00");
		assertEquals("Using date with short format", mF.format("{0,date,short}", [new Date(2005, 3, 2, 1)]), "02.04.05 01:00");
		assertEquals("Using date with custom format", mF.format("{0,date,dd.mm.yy}", [new Date(2005, 3, 2, 1)]), "02.04.05");
	}
}