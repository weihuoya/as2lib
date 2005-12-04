import org.as2lib.lang.ConcreteLocale;
import org.as2lib.data.holder.Properties;
import org.as2lib.lang.Locale;

/**
 * @author HeideggerMartin
 */
class org.as2lib.lang.MergedLocale extends ConcreteLocale {
	
	private var locale:Locale;
	
	public function MergedLocale(locale:Locale) {
		this.locale = locale;
	}
	
	public function addProperties(prop:Properties):Void {
		
	}
	
	public function getMessage(key:String, defaultValue:String, args:Array):String { 
	}
	
	public function getLocaleCode(Void):String {
		return locale.getLocaleCode();
	}
}