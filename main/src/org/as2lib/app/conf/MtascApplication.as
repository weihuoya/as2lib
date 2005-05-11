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

import main.Mtasc;
import main.Configuration;

/**
 * Default access point for a application with Mtasc.
 * <p>Use this class for starting up your application with the MTASC compiler found at http://www.mtasc.org.
 * It will start your MTASC configuration in {@link main.Mtasc} and your configuration for all 
 * environments in {@link main.Configuration}.
 * 
 * <p>Simply use this class as main startup class in the mtasc preferences.
 * <code>
 * [MTASC directory]\mtasc.exe -cp "[your project path]" -cp "[as2lib project path]" org/as2lib/app/conf/MtascApplication.as
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.app.conf.MtascApplication {
	
	/**
	 * Executes the configuration for the flash environment in {@link main.Flash} and the 
	 * configuration for all environments in {@link main.Configuration}.
	 */
	public static function main(Void):Void {
		Mtasc.init();
		Configuration.init();
	}
	
}