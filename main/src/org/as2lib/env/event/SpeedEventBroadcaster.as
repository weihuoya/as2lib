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

	/** Contains all registered EventListeners. */
	private var l:Object;
	
	/**
	 * Constructs a new SpeedEventBroadcaster.
	 *
	 * @param listeners argument that can be used to configure the broadcaster
	 */
	public function SpeedEventBroadcaster(listeners:Array) {
		l = new Object();
		AsBroadcaster.initialize(l);
		if (listeners) l._listeners = listeners;
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#addListener()
	 */
	public function addListener(listener:EventListener):Void {
		if (listener)
			l.addListener(listener);
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#addAllListener()
	 */
	public function addAllListener(listeners:Array):Void {
		if (listeners)
			l = l.concat(listeners);
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#removeListener()
	 */
	public function removeListener(listener:EventListener):Void {
		if (listener)
			l.removeListener(listener);
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#removeAllListener()
	 */
	public function removeAllListener(Void):Void {
		l._listeners = new Array();
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#getAllListener()
	 */
	public function getAllListener(Void):Array {
		return l._listeners.concat();
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#dispatch()
	 */
	public function dispatch(e:EventInfo):Void {
		if (e) {
			if (l._listeners.length > 0) {
				var n:String = e.getName();
				if (n) l.broadcastMessage(n, e);
			}
		}
	}
	
}