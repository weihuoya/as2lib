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
import org.as2lib.core.ObjectStringifier;
import org.as2lib.util.Stringifier;

/**
 * Basic configuration class.
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.Config extends BasicClass {
	
	/** Stringifier used to stringify objects. */
	private static var objectStringifier:Stringifier;
	
	/**
	 * Private constructor.
	 */
	private function Config(Void) {
	}
	
	/**
	 * Sets a new stringifier used to stringify objects.
	 *
	 * @param stringifier the new object stringifier
	 */
	public static function setObjectStringifier(stringifier:Stringifier):Void {
		objectStringifier = stringifier;
	}
	
	/**
	 * Returns the stringifier used to stringify objects.
	 *
	 * @return the currently used object stringifier.
	 */
	public static function getObjectStringifier(Void):Stringifier {
		if (!objectStringifier) objectStringifier = new ObjectStringifier();
		return objectStringifier;
	}
	
}