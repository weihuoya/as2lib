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

import org.as2lib.Config;
import org.as2lib.core.BasicClass;
import org.as2lib.util.Stringifier;
import org.as2lib.env.out.OutInfoStringifier;
import org.as2lib.env.event.EventBroadcasterFactory;

/**
 * OutConfig is the main config class for the out package.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.out.OutConfig extends BasicClass {
	/** This Stringifier is used to stringify OutInfos. */
	private static var infoStringifier:Stringifier;
	
	/** Internal EventbroadcasterFactory Holder */
	private static var eventBroadcasterFactory:EventBroadcasterFactory;
	
	/**
	 * Private constructor.
	 */
	private function OutConfig(Void) {
	}
	
	/**
	 * Sets the Stringifier used to stringify OutInfos.
	 * 
	 * @param stringifier the new Stringifier used to stringify OutInfos
	 */
	public static function setInfoStringifier(newStringifier:Stringifier):Void {
		infoStringifier = newStringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify OutInfos.
	 * Initializes the Stringifier if it wasn't initialized before.
	 *
	 * @return the Stringifier used to stringify OutInfos
	 */
	public static function getInfoStringifier(Void):Stringifier {
		if(!infoStringifier) infoStringifier = new OutInfoStringifier();
		return infoStringifier;
	}
	
	/**
	 * Returns the EventBroadcasterFactory config.
	 * If the EventBroadcasterFactory was not set it takes it from the basic Config.
	 * 
	 * @see Config
	 * @return the EventBroadcasterFactory instance of the config.
	 */
	public static function getEventBroadcasterFactory(Void):EventBroadcasterFactory {
		if(!eventBroadcasterFactory) return Config.getEventBroadcasterFactory();
		return eventBroadcasterFactory;
	}
	
	/**
	 * Sets the EventBroadcastorFactory configuration.
	 * 
	 * @param eventBroadcasterFactory Factory for creating EventBroadcasters.
	 */
	public static function setEventBroadcasterFactory(to:EventBroadcasterFactory):Void {
		eventBroadcasterFactory = to;
	}
}