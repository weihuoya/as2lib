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

import org.as2lib.context.MessageSource;
import org.as2lib.context.support.AbstractMessageSource;
import org.as2lib.data.holder.Properties;
import org.as2lib.lang.Locale;
import org.as2lib.lang.MessageFormat;

/**
 * @author Simon Wacker
 */
class org.as2lib.context.support.StaticMessageSource extends AbstractMessageSource implements MessageSource {
	
	private var messages:Array;
	
	public function StaticMessageSource(Void) {
		messages = new Array();
	}
	
	public function addMessages(locale:String, messages:Properties):Void {
		this.messages[locale] = messages;
	}
	
	public function getMessages(locale:String):Properties {
		return messages[locale];
	}
	
	private function resolveCode(code:String, locale:Locale):MessageFormat {
		var languageCode:String = locale.getLanguageCode();
		var ms:Properties = messages[languageCode + locale.getCountryCode()];
		if (ms == null) {
			ms = messages[languageCode];
		}
		var message:String = ms.getProp(code);
		return createMessageFormat(message, locale);
	}
	
}