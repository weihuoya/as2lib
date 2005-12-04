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
	
	public function getMessage(key:String, defaultValue:String, args:Array):String {
		var result:String = mF.format(content.getProp(key, null), args);
		if (result === null) {
			result = defaultValue;
		}
		return result;
	}
}