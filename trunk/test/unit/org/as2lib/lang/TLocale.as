import org.as2lib.test.unit.TestCase;
import org.as2lib.lang.Locale;
import org.as2lib.data.holder.Properties;
import org.as2lib.data.holder.properties.SimpleProperties;

/**
 * @author Martin Heidegger
 */
class org.as2lib.lang.TLocale extends TestCase {
	
	private var language:Locale;
	
	public static function blockCollecting() {
		return true;
	}
	
	private function setUp() {
		var prop:Properties = new SimpleProperties();
		prop.setProp("known.case", "hello");
		prop.setProp("one.placeHolder", "hello {0}");
		prop.setProp("multiple.placeHolder", "{0},{0},{0} {1}");
		language = getLocale(prop);
	}
	
	public function getLocale():Locale {
		return null;
	}
	
	public function testAccessCases() {
		assertEquals("unknown case should result in the key", language.getMessage("unknown.case"), "unknown.case");
		assertNull("unknown case should result in null with default value null", language.getMessage("unknown.case", null));
		assertNull("argument should not change unknown result", language.getMessage("unknown.case", null, [1,2]));
		
		assertEquals("arguments should change the unknown result with placeholders", language.getMessage("unknown.case", "one.placeHolder", ["world"]), "hello world");
		
		assertEquals("simple known case should return 'hello'", language.getMessage("known.case"), "hello");
		assertEquals("arguments should not change the result if it aint needed", language.getMessage("known.case", null, [1,2]), "hello");
		
		assertEquals("arguments should change the result with placeholders", language.getMessage("one.placeHolder", null, ["world"]), "hello world"); 
		
		assertEquals("default case should replace unknown case", language.getMessage("unknown.case","known.case"), "hello");
		assertEquals("default case should not replace unknown case if it was no value itself", language.getMessage("unknown.case","key"), "unknown.case");
		assertEquals("arguments should be applied to the default case", language.getMessage("unknown.case","one.placeHolder", ["world"]), "hello world");
		
		assertEquals("multiple arguments should be multiple checked", language.getMessage("multiple.placeHolder",null,["hello", "world"]), "hello,hello,hello world");
	}
}