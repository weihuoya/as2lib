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
import org.as2lib.env.event.ConsumableEventInfo;
import org.as2lib.env.event.ConsumableEventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.EventListener;
import org.as2lib.env.event.EventExecutionException;

/**
 * SimpleConsumableEventBroadcaster is an EventBroadcaster implementation that supports
 * all eventbroadcaster functionalities and allows using consumable event informations.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.SimpleConsumableEventBroadcaster extends BasicClass implements ConsumableEventBroadcaster {
	
	/** Contains all registered listeners. */
	private var listeners:Array;
	
	/**
	 * Constructs a new SimpleConsumableEventBroadcaster instance.
	 */
	public function SimpleConsumableEventBroadcaster(Void) {
		listeners = new Array();
	}
	
	/**
	 * Listener will only be added if it is not null or undefined.
	 *
	 * @see org.as2lib.env.event.ConsumableEventBroadcaster#addListener()
	 */
	public function addListener(listener:EventListener):Void {
		removeListener(listener);
		if (listener)
			listeners.push(listener); // .unshift is typed to :Object.
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
	public function removeListener(listener:EventListener):Void {
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
	public function dispatch(e:EventInfo):Void {
		if(e) {
			var l:Array = listeners;
			var len:Number = l.length;
			if(len > 0) {
				var n:String = e.getName();
				if(n) {
					try {
						for(var i:Number = 0; i<len; i++) {
							l[i][n](e);
						}
					} catch(e) {
						throw new EventExecutionException(e, "Unexpected Exception thrown during broadcast of "+n, this, arguments);
					}
				}
			}
		}
	}
	
	/**
	 * @see org.as2lib.env.event.ConsumableEventBroadcaster#dispatchConsumable()
	 */
	public function dispatchConsumable(e:ConsumableEventInfo):Void {
		if(e) {
			var l:Array = listeners;
			var len:Number = l.length;
			if(len > 0) {
				var n:String = e.getName();
				if(n) {
					try {
						for(var i:Number=0; i<len && !e.isConsumed(); i++) {
							l[i][n](e);
						}
					} catch(e) {
						throw new EventExecutionException(e, "Unexpected Exception thrown during broadcast of "+n, this, arguments);
					}
				}
			}
		}
	}
	
}