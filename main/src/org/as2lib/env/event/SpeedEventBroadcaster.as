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
import org.as2lib.env.event.EventExecutionException;

/**
 * SimpleEventBroadcaster is an EventBroadcaster implementation that supports
 * every broadcaster functionalities. It allows fast broadcasting of events in the
 * as2lib eventhandling system.
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 * @see org.as2lib.env.event.EventBroadcaster
 */
class org.as2lib.env.event.SpeedEventBroadcaster extends BasicClass implements EventBroadcaster {	

	/** Contains all registered EventListeners. */
	private var l:Object;
	
	/**
	 * Constructs a new SimpleEventBroadcaster.
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
		removeListener(listener);
		if (listener)
			l.addListener(listener);
	}
	
	/**
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
	 * @see org.as2lib.env.event.EventBroadcaster#removeListener()
	 */
	public function removeListener(listener:EventListener):Void {
		if (listener)
			l.removeListener(listener);
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#removeAllListeners()
	 */
	public function removeAllListeners(Void):Void {
		l._listeners = new Array();
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#getAllListeners()
	 */
	public function getAllListeners(Void):Array {
		return l._listeners.concat();
	}
	
	/**
	 * @see org.as2lib.env.event.EventBroadcaster#dispatch()
	 */
	public function dispatch(e:EventInfo):Void {
		if (e) {
			if (l._listeners.length > 0) {
				var n:String = e.getName();
				try {
					if (n) l.broadcastMessage(n, e);
				} catch(e) {
					throw new EventExecutionException(e, "Unexpected Exception thrown during broadcast of "+n, this, arguments);
				}
			}
		}
	}
}