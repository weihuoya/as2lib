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
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventBroadcasterFactory;
import org.as2lib.env.event.SimpleEventBroadcaster;

/**
 * Broadcasterfactory to generate SimpleEventBroadcaster.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.env.event.SimpleEventBroadcasterFactory extends BasicClass implements EventBroadcasterFactory {
	/**
	 * Creates and returns a new instance of a SimpleEventBroadcaster.
	 * 
	 * @return A new instance of SimpleEventBroadcaster.
	 */
	public function createEventBroadcaster(Void):EventBroadcaster {
		return EventBroadcaster(new SimpleEventBroadcaster());
	}
}