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

import org.as2lib.test.mock.MockControl;
import org.as2lib.env.event.EventListener;
import org.as2lib.env.event.broadcaster.EventBroadcaster;
import org.as2lib.env.event.broadcaster.ConsumableEventBroadcaster;
import org.as2lib.env.event.broadcaster.ConsumableEventInfo;
import org.as2lib.env.event.broadcaster.AbstractTEventBroadcaster;
import org.as2lib.env.event.broadcaster.SampleConsumableEventListener;

class org.as2lib.env.event.broadcaster.AbstractTConsumableEventBroadcaster extends AbstractTEventBroadcaster {
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	private function getEventBroadcaster(Void):EventBroadcaster {
		return getConsumableEventBroadcaster();
	}
	
	private function getConsumableEventBroadcaster(Void):ConsumableEventBroadcaster {
		return null;
	}
	
	public function testDispatchWithConsumableEventInfo(Void):Void {
		var eb:ConsumableEventBroadcaster = getConsumableEventBroadcaster();
		
		var infoControl:MockControl = new MockControl(ConsumableEventInfo);
		var info:ConsumableEventInfo = infoControl.getMock();
		info.getName();
		infoControl.setReturnValue("onTest");
		info.isConsumed();
		infoControl.setReturnValue(false);
		infoControl.setReturnValue(false);
		infoControl.setReturnValue(true);
		infoControl.replay();
		
		var list1Control:MockControl = new MockControl(SampleConsumableEventListener);
		var list1:SampleConsumableEventListener = list1Control.getMock();
		list1.onTest(info);
		list1Control.replay();
		
		var list2Control:MockControl = new MockControl(SampleConsumableEventListener);
		var list2:SampleConsumableEventListener = list2Control.getMock();
		list2.onTest(info);
		list2Control.replay();
		
		var list3Control:MockControl = new MockControl(SampleConsumableEventListener);
		var list3:SampleConsumableEventListener = list3Control.getMock();
		list3Control.replay();
		
		var list4Control:MockControl = new MockControl(SampleConsumableEventListener);
		var list4:SampleConsumableEventListener = list4Control.getMock();
		list4Control.replay();
		
		eb.addListener(list1);
		eb.addListener(list2);
		eb.addListener(list3);
		eb.addListener(list4);
		eb.dispatch(info);
		
		infoControl.verify();
		list1Control.verify();
		list2Control.verify();
		list3Control.verify();
		list4Control.verify();
	}
	
	/*
	public function testDelegateConsumable(Void):Void {
		var eb:DelegatingConsumableEventBroadcaster = getDelegatingConsumableEventBroadcaster();
		
		var infoControl:MockControl = new MockControl(ConsumableEventInfo);
		var info:ConsumableEventInfo = infoControl.getMock();
		
		var list1Control:MockControl = new MockControl(SampleEventListener);
		var list1:SampleEventListener = list1Control.getMock();
		list1Control.replay();
		
		eb.addListener(list1);
		eb.addListener(list2);
		
		var dispatcherControl:MockControl = new MockControl(ConsumableEventDispatcher);
		var dispatcher:ConsumableEventDispatcher = dispatcherControl.getMock();
		
		dispatcher.dispatchConsumable(eb.getAllListeners());
		
		eb.setDispatcher(dispatcher);
		eb.broadcastConsumable(info);
		
		dispatcherControl.verify();
		infoControl.verify();
		list1Control.verify();
		list2Control.verify();
	}*/
	
}