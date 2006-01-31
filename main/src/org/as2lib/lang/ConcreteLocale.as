import org.as2lib.core.BasicClass;
import org.as2lib.lang.Locale;
import org.as2lib.data.holder.Properties;
import org.as2lib.lang.MessageFormat;

/**
 * @author HeideggerMartin
 */
class org.as2lib.lang.ConcreteLocale extends BasicClass implements Locale {
	
	private var code:String;
	private var content:Properties;
	private var mF:MessageFormat;
	
	public function ConcreteLocale(languageCode:String, content:Properties) {
		this.code = languageCode;
		this.content = content;
		this.mF = new MessageFormat();
	}
	
	public function getLocaleCode(Void):String {
		return code;
	}
	
	public function getMessage(key:String, defaultKey:String, args:Array):String {
		var prop:String = content.getProp(key, null);
		if (prop === null) {
			prop = content.getProp(defaultKey, null);
			if (prop === null) {
				if (defaultKey === null) {
					return null;
				} else {
					return key;
				}
			} else {
				return mF.format(prop, args);
			}
		} else {
			return mF.format(prop, args);
		}
	}
}