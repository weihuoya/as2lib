﻿/*
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
import org.as2lib.util.Stringifier;
import org.as2lib.data.holder.map.MapStringifier;

/**
 * @author Simon Wacker
 */
class org.as2lib.data.holder.map.AbstractMap extends BasicClass {
	
	/** Used to stringify maps. */
	private static var stringifier:Stringifier;
	
	/**
	 * Returns the stringifier that stringifies maps.
	 *
	 * @return the stringifier that stringifies maps
	 */
	public static function getStringifier(Void):Stringifier {
		if (!stringifier) stringifier = new MapStringifier();
		return stringifier;
	}
	
	/**
	 * Sets the new stringifier that stringifies maps.
	 *
	 * @param mapStringifier the new map stringifier
	 */
	public static function setStringifier(mapStringifier:Stringifier):Void {
		stringifier = mapStringifier;
	}
	
	/**
	 * Private constructor.
	 */
	private function AbstractMap(Void) {
	}
	
}