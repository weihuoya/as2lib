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
import org.as2lib.env.event.EventBroadcasterFactory;
import org.as2lib.env.event.SimpleEventBroadcasterFactory;
import org.as2lib.core.ObjectStringifier;
import org.as2lib.util.Stringifier;

/**
 * Basic configuration class for all classes.
 * The configurations out of this file will be used if subconfigurations wont overwrite it.
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.Config extends BasicClass {

	/** Internal holder for the EventBroadcasterFactory */
	private static var eventBroadcasterFactory:EventBroadcasterFactory;
	
	/** Stringifier used to stringify Objects. */
	private static var objectStringifier:Stringifier;
	
	/**
	 * Private constructor.
	 */
	private function Config(Void) {
	}
	
	/**
	 * Sets an EventBroadcasterFactory for this path.
	 * 
	 * @param to EventBroadcastorFactory that shall be used.
	 */
	public static function setEventBroadcasterFactory(to:EventBroadcasterFactory):Void {
		eventBroadcasterFactory = to;
	}
	
	/**
	 * Returns the EventBroadcasterFactory set by #setEventBroadcasterFactory()
	 * or a default EventBroadcasterFactory if a custom one hasn't been set yet.
	 * 
	 * @return the currently used EventBroadcasterFactory
	 */
	public static function getEventBroadcasterFactory(Void):EventBroadcasterFactory {
		if(!eventBroadcasterFactory) eventBroadcasterFactory = new SimpleEventBroadcasterFactory();
		return eventBroadcasterFactory;
	}
	
	/**
	 * Sets a new Stringifier used to stringify Objects.
	 *
	 * @param stringifier the new Object Stringifier
	 */
	public static function setObjectStringifier(stringifier:Stringifier):Void {
		objectStringifier = stringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify Objects.
	 *
	 * @return the currently used Object Stringifier.
	 */
	public static function getObjectStringifier(Void):Stringifier {
		if (!objectStringifier) objectStringifier = new ObjectStringifier();
		return objectStringifier;
	}
}