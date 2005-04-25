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
import org.as2lib.env.event.multicaster.EventMulticaster;
import org.as2lib.env.event.multicaster.ConsumableEventMulticaster;
import org.as2lib.env.event.multicaster.AbstractTEventMulticaster;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.event.multicaster.AbstractTConsumableEventMulticaster extends AbstractTEventMulticaster {
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	private function getEventMulticaster(eventName:String):EventMulticaster {
		return getConsumableEventMulticaster(eventName);
	}
	
	private function getConsumableEventMulticaster(eventName:String):ConsumableEventMulticaster {
		return null;
	}
	
	public function testDispatchWithConsumingListeners(Void):Void {
		var s:String = new String("testString");
		var o:Object = new Object();
		var n:Number = 2;
		
		var eb:ConsumableEventMulticaster = getConsumableEventMulticaster("onTest");
		
		var list1Control:MockControl = new MockControl(Object);
		var list1:Object = list1Control.getMock();
		list1.onTest(s, o, n);
		list1Control.replay();
		
		var list2Control:MockControl = new MockControl(Object);
		var list2:Object = list2Control.getMock();
		list2.onTest(s, o, n);
		list2Control.setReturnValue(null);
		list2Control.replay();
		
		var list3Control:MockControl = new MockControl(Object);
		var list3:Object = list3Control.getMock();
		list3.onTest(s, o, n);
		list3Control.setReturnValue(false);
		list3Control.replay();
		
		var list4Control:MockControl = new MockControl(Object);
		var list4:Object = list4Control.getMock();
		list4.onTest(s, o, n);
		list4Control.setReturnValue(true);
		list4Control.replay();
		
		var list5Control:MockControl = new MockControl(Object);
		var list5:Object = list5Control.getMock();
		list5Control.replay();
		
		var list6Control:MockControl = new MockControl(Object);
		var list6:Object = list6Control.getMock();
		list6Control.replay();
		
		eb.addListener(list1);
		eb.addListener(list2);
		eb.addListener(list3);
		eb.addListener(list4);
		eb.addListener(list5);
		eb.addListener(list6);
		eb.dispatch(s, o, n);
		
		list1Control.verify();
		list2Control.verify();
		list3Control.verify();
		list4Control.verify();
		list5Control.verify();
		list6Control.verify();
	}
	
}