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
import org.as2lib.env.event.EventInfo;

/**
 * EventDispatchers are used to dispatch to EventListeners.
 * Implement the EventDispatcher for different ways to dispatch events.
 * It is possible to add an EventDispatcher instance to a DelegatingEventBroadcaster.
 * 
 * @author Simon Wacker
 * @author Martin Heidegger
 * @see org.as2lib.env.event.DelegatingEventBroadcaster#setEventDispatcher()
 */
interface org.as2lib.env.event.EventDispatcher extends BasicInterface {
	/**
	 * Dispatches the event to all EventListeners with the help of the EventInfo
	 * instance.
	 *
	 * @param info the EventInfo to be passed to the event
	 * @param listeners the EventListeners to dispatch to
	 */
	public function dispatch(event:EventInfo, listeners:Array):Void;
	
	/**
	 * Dispatches the event to all EventListeners with the help of the EventInfo instance.
	 * Special about this operation is that it checks whether the EventInfo
	 * is consumed. If it is consumed the dispatching will abruptly stop.
	 *
	 * @param info the EventInfo to be passed to the event
	 * @param listeners the EventListeners to dispatch to
	 */
	public function dispatchConsumable(event:EventInfo, listeners:Array):Void;
}