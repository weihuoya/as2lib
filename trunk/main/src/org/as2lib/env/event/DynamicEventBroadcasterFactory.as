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
import org.as2lib.env.event.EventBroadcasterFactory;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.UndefinedPropertyException;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ClassUtil;

/**
 * Broadcasterfactory to generate a Eventbroadcaster by a EventBroadcaster class that is customizeable.
 * 
 * @autor Martin Heidegger
 */
class org.as2lib.env.event.DynamicEventBroadcasterFactory extends BasicClass implements EventBroadcasterFactory {
	/** Internal holder for the class that will be instanciated. */
	private var clazz:Function;
	
	/**
	 * Sets the class that will be used by #createEventBroadcaster;
	 * 
	 * @param clazz Class to be instanciated.
	 * @throws IllegalArgumentException If clazz is not a implementation of EventBroadcaster.
	 */
	public function setEventBroadcasterClass(clazz:Function) {
		if(!ClassUtil.isImplementationOf(clazz, EventBroadcaster)){
			try {
				var className:String = ReflectUtil.getClassInfo(clazz).getName();
			} catch(e:org.as2lib.env.reflect.ReferenceNotFoundException) {
				var className:String = "unknown";
			}
			throw new IllegalArgumentException("The argument clazz ["+clazz+":"+className+"] is not an Implementation of org.as2lib.env.event.EventBroadcaster.",this,arguments);
		}
		this.clazz = clazz;
	}
	
	/**
	 * Creates and returns a new instance of a the defined EventBroadcaster class.
	 * 
	 * @return A new instance of the defined EventBroadcaster class.
	 * @throws PropertyUndefinedException if the class is not defined.
	 */
	public function createEventBroadcaster(Void):EventBroadcaster {
		if(!clazz) {
			throw new UndefinedPropertyException("clazz is undefined. You have to set a class with .setEventBroadcasterClass() before to create an instance.",this,arguments);
		}
		return EventBroadcaster(new clazz());
	}
}