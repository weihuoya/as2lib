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
import org.as2lib.env.event.EventListener;
import org.as2lib.util.ArrayUtil;

/**
 * ListenerArray is used to store EventListeners.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.ListenerArray extends BasicClass {
	/** Added EventListeners. */
	private var listeners:Array;
	
	/**
	 * Constructs a new ListenerArray instance.
	 */
	public function ListenerArray(Void) {
		listeners = new Array();
	}
	
	/**
	 * Pushes a new EventListener to the list.
	 *
	 * @param listener the new EventListener to be pushed to the list
	 */
	public function push(listener:EventListener):Void {
		listeners.push(listener);
	}
	
	/**
	 * Returns the EventListener specified by the passed id.
	 *
	 * @param id the id specifying a specific EventListener
	 * @return the EventListener appropriate to the id
	 */
	public function get(id:Number):EventListener {
		return listeners[id];
	}
	
	/**
	 * Removes the specified EventListener from the list.
	 *
	 * @param listener the EventListener to be removed from the list
	 */
	public function remove(listener:EventListener):Void {
		ArrayUtil.removeElement(listeners, listener);
	}
	
	/**
	 * Clears the whole list.
	 */
	public function clear(Void):Void {
		listeners = new Array();
	}
	
	/**
	 * Returns the amount of added EventListeners.
	 *
	 * @return the number of added EventListeners
	 */
	public function get length():Number {
		return listeners.length;
	}
}