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

import org.as2lib.test.unit.TestCase;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.DelegatingEventBroadcaster;
import org.as2lib.env.event.EventDispatcher;
import org.as2lib.test.mock.MockControl;
import org.as2lib.env.event.EventListener;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.SimpleEventInfo;
import org.as2lib.env.event.ConsumableEventInfo;
import org.as2lib.env.event.AbstractTEventBroadcaster;
import org.as2lib.env.event.SampleEventListener;

/**
 * Extension of AbstractTEventBroadcaster for implementations of the DelegatingEventBroadcaster interface.
 *
 * @author Martin Heidegger
 * @see org.as2lib.env.event.DelegatingEventBroadcaster
 */
class org.as2lib.env.event.AbstractTDelegatingEventBroadcaster extends AbstractTEventBroadcaster {
	
	/**
     * Blocks class from collecting by TestSuiteFactory.
	 */
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	/**
	 * Returns the used Eventbroadcaster implementation for AbstractTEventBroadcaster
	 * 
	 * @see AbstractTEventBroadcaster#getEventBroadcaster
	 * @return EventBroadcaster implementation
	 */
	private function getEventBroadcaster(Void):EventBroadcaster {
		return getDelegatingEventBroadcaster();
	}
	
	/**
     * Dummy implementation for concrete implementations of DelegatingEventBroadcaster.
	 * 
	 * @return Instance of DelegatingEventBroadcaster
	 */
	private function getDelegatingEventBroadcaster(Void):DelegatingEventBroadcaster {
		return null;
	}
	
	/**
     * Tests if the delegation works using a Mock.
	 */
	public function testDelegate(Void):Void {
		
		// Usual case, simple broadcasting with two listeners.
		var broadcaster:DelegatingEventBroadcaster = getDelegatingEventBroadcaster();
		var eventInfo:EventInfo = new SimpleEventInfo("on");
		var listener1:EventListener = new SampleEventListener();
		var listener2:EventListener = new SampleEventListener();
		
		var dispatcherControl:MockControl = new MockControl(EventDispatcher);
		var dispatcher:EventDispatcher = dispatcherControl.getMock();
		
		dispatcher.dispatch(eventInfo, [listener1, listener2]);
		dispatcherControl.replay();
		
		broadcaster.addListener(listener1);
		broadcaster.addListener(listener2);
		broadcaster.setDispatcher(dispatcher);
		broadcaster.dispatch(eventInfo);
		
		dispatcherControl.verify();
	}
	
	/**
     * Tests if the delegation works even for consumable events.
	 */
	public function testDelegateConsumable(Void):Void {
		
		// Usual case: Simple Broadcasting with two listeners
		var broadcaster:DelegatingEventBroadcaster = getDelegatingEventBroadcaster();
		var eventInfo:EventInfo = new ConsumableEventInfo("on");
		var listener1:EventListener = new SampleEventListener();
		var listener2:EventListener = new SampleEventListener();
		
		var dispatcherControl:MockControl = new MockControl(EventDispatcher);
		var dispatcher:EventDispatcher = dispatcherControl.getMock();
		dispatcher.dispatchConsumable(eventInfo, [listener1, listener2]);
		dispatcherControl.setReturnValue(null);
		dispatcherControl.replay();
		
		broadcaster.addListener(listener1);
		broadcaster.addListener(listener2);
		broadcaster.setDispatcher(dispatcher);
		broadcaster.dispatch(eventInfo);
		
		dispatcherControl.verify();
		
		// Verification that it even works with no available 
		
	}
}