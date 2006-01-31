import org.as2lib.lang.Locale;
import org.as2lib.env.event.EventSupport;
import org.as2lib.lang.LocaleListener;

/**
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.lang.LocaleManager extends EventSupport implements Locale {

	private static var instance:LocaleManager;
	
	public static function getInstance(Void):LocaleManager {
		if (!instance) {
			instance = new LocaleManager();
		}
		return instance;
	}
	
	private var defaultLocaleCode:String;
	private var languageCode:String;
	private var languages:Array;

	public function LocaleManager(defaultLocaleCode:String) {
		acceptListenerType(LocaleListener);
		languages = new Array();
		setDefaultLocale(defaultLocaleCode);
		useDefaultLocale();
	}
	
	public function setDefaultLocale(languageCode:String):Void {
		if (!languageCode) {
			languageCode = System.capabilities.language;
		}
		this.defaultLocaleCode = languageCode;
	}

	public function addLocale(language:Locale):Void {
		languages[language.getLocaleCode()] = language;
	}
	
	public function removeLocale(languageCode:String):Void {
		delete languages[languageCode];
	}
	
	public function getMessage(key:String, defaultValue:String, args:Array):String {
		var result:String = languages[languageCode].getMessage(key, null, args);
		
		if (result === null) {
			result = languages[defaultLocaleCode].getMessage(key, defaultValue, args);
		}
		
		return result;
	}
	
	public function useDefaultLocale(Void):Void {
		languageCode = defaultLocaleCode;
	}
	
	public function setLocale(languageCode:String):Void {
		if (this.languageCode != languageCode) {
			this.languageCode = languageCode;
			
			var distributor:LocaleListener =
				distributorControl.getDistributor(LocaleListener);
			
			distributor.onLocaleChange(this);
		}
	}
	
	public function getLocaleCode(Void):String {
		if (!languageCode) {
			return defaultLocaleCode;
		}
		return languageCode;
	}
}