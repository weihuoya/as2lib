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

import main.Flashout;
import main.Configuration;

/**
 * Default access point for a application within a Flashout context.
 * <p>Use this class as base class within your Flashout settings and it will execute your
 * Flashout specific configuration of {@link main.Flashout} and your configuration for all
 * environments found at {@link main.Configuration}
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.app.conf.FlashoutApplication {
	
	/**
	 * Executes the configuration for the flash environment in {@link main.Flash} and the 
	 * configuration for all environments in {@link main.Configuration}.
	 */
	public static function main(Void):Void {
		Flashout.init();
		Configuration.init();
	}
	
}