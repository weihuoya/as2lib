import org.as2lib.test.unit.TestCase;
import org.as2lib.util.TextUtil;

/**
 * @author HeideggerMartin
 */
class org.as2lib.util.TTextUtil extends TestCase {
	private function testUcFirst(Void):Void{
		assertEquals("Content: hello world", TextUtil.ucFirst("hello world"), "Hello world");
		assertEquals("Content: Hello world", TextUtil.ucFirst("Hello world"), "Hello world");
	}
	private function testUcWords(Void):Void{
		assertEquals("Content: hello world", TextUtil.ucWords("hello world"), "Hello World");
		assertEquals("Content: Hello world", TextUtil.ucWords("Hello world"), "Hello World");
	}
}