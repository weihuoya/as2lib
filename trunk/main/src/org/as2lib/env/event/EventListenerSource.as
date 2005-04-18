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

import org.as2lib.core.BasicInterface;
import org.as2lib.env.event.EventListener;

/**
 * {@code EventListenerSource} acts as a source for {@link EventListener} instances.
 * It declares basic methods to add, remove and get listeners.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.env.event.EventListenerSource extends BasicInterface {
	
	/**
	 * Adds the passed-in {@code listener}.
	 * 
	 * @param listener the listener to add
	 */
	public function addListener(listener:EventListener):Void;
	
	/**
	 * Adds all listeners contained in the passed-in {@code listeners} array. The
	 * individual listeners must be instances of type {@link EventListener}.
	 * 
	 * @param listeners the listeners to add
	 */
	public function addAllListeners(listeners:Array):Void;
	
	/**
	 * Removes the passed-in {@code listener}.
	 * 
	 * @param listener the listener to remove
	 */
	public function removeListener(listener:EventListener):Void;
	
	/**
	 * Removes all added listeners.
	 */
	public function removeAllListeners(Void):Void;
	
	/**
	 * Returns all added listeners that are of type {@link EventListener}.
	 * 
	 * @return all added listeners
	 */
	public function getAllListeners(Void):Array;
	
}