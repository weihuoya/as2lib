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
 * The EventBroadcaster represents the Core of Eventhandling with the as2lib.
 * It allows as good typesafe work as possible. It allows fast broadcasting in a proper way.
 *
 * Its recommended to use the EventBroadcaster as implementation detail of a Observer
 * Design Pattern like in this example:
 *
 * Observer:
 * <code>
 * import org.as2lib.env.event.EventListener;
 *
 * interface Observer extends EventListener {
 *   public function onDoSomething(info:SomeInfo):Void;
 * }
 * </code>
 *
 * Event Information:
 * <code>
 * import org.as2lib.env.event.EventInfo;
 *
 * class SomeInfo implements EventInfo {
 *   private var observable:MyObservable;
 *   public function SomeInfo(observable:MyObservable) {
 *     this.observable = observable;
 *   }
 *   public function getSender(Void):MyObservable {
 *     return observable;
 *   }
 *   public function getName(Void):String {
 *     return "onDoSomething"; // Method to be called on the Observer.
 *   }
 * }
 * </code>
 *
 * Observable:
 * <code>
 * import org.as2lib.env.event.EventBroadcaster;
 * import org.as2lib.env.event.SimpleEventBroadcaster;
 *
 * class MyObservable {
 *    private var eb:EventBroadcaster;
 *    public function MyObservable(Void) {
 *      eb = new SimpleEventBroadcaster();
 *    }
 *    public function addObserver(o:Observer):Void {
 *      eb.addListener(o);
 *    }
 *    public function doSomething(Void):Void {
 *      eb.broadcast(new SomeInfo(this));
 *    }
 * }
 * </code>
 *
 * Observer Implementation:
 * <code>
 * class MyObserver implements Observer {
 *   public function onDoSomething(info:SomeInfo) {
 *     trace("doSomething listened by MyObserver at "+info.getSender());
 *   }
 * }
 * </code>
 * 
 * Useage:
 * <code>
 * var observable:MyObservable = new MyObservable();
 * observable.addObserver(new MyObserver());
 * observable.doSomething();
 * </code>
 *
 * This system is recommended where you wan't to ensure that
 * all listeners are typesafe used. This allows better teamwork
 * and Documentation of your methods and higher insurance against
 * missusing with compiletime checks.
 *
 * The {@link org.as2lib.env.event.TypeSafeEventBroadcaster} also
 * checks at runtime that only listeners of a special type can be
 * added but this will be slower.
 *
 * If you need to use consumable event informations you should take 
 * 
 * @author Martin Heidegger
 * @version 2.0
 *
 * @see org.as2lib.env.event.SimpleEventBroadcaster;
 * @see org.as2lib.env.event.TypeSafeEventBroadcaster;
 * @see org.as2lib.env.event.ConsumableEventBroadcaster;
 * @see org.as2lib.env.event.DelegatingEventBroadcaster;
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
	public function addAllListeners(listeners:Array):Void;
	
	/**
	 * Removes a listener from the pool of listeners.
	 * 
	 * @param listener the EventListener to be removed
	 */
	public function removeListener(listener:EventListener):Void;
	
	/**
	 * Removes all registered listeners.
	 */
	public function removeAllListeners(Void):Void;
	
	/**
	 * Returns a copy of the listener pool.
	 *
	 * @return a copy of the listener pool
	 */
	public function getAllListeners(Void):Array;
	
	/**
	 * Dispatches the events associated with the name cotained in the
	 * EventInfo instance.
	 * 
	 * @param event the EventInfo to be passed to the operation of the EventListeners
	 * @throws EventExecutionException if a Listener throws a Exception
	 */
	public function dispatch(event:EventInfo):Void;
	
}