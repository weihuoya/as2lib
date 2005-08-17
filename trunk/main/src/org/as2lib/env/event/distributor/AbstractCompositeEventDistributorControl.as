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

import org.as2lib.util.ArrayUtil;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.event.distributor.CompositeEventDistributorControl;
import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.event.distributor.EventDistributorControlFactory;

/**
 * {@code AbstractCompositeEventDistributorControl} is the default implementation
 * of {@link CompositeEventDistributorControl}.
 * <p>To use the functionality, simply extend it and pass a factory for the
 * default eventdistributors.
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.env.event.distributor.AbstractCompositeEventDistributorControl implements CompositeEventDistributorControl {
	
	/* Factory to create default event distributors for the different types */
	private var eventDistributorControlFactory:EventDistributorControlFactory;
	
	/* Listener holder */
	private var listeners:Array;
	
	/* Map that contains all used eventdistributors */
	private var distributorMap:Map;
	
	/**
	 * Creates a new AbstractCompositeEventDistributorControl
	 * 
	 * @param factory Factory to create event distributors for the different types.
	 */
	public function AbstractCompositeEventDistributorControl(factory:EventDistributorControlFactory) {
		eventDistributorControlFactory = factory;
		distributorMap = new HashMap();
		listeners = new Array();
	}
	
	/**
	 * Adds a certain listener to the event control
	 * <p>It validates if the passed-in listener matches any of the accepted 
	 * listeners. 
	 * 
	 * <p>The listener will be contained in all matching distributors.
	 * 
	 * @param l Listener to be added to the control
	 * @throws IllegalArgumentException if the certain listener doesn't match
	 *         any accepted type.
	 */
	public function addListener(l):Void {
		if (!hasListener(l)) {
			var acceptedTypes:Array = distributorMap.getKeys();
			var existingDistributors:Array = distributorMap.getValues();
			var added:Boolean = false;
			var i:Number;
			for (i=0; i<acceptedTypes.length; i++) {
				if (l instanceof acceptedTypes[i]) {
					existingDistributors[i].addListener(l);
					added = true;
				}
			}
			if (added) {
				listeners.push(l);
			} else {
				var message:String = "Passed listener ["+ReflectUtil.getTypeNameForInstance(l)+"] doesnt match any of the accepted listener types ";
				var size:Number = distributorMap.size();
				if (size > 0) {
					message += "("+size+"):";
					var iter:Iterator = distributorMap.keyIterator();
					while (iter.hasNext()) {
						message += "\n - "+ReflectUtil.getTypeNameForType(iter.next());
					}
				} else {
					message += "(No types accepted).";
				}
				throw new IllegalArgumentException(message, this, arguments);
			}
		}
	}
	
	/**
	 * Removes a certain listener from listening to a event.
	 * 
	 * @param l Listener to be removed.
	 */
	public function removeListener(l):Void {
		if (hasListener(l)) {
			var acceptedTypes:Array = distributorMap.getKeys();
			var existingDistributors:Array = distributorMap.getValues();
			var i:Number;
			for (i=0; i<acceptedTypes.length; i++) {
				if (l instanceof acceptedTypes[i]) {
					existingDistributors[i].removeListener(l);
				}
			}
			ArrayUtil.removeElement(listeners, l);
		}
	}
	
	/**
	 * Adds a list of listeners to listen to the event.
	 * 
	 * @param list List of listeners to add.
	 * @throws IllegalArgumentException if any listener is not accepted
	 *         (the listeners before the certain listener will be added) 
	 */
	public function addAllListeners(list:Array):Void {
		for (var i=0; i<list.length; i++) {
			addListener(list[i]);
		}
	}
	
	/**
	 * Removes all added listeners.
	 */
	public function removeAllListeners(Void):Void {
		var i:Number;
		var list:Array = getAllListeners();
		for (i=0; i<list.length; i++) {
			removeListener(list[i]);
		}
	}
	
	/**
	 * Returns a list that contains all listeners
	 * 
	 * @return list that contains all listeners
	 */
	public function getAllListeners(Void):Array {
		return listeners.concat();
	}
	
	/**
	 * Checks if a listener is already added.
	 * 
	 * @return true if the listener has been added
	 */
	public function hasListener(listener):Boolean {
		return ArrayUtil.contains(listeners, listener);
	}
	
	/**
	 * Adds acception for a certain listener type.
	 * <p>{@code addListener} does not allow listeners that don't match (instanceof)
	 * any accepted listener type.
	 * 
	 * @param type Type of listener that should be accepted.
	 */
	public function acceptListenerType(type:Function):Void {
		if (!distributorMap.get(type)) {
			var distri:EventDistributorControl = eventDistributorControlFactory.createEventDistributorControl(type);
			var i:Number;
			for (i=0; i<listeners.length; i++) {
				if (listeners[i] instanceof type) {
					distri.addListener(listeners[i]);
				}
			}
			distributorMap.put(type, distri);
		}
	}
	
	/**
	 * Returns the distributor that contains all listeners match to the applied type. 
	 * 
	 * @return Distributor for distributing the event
	 * @throws org.as2lib.env.except.IllegalArgumentException
	 */
	public function getDistributor(type:Function) {
		var distri:EventDistributorControl = distributorMap.get(type);
		if (distri === null  || distri === undefined) {
			throw new IllegalArgumentException(ReflectUtil.getTypeName(type)+" is no supported distributor type", this, arguments);
		}
		return distri.getDistributor(type);
	}
	
	/**
	 * Replaces the default internal distributor with a different implementation.
	 * <p>If you have a event that should be executed with a different kind of distributor
	 * you can set it with this method (for example: consumable/not consumable).
	 * 
	 * <p>It will take the {@link EventDistributorControl#getType) type to to 
	 * define the type its used for.
	 * 
	 * <p>All existing references to the former distributor will have to get updated,
	 * else they won't get any new listeners!
	 * 
	 * @param eventDistributorControl Control to be used for event distribution.
	 * @see #setDefaultEventDistributorControl
	 * @throws IllegalArgumentException if the type is not accepted.
	 */
	public function setEventDistributorControl(eventDistributorControl:EventDistributorControl):Void  {
		if (eventDistributorControl != null) {
			var i:Number;
			var type:Function = eventDistributorControl.getType();
			eventDistributorControl.removeAllListeners();
			for (i=0; i<listeners.length; i++) {
				if (listeners[i] instanceof type) {
					eventDistributorControl.addListener(listeners[i]);
				}
			}	
			distributorMap.put(type, eventDistributorControl);
		} else {
			throw new IllegalArgumentException("distributorControl is not of any possible type.", this, arguments);
		}
	}
	
	/**
	 * Replaces a custom event distributor with a default event distributor.
	 * 
	 * @param type Type to set to a default distributor control.
	 * @throws IllegalArgumentException if the type is not accepted.
	 */
	public function setDefaultEventDistributorControl(type:Function):Void {
		var control:EventDistributorControl = distributorMap.remove(type);
		if (control === undefined || control === null) {
			throw new IllegalArgumentException(ReflectUtil.getTypeNameForType(type)+" is not accepted as listener type", this, arguments);
		}
		acceptListenerType(type);
	}
}