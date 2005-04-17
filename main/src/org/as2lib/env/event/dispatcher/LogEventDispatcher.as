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
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.ConsumableEventInfo;
import org.as2lib.env.event.ConsumableEventDispatcher;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.Logger;

/**
 * An implementation of the EventDispatcher interface that logs the dispatching
 * of the event.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.dispatcher.LogEventDispatcher extends BasicClass implements ConsumableEventDispatcher {
	
	/** Logger to log forwarded events. */
	private static var logger:Logger;
	
	/**
	 * @return logger to log forwared events
	 */
	private static function getLogger(Void):Logger {
		if (logger === undefined) {
			logger = LogManager.getLogger("org.as2lib.env.event.dispatcher.LogEventDispatcher");
		}
		return logger;
	}
	
	/**
	 * @see org.as2lib.env.event.EventDispatcher#dispatch()
	 */
	public function dispatch(event:EventInfo, listeners:Array):Void {
		var name:String = event.getName();
		var l:Number = listeners.length;
		for (var i:Number = 0; i < l; i++) {
			if (getLogger()) getLogger().info("Forwarding event #" + i + " with name " + name);
			else trace("Forwarding event #" + i + " with name " + name);
			listeners[i][name](event);
		}
	}
	
	/**
	 * @see org.as2lib.env.event.EventDispatcher#dispatchConsumable()
	 */
	public function dispatchConsumable(event:ConsumableEventInfo, listeners:Array):Void {
		var name:String = event.getName();
		var l:Number = listeners.length;
		for (var i:Number = 0; i < l && !event.isConsumed(); i++) {
			if (getLogger()) getLogger().info("Forwarding event #" + i + " with name " + name);
			else trace("Forwarding event #" + i + " with name " + name);
			listeners[i][name](event);
		}
	}
	
}
