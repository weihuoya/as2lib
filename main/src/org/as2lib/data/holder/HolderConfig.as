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

import org.as2lib.core.BasicClass;
import org.as2lib.util.Stringifier;
import org.as2lib.data.holder.map.MapStringifier;
import org.as2lib.data.holder.stack.StackStringifier;
import org.as2lib.data.holder.queue.QueueStringifier;
import org.as2lib.data.holder.list.ListStringifier;

/**
 * HolderConfig is the fundamental configuration file for all classes residing
 * in the org.as2lib.data.holder package.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.HolderConfig extends BasicClass {
	/** Used to stringify Maps. */
	private static var mapStringifier:Stringifier;
	
	/** Used to stringify Stacks. */
	private static var stackStringifier:Stringifier;
	
	/** Used to stringify Queues. */
	private static var queueStringifier:Stringifier;
	
	/** Used to stringify Queues. */
	private static var listStringifier:Stringifier;
	
	/** 
	 * Private constructor.
	 */
	private function HolderConfig(Void) {
	}
	
	/**
	 * Sets the new Stringifier used to stringify Maps.
	 *
	 * @param stringifier the new Map Stringifier
	 */
	public static function setMapStringifier(newStringifier:Stringifier):Void {
		mapStringifier = newStringifier;
	}
	
	/**
	 * Returns the currently used Stringifier used to stringify Maps.
	 *
	 * @return the currently used Map Stringifier
	 */
	public static function getMapStringifier(Void):Stringifier {
		if (!mapStringifier) mapStringifier = new MapStringifier();
		return mapStringifier;
	}
	
	/**
	 * Sets the new Stringifier used to stringify Stacks.
	 *
	 * @param stringifier the new Stack Stringifier
	 */
	public static function setStackStringifier(newStringifier:Stringifier):Void {
		stackStringifier = newStringifier;
	}
	
	/**
	 * Returns the currently used Stringifier used to stringify Stacks.
	 *
	 * @return the currently used Stack Stringifier
	 */
	public static function getStackStringifier(Void):Stringifier {
		if (!stackStringifier) stackStringifier = new StackStringifier();
		return stackStringifier;
	}
	
	/**
	 * Sets the new Stringifier used to stringify Queues.
	 *
	 * @param stringifier the new Queue Stringifier
	 */
	public static function setQueueStringifier(newStringifier:Stringifier):Void {
		queueStringifier = newStringifier;
	}
	
	/**
	 * Returns the currently used Stringifier used to stringify Queues.
	 *
	 * @return the currently used Queues Stringifier
	 */
	public static function getQueueStringifier(Void):Stringifier {
		if (!queueStringifier) queueStringifier = new QueueStringifier();
		return queueStringifier;
	}
	
	/**
	 * Returns the currently used Stringifier used to stringify Lists.
	 *
	 * @return the currently used List Stringifier
	 */
	public static function getListStringifier(Void):Stringifier {
		if (!listStringifier) listStringifier = new ListStringifier();
		return listStringifier;
	}
}