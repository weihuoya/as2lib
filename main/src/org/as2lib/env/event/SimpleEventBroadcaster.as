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
import org.as2lib.env.event.DelegatingEventBroadcaster;
import org.as2lib.env.event.EventDispatcher;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.EventListener;
import org.as2lib.util.ArrayUtil;

/**
 * SimpleEventBroadcaster is an EventBroadcaster implementation that supports
 * every broadcaster functionalities. These functionalities are setting your
 * own EventDispatcher and consuming events.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.SimpleEventBroadcaster extends BasicClass implements DelegatingEventBroadcaster {
	
	/** A reference to the NormalEventDispatcher. */
	public static var NORMAL_DISPATCHER:EventDispatcher = new NormalEventDispatcher();
	
	/** A reference to the LogEventDispatcher. */
	public static var LOG_DISPATCHER:EventDispatcher = new LogEventDispatcher();
	
	/** Contains all registered listeners. */
	private var listeners:Array;
	
	/** The used EventDispatcher */
	private var dispatcher:EventDispatcher;
	
	/**
	 * Constructs a new EventBroadcaster instance.
	 */
	public function SimpleEventBroadcaster(Void) {
		dispatcher = NORMAL_DISPATCHER;
		listeners = new Array();
	}
	
	/**
	 * Dispatcher will only be set if it is not null or undefined.
	 *
	 * @see org.as2lib.env.event.DelegatingEventBroadcaster#setDispatcher()
	 */
	public function setDispatcher(newDispatcher:EventDispatcher):Void {
		if (newDispatcher)
			dispatcher = newDispatcher;
	}
	
	/**
	 * Listener will only be added if it is not null or undefined.
	 *
	 * @see org.as2lib.env.event.EventBroadcaster#addListener()
	 */
	public function addListener(listener:EventListener):Void {
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
	 * @see org.as2lib.env.event.EventBroadcaster#addAllListener()
	 */
	public function addAllListener(listeners:Array):Void {
		if (listeners)
			this.listeners = this.listeners.concat(listeners);
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#removeListener()
	 */
	public function removeListener(listener:EventListener):Void {
		if (listener)
			ArrayUtil.removeElement(listeners, listener);
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#removeAllListener()
	 */
	public function removeAllListener(Void):Void {
		listeners = new Array();
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#getAllListener()
	 */
	public function getAllListener(Void):Array {
		return listeners.concat();
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#dispatch()
	 */
	public function dispatch(event:EventInfo):Void {
		if (event instanceof Consumable) {
			dispatcher.dispatchConsumable(event, listeners);
		} else {
			dispatcher.dispatch(event, listeners);
		}
	}
	
}