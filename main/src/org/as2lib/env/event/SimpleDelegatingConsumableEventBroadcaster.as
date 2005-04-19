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
import org.as2lib.env.event.Consumable;
import org.as2lib.env.event.dispatcher.NormalEventDispatcher;
import org.as2lib.env.event.dispatcher.LogEventDispatcher;
import org.as2lib.env.event.DelegatingConsumableEventBroadcaster;
import org.as2lib.env.event.ConsumableEventDispatcher;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.ConsumableEventInfo;

/**
 * SimpleConsumableEventBroadcaster is an EventBroadcaster implementation that supports
 * every broadcaster functionalities. These functionalities are setting your
 * own EventDispatcher and consuming events.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.SimpleDelegatingConsumableEventBroadcaster extends BasicClass implements DelegatingConsumableEventBroadcaster {
	
	/** A reference to the NormalEventDispatcher. */
	public static var NORMAL_DISPATCHER:ConsumableEventDispatcher = new NormalEventDispatcher();
	
	/** A reference to the LogEventDispatcher. */
	public static var LOG_DISPATCHER:ConsumableEventDispatcher = new LogEventDispatcher();
	
	/** Contains all registered listeners. */
	private var listeners:Array;
	
	/** The used EventDispatcher */
	private var dispatcher:ConsumableEventDispatcher;
	
	/**
	 * Constructs a new EventBroadcaster instance.
	 */
	public function SimpleDelegatingConsumableEventBroadcaster(Void) {
		dispatcher = NORMAL_DISPATCHER;
		listeners = new Array();
	}
	
	/**
	 * Dispatcher will only be set if it is not null or undefined.
	 *
	 * @see org.as2lib.env.event.DelegatingEventBroadcaster#setDispatcher()
	 */
	public function setDispatcher(newDispatcher:ConsumableEventDispatcher):Void {
		if (newDispatcher)
			dispatcher = newDispatcher;
	}
	
	/**
	 * Listener will only be added if it is not null or undefined.
	 *
	 * @see org.as2lib.env.event.ConsumableEventBroadcaster#addListener()
	 */
	public function addListener(listener):Void {
		removeListener(listener);
		if (listener)
			listeners.push(listener);
	}
	
	/**
	 * Null or undefined argument will be interpreted as empty
	 * listener array.
	 * 
	 * <p>The listeners in the array will not be checked for correct
	 * type nor for being undefined or null.
	 *
	 * @see org.as2lib.env.event.EventBroadcaster#addAllListeners()
	 */
	public function addAllListeners(listeners:Array):Void {
		if (listeners) {
			var i:Number = listeners.length;
			while(--i-(-1)) {
				addListener(listeners[i]);
			}
		}
	}
	
	/**
	 * @see org.as2lib.env.event.ConsumableEventBroadcaster#removeListener()
	 */
	public function removeListener(listener):Void {
		if (listener && listeners.length > 0) {
			var i:Number = listeners.length;
			while(--i-(-1)) {
				if(listeners[i] == listener) {
					listeners.splice(i, 1);
					break;
				}
			}
		}
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#removeAllListeners()
	 */
	public function removeAllListeners(Void):Void {
		listeners = new Array();
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#getAllListeners()
	 */
	public function getAllListeners(Void):Array {
		return listeners.concat();
	}
	
	/**
	 * @see org.as2lib.env.event.ConsumableEventBroadcaster#dispatch()
	 */
	public function dispatch(event:EventInfo):Void {
		dispatcher.dispatch(event, listeners);
	}
	
	/**
	 * @see org.as2lib.env.event.ConsumableEventBroadcaster#dispatch()
	 */
	public function dispatchConsumable(event:ConsumableEventInfo):Void {
		dispatcher.dispatchConsumable(event, listeners);
	}
	
}