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
import org.as2lib.env.log.LogSupport;
import org.as2lib.env.event.distributor.CompositeEventDistributorControl;
import org.as2lib.env.event.distributor.SimpleConsumableCompositeEventDistributorControl;

/**
 * {@code EventSupport} provides simple access to events.
 * 
 * <p>To apply event abilities to your class its only necessary to extend
 * {@code EventSupport}. It holds in the private instance variable {@code eventControl}
 * a reference to {@link SimpleConsumableCompositeEventDistributionControl}.
 * 
 * <p>To allow additional listener types to be checked by {@link #addListener},
 * {@link #addAddListener} its only necessary to add {@code acceptListenerType(AnyType);}
 * within the constructor of the extended class.
 * 
 * <p>It is necessary for sending a event to recieve the matching distributor with
 * {@code eventControl.getDistributor(AnyType)} and execute the event to it.
 * 
 * <p>Example code:
 * <code>
 *   class Controller extends EventSupport {
 *   
 *     private var model:Model;
 *     private var event:View;
 *     
 *     public function Controller(Void) {
 *       eventControl.acceptListenerType(View);
 *       event = eventControl.getDistributor(View);
 *     }
 *     
 *     public function setTargetModel(model:Model) {
 *       this.model = model;
 *       event.onTargetModelChanged(this);
 *     }
 *     
 *     public function getTargetModel(Void):Model {
 *     	 return model;
 *     }
 *   }
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.env.event.EventSupport extends LogSupport implements EventListenerSource {
	
	/** Access to event control */
	private var eventControl:CompositeEventDistributorControl;
	
	/**
	 * Constructs a new {@code EventSupport} instance.
	 */
	function EventSupport(Void) {
		eventControl = new SimpleConsumableCompositeEventDistributorControl();
	}

	/**
	 * Adds the passed-in {@code listener} to be executed by events.
	 * 
	 * @param listener the listener to add
	 * @throws IllegalArgumentException if the listener does not match any expected type
	 */
	public function addListener(listener):Void {
		eventControl.addListener(listener);
	}	

	/**
	 * Adds all listener contained in the passed-in {@code listeners} array.
	 * 
	 * <p>All listeners get added after each other. If one listener does not match
	 * any expected type the rest of the listeners will not be added an a exception
	 * will raise.
	 * 
	 * @param listeners the list of listeners to add
	 * @throws IllegalArgumentException if any listener does not match any expected type
	 */
	public function addAllListeners(listeners:Array):Void {
		eventControl.addAllListeners(listeners);
	}


	/**
	 * Removes the passed-in {@code listener} from beeing executed by events.
	 * 
	 * @param listener the listener to remove
	 */
	public function removeListener(listener):Void {
		eventControl.removeListener(listener);
	}

	/**
	 * Removes all listeners from beeing executed by events.
	 */
	public function removeAllListeners(Void):Void {
		eventControl.removeAllListeners();
	}

	/**
	 * Getter for the list of all added listeners.
	 * 
	 * <p>This method returns a copy (not a reference) of the list of all added
	 * listeners.
	 * 
	 * @return list that contains all added listeners
	 */
	public function getAllListeners(Void):Array {
		return eventControl.getAllListeners();
	}

	/**
	 * Checks if the passed-in {@code listener} has been added.
	 * 
	 * @return {@code true} if the listener has been added
	 */
	public function hasListener(listener):Boolean {
		return eventControl.hasListener(listener);
	}
}