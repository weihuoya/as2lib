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
import org.as2lib.env.event.EventDispatcher;
import org.as2lib.env.event.ConsumableEventInfo;

/**
 * ConsumableEventDispatchers are used to dispatch to ConsumableEventListeners.
 * Implement the EventDispatcher for different ways to dispatch events.
 * It is possible to add an ConsumableEventDispatcher instance to a DelegatingConsumableEventBroadcaster.
 * 
 * @author Simon Wacker
 * @author Martin Heidegger
 * @see org.as2lib.env.event.DelegatingConsumableEventBroadcaster#setEventDispatcher()
 */
interface org.as2lib.env.event.ConsumableEventDispatcher extends EventDispatcher {
	
	/**
	 * Dispatches the event to all EventListeners with the help of the EventInfo
	 * instance.
	 *
	 * @param info the EventInfo to be passed to the event
	 * @param listeners the EventListeners to dispatch to
	 */
	public function dispatchConsumable(event:ConsumableEventInfo, listeners:Array):Void;
	
}