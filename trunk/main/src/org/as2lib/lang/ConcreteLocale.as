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

import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Properties;
import org.as2lib.lang.Locale;
import org.as2lib.lang.MessageFormat;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.lang.ConcreteLocale extends BasicClass implements Locale {
	
	private var languageCode:String;
	private var countryCode:String;
	private var symbols:Properties;
	private var messageFormat:MessageFormat;
	
	public function ConcreteLocale(languageCode:String, countryCode:String, symbols:Properties) {
		this.languageCode = languageCode;
		this.countryCode = countryCode;
		this.symbols = symbols;
		this.messageFormat = new MessageFormat(null, this);
	}
	
	public function getLanguage(Void):String {
		return symbols.getProp(languageCode);
	}
	
	public function getLanguageCode(Void):String {
		return languageCode;
	}
	
	public function getCountry(Void):String {
		return symbols.getProp(countryCode);
	}
	
	public function getCountryCode(Void):String {
		return countryCode;
	}
	
	public function getSymbols(Void):Properties {
		return symbols;
	}
	
	public function getMessage(key:String, defaultKey:String, args:Array):String {
		var message:String = symbols.getProp(key, null);
		if (message === null) {
			message = symbols.getProp(defaultKey, null);
			if (message === null) {
				if (defaultKey === null) {
					return null;
				}
				return key;
			}
			return messageFormat.format(args, message);
		}
		return messageFormat.format(args, message);
	}
	
}