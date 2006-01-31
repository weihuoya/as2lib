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

import org.as2lib.core.BasicInterface;
import org.as2lib.data.holder.Properties;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 */
interface org.as2lib.lang.Locale extends BasicInterface {
	
	public function getLanguage(Void):String;
	public function getLanguageCode(Void):String;
	public function getCountry(Void):String;
	public function getCountryCode(Void):String;
	public function getSymbols(Void):Properties;
	public function getMessage(key:String, defaultKey:String, args:Array):String;
	
}