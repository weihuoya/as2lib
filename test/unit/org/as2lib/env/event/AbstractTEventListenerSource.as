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
import org.as2lib.test.mock.MockControl;
import org.as2lib.env.event.EventListenerSource;
import org.as2lib.env.event.EventListener;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.event.AbstractTEventListenerSource extends TestCase {
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	private function getEventListenerSource(Void):EventListenerSource {
		return null;
	}
	
	public function testAddListenerWithNullArgument(Void):Void {
		var b:EventListenerSource = getEventListenerSource();
		b.addListener(null);
		b.addListener(null);
		b.addListener(null);
		assertSame(b.getAllListeners().length, 0);
	}
	
	public function testAddListenerWithTheSameListenerMultipleTimes(Void):Void {
		var s:EventListenerSource = getEventListenerSource();
		var l:Object = new Object();
		var l2:Object = new Object();
		s.addListener(l);
		s.addListener(l2);
		s.addListener(l);
		s.addListener(l);
		assertSame(s.getAllListeners().length, 2);
		assertSame(s.getAllListeners()[0], l2);
		assertSame(s.getAllListeners()[1], l);
	}
	
	public function testAddListener(Void):Void {
		var l1:Object = new Object();
		var l2:Object = new Object();
		var l3:Object = new Object();
		
		var b:EventListenerSource = getEventListenerSource();
		b.addListener(l1);
		b.addListener(l2);
		b.addListener(l3);
		assertSame(b.getAllListeners().length, 3);
		assertSame(b.getAllListeners()[0], l1);
		assertSame(b.getAllListeners()[1], l2);
		assertSame(b.getAllListeners()[2], l3);
	}
	
	public function testAddAllListenersWithNullArgument(Void):Void {
		var l1:Object = new Object();
		var l2:Object = new Object();
		var l3:Object = new Object();
		
		var b:EventListenerSource = getEventListenerSource();
		b.addAllListeners([l1, l2, l3]);
		assertSame(b.getAllListeners().length, 3);
		b.addAllListeners(null);
		assertSame(b.getAllListeners().length, 3);
		assertSame(b.getAllListeners()[0], l1);
		assertSame(b.getAllListeners()[1], l2);
		assertSame(b.getAllListeners()[2], l3);
	}
	
	public function testAddAllListenersWithNullListener(Void):Void {
		var l1:Object = new Object();
		var l2:Object = new Object();
		var l3:Object = new Object();
		
		var b:EventListenerSource = getEventListenerSource();
		b.addAllListeners([null, l1, null, l2, l3, null]);
		assertSame(b.getAllListeners().length, 3);
		assertSame(b.getAllListeners()[0], l1);
		assertSame(b.getAllListeners()[1], l2);
		assertSame(b.getAllListeners()[2], l3);
	}
	
	public function testAddAllListeners(Void):Void {
		var l1:Object = new Object();
		var l2:Object = new Object();
		var l3:Object = new Object();
		var l4:Object = new Object();
		var l5:Object = new Object();
		
		var b:EventListenerSource = getEventListenerSource();
		b.addAllListeners([l1, l2, l3]);
		assertSame(b.getAllListeners().length, 3);
		assertSame(b.getAllListeners()[0], l1);
		assertSame(b.getAllListeners()[1], l2);
		assertSame(b.getAllListeners()[2], l3);
		b.addAllListeners([l4, l5]);
		assertSame(b.getAllListeners().length, 5);
		assertSame(b.getAllListeners()[3], l4);
		assertSame(b.getAllListeners()[4], l5);
	}
	
	public function testRemoveWithUnknownListener(Void):Void {
		var l1:Object = new Object();
		var l2:Object = new Object();
		var l3:Object = new Object();
		
		var b:EventListenerSource = getEventListenerSource();
		b.addListener(l1);
		b.addListener(l2);
		b.addListener(l3);
		b.removeListener(new Object());
		
		assertSame(b.getAllListeners().length, 3);
		assertSame(b.getAllListeners()[0], l1);
		assertSame(b.getAllListeners()[1], l2);
		assertSame(b.getAllListeners()[2], l3);
	}
	
	public function testRemoveWithNullListener(Void):Void {
		var l1:Object = new Object();
		var l2:Object = new Object();
		var l3:Object = new Object();
		
		var b:EventListenerSource = getEventListenerSource();
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
		var l1:Object = new Object();
		var l2:Object = new Object();
		var l3:Object = new Object();
		
		var b:EventListenerSource = getEventListenerSource();
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
	
	public function testRemoveAllListeners(Void):Void {
		var b:EventListenerSource = getEventListenerSource();
		b.addListener(new Object());
		b.addListener(new Object());
		b.addListener(new Object());
		assertSame(b.getAllListeners().length, 3);
		b.removeAllListeners();
		assertSame(b.getAllListeners().length, 0);
	}
	
}