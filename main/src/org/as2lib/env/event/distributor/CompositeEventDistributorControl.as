
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

import org.as2lib.env.event.EventListenerSource;
import org.as2lib.env.event.distributor.EventDistributorControl;

/**
 * {@code CompositeEventDistributorControl} allows flexible usage of events for complex class models.
 * <p>{@link EventDistributorControl} allows only handling of one certain listener.
 * {@code CompositeEventDistributor} allows multiple types of listeners to provide
 * more granularity if many different kind of listeners are used. It holds a list
 * of accepted types for listeners and checks if the listener added with {@link #addListener}
 * matches the certain class.
 *
 * Example Class that uses the Composites functionality:
 * <code>
 *   import org.as2lib.env.event.distributor.SimpleConsumableCompositeEventDistributorControl;
 *   
 *   class MyClass extends SimpleConsumableCompositeEventDistributorControl {
 *      
 *      public function MyClass() {
 *      	acceptListenerType(MyListenerInterface);
 *      }
 *      
 *      public function customMethod(Void):Void {
 *          var e:MyListenerInterface = getDistributor(MyListenerInterface)
 *          e.onEvent("1", "2");
 *      }
 *      
 *   }
 * </code>
 * 
 * Example Listener
 * <code>
 *   interface MyListenerInterface {
 *   	public function onEvent(contentA:String, contentB:String):Void;
 *   }
 *   
 *   class MyListener implements MyListenerInterface {
 *   	private var prefix:String;
 *   	public function MyListener(prefix:String) {
 *   		this.prefix = prefix;
 *   	}
 *   	public function onEvent(contentA:String, contentB:String):Void {
 *   		trace(prefix+contentA+","prefix+contentB);
 *   	}
 *   }
 * </code>
 * 
 * Example Usage
 * <code>
 *   var myClass:MyClass = new MyClass();
 *   myClass.addListener(new MyListener("a"));
 *   myClass.addListener(new MyListener("b"));
 *   myClass.customMethod(); // will trace "a1,a2" and "b1,b2";
 *   
 *   // will throw a exception because this listener Array type is not accepted
 *   myClass.addListener(new Array());
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.env.event.distributor.CompositeEventDistributorControl extends EventListenerSource {
	
	/**
	 * Returns the distributor that contains all listeners match to the applied type. 
	 * 
	 * @return Distributor for distributing the event
	 * @throws org.as2lib.env.except.IllegalArgumentException
	 */
	public function getDistributor(type:Function);
	
	/**
	 * Adds acception for a certain listener type.
	 * <p>{@code addListener} does not allow listeners that don't match (instanceof)
	 * any accepted listener type.
	 * 
	 * @param type Type of listener that should be accepted.
	 */
	public function acceptListenerType(type:Function):Void;
	
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
	public function setEventDistributorControl(eventDistributorControl:EventDistributorControl):Void;
	
	/**
	 * Replaces a custom event distributor with a default event distributor.
	 * 
	 * @param type Type to set to a default distributor control.
	 * @throws IllegalArgumentException if the type is not accepted.
	 */
	public function setDefaultEventDistributorControl(type:Function):Void;
}