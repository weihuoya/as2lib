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
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.util.ClassUtil;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * DynamicEventBroadcasterFactory implements the EventBroadcasterFactory
 * interface. Special about this factory is that you can set the EventBroadcaster
 * to be returned through the #setEventBroadcasterClass() operation.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.env.event.DynamicEventBroadcasterFactory extends BasicClass implements EventBroadcasterFactory {
	
	/** Internal holder for the class that will be instantiated. */
	private var clazz:Function;
	
	/**
	 * Constructs a new DynamicEventBroadcasterFactory instance.
	 *
	 * @param clazz the class that gets used by the #createEventBroadcaster() method.
	 */
	public function DynamicEventBroadcasterFactory(clazz:Function) {
		setEventBroadcasterClass(clazz);
	}
	
	/**
	 * Sets the class that will be used by #createEventBroadcaster()
	 * 
	 * @param clazz Class to be instantiated.
	 * @throws IllegalArgumentException if the class is not a implementation of the EventBroadcaster interface
	 */
	public function setEventBroadcasterClass(clazz:Function) {
		if (!ClassUtil.isImplementationOf(clazz, EventBroadcaster)){
			var className:String = ReflectUtil.getTypeNameForType(clazz);
			if (!className) className = "unknown";
			throw new IllegalArgumentException("The argument clazz ["+clazz+":"+className+"] is not an Implementation of org.as2lib.env.event.EventBroadcaster.",this,arguments);
		}
		this.clazz = clazz;
	}
	
	/**
	 * Creates and returns a new instance of a the defined EventBroadcaster class.
	 * 
	 * @return a new instance of the defined EventBroadcaster class
	 * @throws IllegalStateException if the class has not been defined through the operation #setEventBroadcasterClass() yet.
	 */
	public function createEventBroadcaster(Void):EventBroadcaster {
		if (!clazz) {
			throw new IllegalStateException("You have to set a class through the #setEventBroadcasterClass() operation before you call this operation.", this, arguments);
		}
		return EventBroadcaster(new clazz());
	}
	
}