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
import org.as2lib.test.mock.support.SimpleMockControl;
import org.as2lib.env.event.SpeedEventBroadcaster;
import org.as2lib.env.event.EventListener;
import org.as2lib.env.event.EventInfo;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.event.TSpeedEventBroadcaster extends TestCase {
	
	public function testDispatchWithNullEventInfo(Void):Void {
		var lc:SimpleMockControl = new SimpleMockControl(EventListener);
		var l:EventListener = lc.getMock();
		lc.replay();
		
		var b:SpeedEventBroadcaster = new SpeedEventBroadcaster();
		b.addListener(l);
		b.addListener(l);
		b.dispatch(null);
		
		lc.verify(this);
	}
	
	public function testDispatchWithNullName(Void):Void {
		var ec:SimpleMockControl = new SimpleMockControl(EventInfo);
		var e:EventInfo = ec.getMock();
		e.getName();
		ec.setReturnValue(null);
		ec.replay();
		
		var lc:SimpleMockControl = new SimpleMockControl(EventListener);
		var l:EventListener = lc.getMock();
		lc.replay();
		
		var b:SpeedEventBroadcaster = new SpeedEventBroadcaster();
		b.addListener(l);
		b.addListener(l);
		b.addListener(l);
		b.dispatch(e);
		
		lc.verify(this);
		ec.verify(this);
	}
	
	public function testDispatchWithMultipleListeners(Void):Void {
		var ec:SimpleMockControl = new SimpleMockControl(EventInfo);
		var e:EventInfo = ec.getMock();
		e.getName();
		ec.setReturnValue("toString");
		ec.replay();
		
		var lc:SimpleMockControl = new SimpleMockControl(EventListener);
		var l:EventListener = lc.getMock();
		l.toString(e);
		lc.setVoidCallable(3);
		lc.replay();
		
		var b:SpeedEventBroadcaster = new SpeedEventBroadcaster();
		b.addListener(l);
		b.addListener(l);
		b.addListener(l);
		b.dispatch(e);
		
		lc.verify(this);
		ec.verify(this);
	}
	
	public function testAddListenerWithNullArgument(Void):Void {
		var b:SpeedEventBroadcaster = new SpeedEventBroadcaster();
		b.addListener(null);
		b.addListener(null);
		b.addListener(null);
		assertSame(b.getAllListener().length, 0);
	}
	
	public function testAddListener(Void):Void {
		var l1:EventListener = new EventListener();
		var l2:EventListener = new EventListener();
		var l3:EventListener = new EventListener();
		
		var b:SpeedEventBroadcaster = new SpeedEventBroadcaster();
		b.addListener(l1);
		b.addListener(l2);
		b.addListener(l3);
		assertSame(b.getAllListener().length, 3);
		assertSame(b.getAllListener()[0], l1);
		assertSame(b.getAllListener()[1], l2);
		assertSame(b.getAllListener()[2], l3);
	}
	
	public function testRemoveWithUnknownListener(Void):Void {
		var l1:EventListener = new EventListener();
		var l2:EventListener = new EventListener();
		var l3:EventListener = new EventListener();
		
		var b:SpeedEventBroadcaster = new SpeedEventBroadcaster();
		b.addListener(l1);
		b.addListener(l2);
		b.addListener(l3);
		b.removeListener(new EventListener());
		
		assertSame(b.getAllListener().length, 3);
		assertSame(b.getAllListener()[0], l1);
		assertSame(b.getAllListener()[1], l2);
		assertSame(b.getAllListener()[2], l3);
	}
	
	public function testRemoveWithNullListener(Void):Void {
		var l1:EventListener = new EventListener();
		var l2:EventListener = new EventListener();
		var l3:EventListener = new EventListener();
		
		var b:SpeedEventBroadcaster = new SpeedEventBroadcaster();
		b.addListener(l1);
		b.addListener(l2);
		b.addListener(l3);
		b.removeListener(null);
		
		assertSame(b.getAllListener().length, 3);
		assertSame(b.getAllListener()[0], l1);
		assertSame(b.getAllListener()[1], l2);
		assertSame(b.getAllListener()[2], l3);
	}
	
	public function testRemoveListener(Void):Void {
		var l1:EventListener = new EventListener();
		var l2:EventListener = new EventListener();
		var l3:EventListener = new EventListener();
		
		var b:SpeedEventBroadcaster = new SpeedEventBroadcaster();
		b.addListener(l1);
		b.addListener(l2);
		b.addListener(l3);
		assertSame(b.getAllListener().length, 3);
		assertSame(b.getAllListener()[0], l1);
		assertSame(b.getAllListener()[1], l2);
		assertSame(b.getAllListener()[2], l3);
		b.removeListener(l2);
		assertSame(b.getAllListener()[0], l1);
		assertSame(b.getAllListener()[1], l3);
		b.removeListener(l1);
		assertSame(b.getAllListener()[0], l3);
		b.removeListener(l3);
		assertSame(b.getAllListener().length, 0);
	}
	
	public function testRemoveAllListener(Void):Void {
		var b:SpeedEventBroadcaster = new SpeedEventBroadcaster();
		b.addListener(new EventListener());
		b.addListener(new EventListener());
		b.addListener(new EventListener());
		assertSame(b.getAllListener().length, 3);
		b.removeAllListener();
		assertSame(b.getAllListener().length, 0);
	}
	
}