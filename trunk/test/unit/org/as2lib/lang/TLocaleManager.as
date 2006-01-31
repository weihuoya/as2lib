import org.as2lib.test.unit.TestCase;
import org.as2lib.lang.LocaleManager;
import org.as2lib.data.holder.Properties;
import org.as2lib.lang.Locale;
import org.as2lib.data.holder.properties.SimpleProperties;
import org.as2lib.lang.ConcreteLocale;

/**
 * @author MartinHeidegger
 */
class org.as2lib.lang.TLocaleManager extends TestCase {
	
	private var localeManager:LocaleManager;
	private var enMsg:Properties;
	private var en:Locale;
	private var deMsg:Properties;
	private var de:Locale;
	
	public function setUp() {
		enMsg = new SimpleProperties();
		enMsg.setProp("welcome", "hello {0}");
		enMsg.setProp("bye", "bye {0}");
		en = new ConcreteLocale("en", enMsg);
		
		deMsg = new SimpleProperties();
		deMsg.setProp("welcome", "Hallo {0}");
		de = new ConcreteLocale("de", deMsg);
		
		localeManager = new LocaleManager("en");
		localeManager.addLocale(de);
		localeManager.addLocale(en);
		localeManager.setLocale("de");
	}
	
	public function testLookup() {
		assertEquals("default lookup should be used locale lookup", localeManager.getMessage("welcome", null, ["thomas"]), "Hallo thomas");
		assertEquals("empty result should result in using default lookup", localeManager.getMessage("bye", null, ["thomas"]), "bye thomas");
		assertEquals("unknown result in eighter used or default locale should end in the key", localeManager.getMessage("unknown", "unknown"), "unknown");
	}
}