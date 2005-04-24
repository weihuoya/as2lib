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
import org.as2lib.env.event.broadcaster.EventBroadcaster;
import org.as2lib.test.mock.MockControl;
import org.as2lib.env.event.EventListener;
import org.as2lib.env.event.broadcaster.EventInfo;
import org.as2lib.env.event.broadcaster.SampleEventListener;

class org.as2lib.env.event.broadcaster.AbstractTEventBroadcaster extends TestCase {
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	private function getEventBroadcaster(Void):EventBroadcaster {
		return null;
	}
	
	private function getEventListener(Void):EventListener {
		var result = new Object();
		result.__proto__ = EventListener["prototype"];
		return result;
	}
	
	public function testDispatchWithNullEventInfo(Void):Void {
		var l1c:MockControl = new MockControl(EventListener);
		var l1:EventListener = l1c.getMock();
		l1c.replay();
		
		var l2c:MockControl = new MockControl(SampleEventListener);
		var l2:EventListener = l2c.getMock();
		l2c.replay();
		
		var b:EventBroadcaster = getEventBroadcaster();
		b.addListener(l1);
		b.addListener(l2);
		b.dispatch(null);
		
		l1c.verify();
		l2c.verify();
	}
	
	// error with simple event broadcaster
	public function testDispatchWithNullName(Void):Void {
		var ec:MockControl = new MockControl(EventInfo);
		var e:EventInfo = ec.getMock();
		e.getName();
		ec.setReturnValue(null);
		ec.replay();
		
		var l1c:MockControl = new MockControl(SampleEventListener);
		var l1:EventListener = l1c.getMock();
		l1c.replay();
		
		var l2c:MockControl = new MockControl(SampleEventListener);
		var l2:EventListener = l2c.getMock();
		l2c.replay();
		
		var b:EventBroadcaster = getEventBroadcaster();
		b.addListener(l1);
		b.addListener(l2);
		b.dispatch(e);
		
		l1c.verify();
		l2c.verify();
		ec.verify();
	}
	
	public function testDispatchWithEmptyStringName(Void):Void {
		var ec:MockControl = new MockControl(EventInfo);
		var e:EventInfo = ec.getMock();
		e.getName();
		ec.setReturnValue("");
		ec.replay();
		
		var l1c:MockControl = new MockControl(SampleEventListener);
		var l1:EventListener = l1c.getMock();
		l1c.replay();
		
		var l2c:MockControl = new MockControl(SampleEventListener);
		var l2:EventListener = l2c.getMock();
		l2c.replay();
		
		var b:EventBroadcaster = getEventBroadcaster();
		b.addListener(l1);
		b.addListener(l2);
		b.dispatch(e);
		
		l1c.verify();
		l2c.verify();
		ec.verify();
	}
	
	// error with simple event broadcaster
	public function testDispatchWithMultipleListeners(Void):Void {
		var ec:MockControl = new MockControl(EventInfo);
		var e:EventInfo = ec.getMock();
		e.getName();
		ec.setReturnValue("onTest");
		ec.replay();
		
		var lc:MockControl = new MockControl(SampleEventListener);
		var l:SampleEventListener = lc.getMock();
		l.onTest(e);
		lc.replay();
		
		var lc2:MockControl = new MockControl(SampleEventListener);
		var l2:SampleEventListener = lc2.getMock();
		l2.onTest(e);
		lc2.replay();
		
		var b:EventBroadcaster = getEventBroadcaster();
		b.addListener(l);
		b.addListener(l2);
		b.dispatch(e);
		
		lc.verify();
		lc2.verify();
		ec.verify();
	}
	
