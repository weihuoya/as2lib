﻿/*
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
import org.as2lib.test.mock.MockControl;
import org.as2lib.env.event.multicaster.EventMulticaster;
import org.as2lib.env.event.multicaster.SampleEventListener;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.event.multicaster.AbstractTEventMulticaster extends TestCase {
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	private function getEventMulticaster(eventName:String):EventMulticaster {
		return null;
	}
	
	public function testDispatchWithMultipleListeners(Void):Void {
		var s:String = new String("testString");
		var o:Object = new Object();
		var n:Number = 2;
		
		var lc:MockControl = new MockControl(SampleEventListener);
		var l:SampleEventListener = lc.getMock();
		l.onTest(s, o, n);
		lc.replay();
		
		var lc2:MockControl = new MockControl(SampleEventListener);
		var l2:SampleEventListener = lc2.getMock();
		l2.onTest(s, o, n);
		lc2.replay();
		
		var b:EventMulticaster = getEventMulticaster("onTest");
		b.addListener(l);
		b.addListener(l2);
		b.dispatch(s, o, n);
		
		lc.verify();
		lc2.verify();
	}
	
	public function testDispatchWithExceptionThrowingListener(Void):Void {		
		var s:String = new String("testString");
		var o:Object = new Object();
		var n:Number = 2;
		
		var lc:MockControl = new MockControl(SampleEventListener);
		var l:SampleEventListener = lc.getMock();
		l.onTest(s, o, n);
		lc.setDefaultVoidCallable();
		lc.replay();
		
		var error:Error = new Error("error");
		
		var lc2:MockControl = new MockControl(SampleEventListener);
		var l2:SampleEventListener = lc2.getMock();
		l2.onTest(s, o, n);
		lc2.setThrowable(error);
		lc2.replay();
		
		var b:EventMulticaster = getEventMulticaster("onTest");
		b.addListener(l);
		b.addListener(l2);
		try {
			b.dispatch(s, o, n);
			fail("expected org.as2lib.env.event.EventExecutionException exception");
		} catch (exception:org.as2lib.env.event.EventExecutionException) {
			assertSame("cause not initialized correctly", exception.getCause(), error);
		}
		
		lc.verify();
		lc2.verify();
	}
	
}