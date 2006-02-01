import org.as2lib.lang.TLocale;
import org.as2lib.lang.Locale;
import org.as2lib.lang.ConcreteLocale;
import org.as2lib.data.holder.Properties;

/**
 * @author HeideggerMartin
 */
class org.as2lib.lang.TConcreteLocale extends TLocale {
	
	public function getLocale(symbols:Properties):Locale {
		return new ConcreteLocale("de", "DE", symbols);
	}
	
}