	public function testDispatchWithExceptionThrowingListener(Void):Void {
		var ec:MockControl = new MockControl(EventInfo);
		var e:EventInfo = ec.getMock();
		e.getName();
		ec.setReturnValue("onTest");
		ec.replay();
		
		var lc:MockControl = new MockControl(SampleEventListener);
		var l:SampleEventListener = lc.getMock();
		l.onTest(e);
		lc.replay();
		
		var error:Error = new Error("error");
		
		var lc2:MockControl = new MockControl(SampleEventListener);
		var l2:SampleEventListener = lc2.getMock();
		l2.onTest(e);
		lc2.setThrowable(error);
		lc2.replay();
		
		var b:EventBroadcaster = getEventBroadcaster();
		b.addListener(l);
		b.addListener(l2);
		try {
			b.dispatch(e);
			fail("expected org.as2lib.env.event.EventExecutionException exception");
		} catch (exception:org.as2lib.env.event.EventExecutionException) {
			assertSame("cause not initialized correctly", exception.getCause(), error);
		}
		
		lc.verify();
		lc2.verify();
		ec.verify();
	}
	
	/*public function testAddListenerWithNullArgument(Void):Void {
		var b:EventBroadcaster = getEventBroadcaster();
		b.addListener(null);
		b.addListener(null);
		b.addListener(null);
		assertSame(b.getAllListeners().length, 0);
	}
	
	public function testAddListener(Void):Void {
		var l1:EventListener = getEventListener();
		var l2:EventListener = getEventListener();
		var l3:EventListener = getEventListener();
		
		var b:EventBroadcaster = getEventBroadcaster();
		b.addListener(l1);
		b.addListener(l2);
		b.addListener(l3);
		assertSame(b.getAllListeners().length, 3);
		assertSame(b.getAllListeners()[0], l1);
		assertSame(b.getAllListeners()[1], l2);
		assertSame(b.getAllListeners()[2], l3);
	}
	
	public function testRemoveWithUnknownListener(Void):Void {
		var l1:EventListener = getEventListener();
		var l2:EventListener = getEventListener();
		var l3:EventListener = getEventListener();
		
		var b:EventBroadcaster = getEventBroadcaster();
		b.addListener(l1);
		b.addListener(l2);
		b.addListener(l3);
		b.removeListener(getEventListener());
		
		assertSame(b.getAllListeners().length, 3);
		assertSame(b.getAllListeners()[0], l1);
		assertSame(b.getAllListeners()[1], l2);
		assertSame(b.getAllListeners()[2], l3);
	}
	
	public function testRemoveWithNullListener(Void):Void {
		var l1:EventListener = getEventListener();
		var l2:EventListener = getEventListener();
		var l3:EventListener = getEventListener();
		
		var b:EventBroadcaster = getEventBroadcaster();
		b.addListener(l1);
		b.addListener(l2);
		b.addListener(l3);
		b.removeListener(null);
		
		assertSame(b.getAllListeners().length, 3);
		assertSame(b.getAllListeners()[0], l1);
		assertSame(b.getAllListeners()[1], l2);
		assertSame(b.getAllListeners()[2], l3);
	}
	
	public function testRemoveListener(Void):Void {
		var l1:EventListener = getEventListener();
		var l2:EventListener = getEventListener();
		var l3:EventListener = getEventListener();
		
		var b:EventBroadcaster = getEventBroadcaster();
		b.addListener(l1);
		b.addListener(l2);
		b.addListener(l3);
		assertSame(b.getAllListeners().length, 3);
		assertSame(b.getAllListeners()[0], l1);
		assertSame(b.getAllListeners()[1], l2);
		assertSame(b.getAllListeners()[2], l3);
		b.removeListener(l2);
		assertSame(b.getAllListeners()[0], l1);
		assertSame(b.getAllListeners()[1], l3);
		b.removeListener(l1);
		assertSame(b.getAllListeners()[0], l3);
		b.removeListener(l3);
		assertSame(b.getAllListeners().length, 0);
	}
	
	public function testRemoveAllListener(Void):Void {
		var b:EventBroadcaster = getEventBroadcaster();
		b.addListener(getEventListener());
		b.addListener(getEventListener());
		b.addListener(getEventListener());
		assertSame(b.getAllListeners().length, 3);
		b.removeAllListeners();
		assertSame(b.getAllListeners().length, 0);
	}*/
	
}