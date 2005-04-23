﻿/*
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

import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.event.SimpleEventListenerSource;
import org.as2lib.env.event.EventExecutionException;
import org.as2lib.env.event.multicaster.EventMulticaster;

/**
 * {@code SimpleEventMulticaster} multicasts an event to all added listeners with
 * custom arguments. This class does not support consuming events.
 *
 * <p>Example:
 * <code>
 *   // creates a multicaster for the 'onError' event
 *   var multicaster:SimpleEventMulticaster = new SimpleEventMulticaster("onError");
 *   // adds listeners
 *   multicaster.addListener(new SimpleErrorListener());
 *   multicaster.addListener(new MyErrorListener());
 *   // executes the specified event on all listeners passing the given arguments
 *   multicaster.dispatch(myErrorCode, myException);
 * </code>
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.event.multicaster.SimpleEventMulticaster extends SimpleEventListenerSource implements EventMulticaster {
	
	/** The name of the event. */
	private var eventName:String;
	
	/**
	 * Constructs a new {@code SimpleEventMulticaster}.
	 * 
	 * @param eventName the name of the event to execute on all added listeners
	 * @throws IllegalArgumentException if passed-in {@code eventName} is {@code null},
	 * {@code undefined} or an empty string
	 */
	public function SimpleEventMulticaster(eventName:String) {
		if (!eventName) throw new IllegalArgumentException("Argument 'eventName' [" + eventName + "] must not be 'null' nor 'undefined'.", this, arguments);
		this.eventName = eventName;
	}
	
	/**
	 * Returns the event name set on construction.
	 *
	 * @return the name of the event
	 */
	public function getEventName(Void):String {
		return this.eventName;
	}
	
	/**
	 * Dispatches the event to all added listeners passing the given arguments as
	 * parameters to the listeners' event methods.
	 *
	 * @param .. any number of arguments to pass to the listeners' event methods
	 * @throws EventExecutionException if a listener's event method threw an exception
	 */
	public function dispatch():Void {
		var i:Number = this.l.length;
		if (i > 0) {
			try {
				while (--i > -1) {
					this.l[i][this.eventName].apply(this.l[i], arguments);
				}
			} catch (e) {
				// "new EventExecutionException" without braces is not MTASC compatible because of the following method call to "initCause"
				throw (new EventExecutionException("Unexpected exception was thrown during dispatch of event [" + this.eventName + "] on listener [" + this.l[i] + "] with arguments [" + arguments + "].", this, arguments)).initCause(e);
			}
		}
	}
	
}