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
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.EventListener;

/**
 * SpeedEventBroadcaster is a speed optimized EventBroadcaster implementation.
 * To ensure high speed its not possible to set your own EventDispatcher.
 * Consumable events are also not supported.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.SpeedEventBroadcaster extends BasicClass implements EventBroadcaster {	
	/** Contains all registered listeners. */
	private var listeners:Object;
	
	/**
	 * Constructs a new SpeedEventBroadcaster.
	 */
	public function SpeedEventBroadcaster(Void) {
		listeners = new Object();
		AsBroadcaster.initialize(listeners);
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#addListener()
	 */
	public function addListener(listener:EventListener):Void {
		listeners.addListener(listener);
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#removeListener()
	 */
	public function removeListener(listener:EventListener):Void {
		listeners.removeListener(listener);
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#removeAllListener()
	 */
	public function removeAllListener(Void):Void {
		listeners._listeners = new Array();
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#getAllListener()
	 */
	public function getAllListener(Void):Array {
		return listeners._listeners.concat();
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#dispatch()
	 */
	public function dispatch(event:EventInfo):Void {
		listeners.broadcastMessage(event.getName(), event);
	}
}