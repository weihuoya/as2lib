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

import org.as2lib.env.out.OutAccess;
import org.as2lib.Config;

/**
 * Config File for unit TestcaseSystem.
 * This file contains all configuration parameters.
 * 
 * @autor Martin Heidegger
 * @date 24.04.2004
 */
class org.as2lib.test.unit.TestConfig {
	/** The OutAccess instance for the testcase system. */
	private static var out:OutAccess;
	
	/**
	 * Sets the OutAccess Instance of the config.
	 * 
	 * @param Out instance for this config.
	 */
	public static function setOut(to:OutAccess):Void {
		out = to;
	}
	
	/**
	 * Evaluates and returns the Out Configurations.
	 * 
	 * @return Defined OutAccess instance.
	 */
	public static function getOut(Void):OutAccess {
		if(out) {
			return out;
		}
		return Config.getOut();
	}
}