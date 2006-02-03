/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.data.holder.Properties;
import org.as2lib.env.event.EventSupport;
import org.as2lib.lang.Locale;
import org.as2lib.lang.LocaleListener;
import org.as2lib.lang.UnitedKingdomLocale;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.lang.LocaleManager extends EventSupport implements Locale {
	
	private static var instance:LocaleManager;
	
	public static function getInstance(Void):LocaleManager {
		if (instance == null) {
			instance = new LocaleManager();
		}
		return instance;
	}
	
	private var locales:Array;
	private var defaultLanguageCode:String;
	private var defaultCountryCode:String;
	private var targetLanguageCode:String;
	private var targetCountryCode:String;
	
	public function LocaleManager(defaultLanguageCode:String, defaultCountryCode:String) {
		locales = new Array();
		setDefaultLocale(defaultLanguageCode, defaultCountryCode);
		setTargetLocale(System.capabilities.language);
	}
	
	public function getLanguage(Void):String {
		return getTargetLocale().getLanguage();
	}
	
	public function getLanguageCode(Void):String {
		return getTargetLocale().getLanguageCode();
	}
	
	public function getCountry(Void):String {
		return getTargetLocale().getCountry();
	}
	
	public function getCountryCode(Void):String {
		return getTargetLocale().getCountryCode();
	}
	
	public function getSymbols(Void):Properties {
		return getTargetLocale().getSymbols();
	}
	
	public function getMessage(key:String, defaultValue:String, args:Array):String {
		var result:String = getTargetLocale().getMessage(key, null, args);
		if (result === null) {
			result = getDefaultLocale().getMessage(key, defaultValue, args);
		}
		return result;
	}
	
	public function getTargetLocale(Void):Locale {
		var result:Locale = locales[targetLanguageCode + targetCountryCode];
		if (result == null) {
			result = locales[targetLanguageCode];
			if (result == null) {
				result = getDefaultLocale();
			}
		}
		return result;
	}
	
	public function setTargetLocale(targetLanguageCode:String, targetCountryCode:String):Void {
		if (this.targetLanguageCode != targetLanguageCode || this.targetCountryCode != targetCountryCode) {
			this.targetLanguageCode = targetLanguageCode;
			this.targetCountryCode = targetCountryCode;
			var distributor:LocaleListener = distributorControl.getDistributor(LocaleListener);
			distributor.onLocaleChange(this);
		}
	}
	
	public function getDefaultLocale(Void):Locale {
		var result:Locale = locales[defaultLanguageCode + defaultCountryCode];
		if (result == null) {
			result = locales[defaultLanguageCode];
			if (result == null) {
				// The default locale does not exist => return the english locale.
				// DateFormat and NumberFormat depend on this functionality if the
				// programmer is not interested in locales, but just wants to format
				// his dates and numbers with english date and number symbols.
				if (locales["en"] == null) {
					// English locale does not exist => add it.
					addLocale(new UnitedKingdomLocale());
				}
				result = locales["en"];
			}
		}
		return result;
	}
	
	public function setDefaultLocale(defaultLanguageCode:String, defaultCountryCode:String):Void {
		this.defaultLanguageCode = defaultLanguageCode;
		this.defaultCountryCode = defaultCountryCode;
	}
	
	public function getLocale(languageCode:String, countryCode:String):Locale {
		var result:Locale = locales[languageCode + countryCode];
		if (result == null) {
			result = locales[languageCode];
		}
		return result;
	}
	
	public function getLocales(Void):Array {
		return locales.concat();
	}
	
	public function addLocale(locale:Locale):Void {
		if (locale != null) {
			var languageCode:String = locale.getLanguageCode();
			var countryCode:String = locale.getCountryCode();
			if (locales[languageCode] == null) {
				locales[languageCode] = locale;
			}
			locales[languageCode + countryCode] = locale;
		}
	}
	
	public function addLocales(locales:Array):Void {
		for (var i:Number = 0; i < locales.length; i++) {
			addLocale(Locale(locales[i]));
		}
	}
	
	public function removeLocale(languageCode:String, countryCode:String):Void {
		var locale:Locale = locales[languageCode + countryCode];
		if (locale == null) {
			delete locales[languageCode];
		}
		else {
			if (locale == locales[languageCode]) {
				delete locales[languageCode];
			}
			else {
				// There is another locale that has the same language code.
				// Make this other locale the new 'owner' of the language
				for (var i:Number = 0; i < locales.length; i++) {
					var lc:Locale = locales[i];
					if (lc.getLanguageCode() == languageCode) {
						locales[languageCode] = lc;
					}
					break;
				}
			}
			delete locales[languageCode + countryCode];
		}
	}
	
}