
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
 * 
 * <p>The {@link EventDistributorControl} class allows only for handling of one type of
 * listeners while this {@code CompositeEventDistributor} class allows multiple types
 * of listeners to provide more granularity if many different kinds of listeners are
 * used. It holds a collection of accepted types of listeners and checks if the listener
 * added via the {@link #addListener} method matches any of the accepted types and adds
 * it to the correct event distributor control(s).
 *
 * <p>Class that uses the composites functionalities:
 * <code>
 *   import org.as2lib.env.event.distributor.SimpleConsumableCompositeEventDistributorControl;
 *   
 *   class MyClass extends SimpleConsumableCompositeEventDistributorControl {
 *      
 *     public function MyClass(Void) {
 *       acceptListenerType(MyListener);
 *     }
 *     
 *     public function customMethod(Void):Void {
 *       var e:MyListener = getDistributor(MyListener);
 *       e.onEvent("1", "2");
 *     }
 *      
 *   }
 * </code>
 * 
 * <p>Listener interface:
 * <code>
 *   interface MyListener {
 *     
 *     public function onEvent(contentA:String, contentB:String):Void;
 *     
 *   }
 * </code>
 * 
 * <p>Listener interface implementation:
 * <code>
 *   class SimpleMyListener implements MyListener {
 *     
 *     private var prefix:String;
 *     
 *     public function SimpleMyListener(prefix:String) {
 *       this.prefix = prefix;
 *     }
 *     
 *     public function onEvent(contentA:String, contentB:String):Void {
 *       trace(prefix + contentA + ", " + prefix + contentB);
 *     }
 *     
 *   }
 * </code>
 * 
 * <p>Usage:
 * <code>
 *   var myClass:MyClass = new MyClass();
 *   myClass.addListener(new SimpleMyListener("a"));
 *   myClass.addListener(new SimpleMyListener("b"));
 *   // traces "a1, a2" and "b1, b2";
 *   myClass.customMethod();
 *   
 *   // throws an exception because listeners of type "Array" are not accepted
 *   myClass.addListener(new Array());
 * </code>
 * 
 * @author Martin Heidegger
 */
interface org.as2lib.env.event.distributor.CompositeEventDistributorControl extends EventListenerSource {
	
	/**
	 * Returns the distributor for the given {@code type} that can be used to distribute
	 * events to all added listeners of the given {@code type}.
	 * 
	 * <p>The returned distributor can be casted to the given {@code type} (type-safe
	 * distribution of events).
	 * 
	 * @return the distributor to distribute events
	 */
	public function getDistributor(type:Function);
	
	/**
	 * Specifies that listeners of the given {@code type} are accepted, this includes
	 * implementations of the given {@code type} as well as its sub-classes.
	 * 
	 * <p>{@code addListener} does not allow listeners that do not match (instanceof)
	 * at least one accepted listener type.
	 * 
	 * @param type the type of listeners that can be added
	 */
	public function acceptListenerType(type:Function):Void;
	
	/**
	 * Replaces the default internal distributor with a different implementation.
	 * 
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