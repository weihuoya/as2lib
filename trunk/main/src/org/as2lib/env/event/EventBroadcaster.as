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
import org.as2lib.env.event.EventListener;
import org.as2lib.env.event.EventInfo;

/**
 * Interface for standardized broadcasting.
 * 
 * @author Martin Heidegger
 */
interface org.as2lib.env.event.EventBroadcaster extends BasicInterface {
	
	/**
	 * Adds a listener to the pool of listeners.
	 * 
	 * @param listener the EventListener to be added to the pool
	 */
	public function addListener(listener:EventListener):Void;
	
	/**
	 * Adds all listeners to the pool of listeners.
	 *
	 * @param listeners the listeners to be added
	 */
	public function addAllListener(listeners:Array):Void;
	
	/**
	 * Removes a listener from the pool of listeners.
	 * 
	 * @param listener the EventListener to be removed
	 */
	public function removeListener(listener:EventListener):Void;
	
	/**
	 * Removes all registered listeners.
	 */
	public function removeAllListener(Void):Void;
	
	/**
	 * Returns a copy of the listener pool.
	 *
	 * @return a copy of the listener pool
	 */
	public function getAllListener(Void):Array;
	
	/**
	 * Dispatches the events associated with the name cotained in the
	 * EventInfo instance.
	 * 
	 * @param event the EventInfo to be passed to the operation of the EventListeners
	 */
	public function dispatch(event:EventInfo):Void;
	
}