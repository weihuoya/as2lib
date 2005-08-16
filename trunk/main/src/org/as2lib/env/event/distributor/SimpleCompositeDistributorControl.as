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

import org.as2lib.env.event.distributor.AbstractCompositeDistributorControl;
import org.as2lib.env.event.distributor.CompositeDistributorControl;
import org.as2lib.env.event.distributor.SimpleEventDistributorControlFactory;

/**
 * {@code SimpleEventDistributorControl} acts as a listener source and event
 * distributor control. It enables you to distribute and handle events in the
 * safest way possible by providing a compiler-safe distributor.
 * 
 * <p>Example:
 * <code>
 *   // creates a distributor control with the expected listener type
 *   var distributorControl:SimpleEventDistributorControl = new SimpleEventDistributorControl(ErrorListener);
 *   // adds new listeners that must be of the expected type
 *   distributorControl.addListener(new MyErrorListener());
 *   distributorControl.addListener(new SimpleErrorListener());
 *   // gets a distributor to distribute the event to all listeners
 *   var distributor:ErrorListener = ErrorListener(distributorControl.getDistributor());
 *   // distributes the event with custom arguments
 *   distributor.onError(myErrorCode, myException);
 * </code>
 * 
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.env.event.distributor.SimpleCompositeDistributorControl extends AbstractCompositeDistributorControl implements CompositeDistributorControl {
	
	/**
	 * Constructs a new {@code SimpleEventDistributorControl} instance.
	 *
	 * <p>{@code checkListenerType} is by default set to {@code true}.
	 * 
	 * @param listenerType the expected type of listeners
	 * @param checkListenerType determines whether to check that passed-in listeners
	 * are of the expected type
	 * @param listeners (optional) the listeners to add
	 * @throws IllegalArgumentException if the passed-in {@code listenerType} is
	 * {@code null} or {@code undefined}
	 */
	public function SimpleCompositeDistributorControl(listenerType:Function, checkListenerType:Boolean, listeners:Array) {
		super (new SimpleEventDistributorControlFactory());
	}
	
}