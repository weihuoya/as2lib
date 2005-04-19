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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.AbstractOperationException;

/**
 * {@code AbstractEventDistributionService} offers default implementations of
 * methods needed when implementing the {@link EventDistributionService} interface
 * or any sub-interface.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.event.AbstractEventDistributionService extends BasicClass {
	
	/** The expected listener type. */
	private var t:Function;
	
	/** All added listeners. */
	private var l:Array;
	
	/** Determines whether to check for the correct listener type. */
	private var c:Boolean;
	
	/** The distributor to distribute events. */
	private var d;
	
	/**
	 * Constructs a new {@code AbstractEventDistributionService} instance.
	 *
	 * <p>{@code checkListenerType} is by default set to {@code true}.
	 *
	 * @param listenerType the expected type of listeners
	 * @param checkListenerType determines whether to check that passed-in listeners
	 * are of the expected type
	 * @throws IllegalArgumentException if the passed-in {@code listenerType} is
	 * {@code null} or {@code undefined}
	 */
	public function AbstractEventDistributionService(listenerType:Function, checkListenerType:Boolean) {
		if (!listenerType) throw new IllegalArgumentException("Argument 'listenerType' [" + listenerType + "] must not be 'null' nor 'undefined'.", this, arguments);
		this.t = listenerType;
		this.c = checkListenerType == null ? true : checkListenerType;
		this.l = new Array();
	}
	
	/**
	 * Adds the passed-in {@code listener}.
	 *
	 * <p>The listener will only be added if it is not {@code null} nor {@code undefined}
	 * and if it is of the expected listener type specified on construction.
	 *
	 * <p>Note that if the passed-in {@code listener} has already been added the
	 * previously added one will be removed.
	 *
	 * <p>Note also that the listener type will not be checked if it was turned of on
	 * construction.
	 * 
	 * @param listener the listener to add
	 * @throws IllegalArgumentException if the passed-in {@code listener} is not of the
	 * expected type specified on construction
	 */
	public function addListener(listener):Void {
		if (listener) {
			if (this.c) {
				if (!(listener instanceof this.t)) {
					throw new IllegalArgumentException("Argument 'listener' [" + listener + "] must be an instance of the expected listener type [" + this.t + "].", this, arguments);
				}
			}
			removeListener(listener);
			this.l.push(listener);
		}
	}
	
	/**
	 * Adds all listeners contained in the passed-in {@code listeners} array.
	 *
	 * <p>If the passed-in {@code listeners} array is {@code null} or {@code undefined}
	 * it will be ignored.
	 *
	 * <p>The individual listeners must be instances of the type specified on
	 * construction. If an individual listener is {@code null} or {@code undefined} it
	 * will be ignored.
	 *
	 * <p>All listeners that are of the correct type will be added.
	 * 
	 * <p>Note that the listener type will not be checked if it was turned of on
	 * construction.
	 *
	 * <p>Note also that the order of the listeners contained in the passed-in
	 * {@code listeners} array is preserved.
	 *
	 * @param listeners the listeners to add
	 * @throws IllegalArgumentException if at least one listener in the passed-in
	 * {@code listeners} array is not of the expected type specified on construction
	 * @see #addListener
	 */
	public function addAllListeners(listeners:Array):Void {
		if (listeners) {
			if (this.c) {
				var exceptions:Array;
				var h:Number = listeners.length;
				// the original order of the passed-in 'listeners' is preserved
				for (var i:Number = 0; i < h; i++) {
					try {
						addListener(listeners[i]);
					} catch (e:org.as2lib.env.except.IllegalArgumentException) {
						// this case probably hardly ever occurs; the array is thus only instantiated if
						// really necessary
						if (!exceptions) exceptions = new Array();
						exceptions.push(e);
					}
				}
				if (exceptions) {
					// source this out in own exception; maybe IllegalListenerException?
					var message:String = IllegalArgumentException(exceptions[0]).getMessage();
					for (var k:Number = 1; k < exceptions.length; k++) {
						message += IllegalArgumentException(exceptions[k]).getMessage();
					}
					throw new IllegalArgumentException(message, this, arguments);
				}
			} else {
				var h:Number = listeners.length;
				// the original order of the passed-in 'listeners' is preserved
				for (var i:Number = 0; i < h; i++) {
					addListener(listeners[i]);
				}
			}
		}
	}
	
	/**
	 * Removes the passed-in {@code listener}.
	 *
	 * <p>The removal will be ignored if the passed-in {@code listener} is {@code null}
	 * or {@code undefined}.
	 * 
	 * @param listener the listener to remove
	 */
	public function removeListener(listener):Void {
		if (listener) {
			var i:Number = this.l.length;
			while (--i > -1) {
				if (this.l[i] == listener) {
					this.l.splice(i, 1);
					return;
				}
			}
		}
	}
	
	/**
	 * Removes all added listeners.
	 */
	public function removeAllListeners(Void):Void {
		this.l = new Array();
	}
	
	/**
	 * Returns all added listeners that are of the type specified on construction.
	 * 
	 * @return all added listeners
	 */
	public function getAllListeners(Void):Array {
		return this.l.concat();
	}
	
	/**
	 * Returns the distributor to distribute the event to all added listeners.
	 *
	 * <p>The returned distributor can be casted to the type specified on construction.
	 * You can then invoke the event method on it to distribute it to all added
	 * listeners. This event distribution approach has the advantage of proper
	 * compile-time type-checking.
	 *
	 * <p>The returned distributor throws an {@link EventExecutionException} on
	 * distribution if an event method of a listener threw an exception.
	 * 
	 * <p>This method does always return the same distributor.
	 * 
	 * @return the distributor to distribute the event
	 */
	public function getDistributor(Void) {
		if (!this.d) this.d = createDistributor();
		return this.d;
	}
	
	/**
	 * Creates a new distributor based on the listener type specified on construction.
	 *
	 * <p>The catching of methods called on the returned distributor takes place using
	 * {@code __resolve}. This method then invokes the {@link distribute} method with
	 * the name of the called method and the arguments used for the method call.
	 * 
	 * @return the new distributor
	 */
	private function createDistributor(Void) {
		var result = new Object();
		result.__proto__ = this.t.prototype;
		result.__constructor__ = this.t;
		var e:AbstractEventDistributionService = this;
		var d:Function = e["distribute"];
		result.__resolve = function(n:String):Function {
			return (function():Void {
				d.apply(e, n, arguments);
			});
		}
		return result;
	}
	
	/**
	 * Executes the event with the given {@code eventName} on all added listeners, using
	 * the arguments after {@code eventName} as parameters.
	 * 
	 * @param eventName the name of the event method to execute on the added listeners
	 * @param args any number of arguments that are used as parameters on execution of
	 * the event on the listeners
	 * @throws EventExecutionException if an event method on a listener threw an
	 * exception
	 */
	private function distribute(eventName:String, args:Array):Void {
		throw new AbstractOperationException("This method is marked as abstract and must be overwritten.", this, arguments);
	}
	
}