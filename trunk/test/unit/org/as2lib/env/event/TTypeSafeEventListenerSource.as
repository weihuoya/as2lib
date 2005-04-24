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
import org.as2lib.env.event.TypeSafeEventListenerSource;
import org.as2lib.env.event.AbstractTEventListenerSource;
import org.as2lib.env.event.EventListener;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.event.TTypeSafeEventListenerSource extends AbstractTEventListenerSource {
	
	private function getEventListenerSource(Void):EventListenerSource {
		return new TypeSafeEventListenerSource(Object, false);
	}
	
	private function getTypeSafeEventListenerSource(Void):TypeSafeEventListenerSource {
		return new TypeSafeEventListenerSource(EventListener);
	}
	
	private function createEventListener(Void):EventListener {
		var result = new Object();
		result.__proto__ = EventListener["prototype"];
		return result;
	}
	
	public function testAddListenerWithCorrectListenerType(Void):Void {
		var l1:EventListener = createEventListener();
		var l2:EventListener = createEventListener();
		var l3:EventListener = createEventListener();
		var s:TypeSafeEventListenerSource = getTypeSafeEventListenerSource();
		s.addListener(l1);
		s.addListener(l2);
		s.addListener(l3);
		assertSame(s.getAllListeners().length, 3);
		assertSame(s.getAllListeners()[0], l1);
		assertSame(s.getAllListeners()[1], l2);
		assertSame(s.getAllListeners()[2], l3);
	}
	
	public function testAddListenerWithIllegalListenerType(Void):Void {
		var l1:EventListener = createEventListener();
		var l2:Object = new Object();
		var l3:EventListener = createEventListener();
		var s:TypeSafeEventListenerSource = getTypeSafeEventListenerSource();
		s.addListener(l1);
		try {
			s.addListener(l2);
			fail("expected org.as2lib.env.except.IllegalArgumentException exception");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		s.addListener(l3);
		assertSame(s.getAllListeners().length, 2);
		assertSame(s.getAllListeners()[0], l1);
		assertSame(s.getAllListeners()[1], l3);
	}
	
	public function testAddAllListenersWithCorrectListenerTypes(Void):Void {
		var l1:EventListener = createEventListener();
		var l2:EventListener = createEventListener();
		var l3:EventListener = createEventListener();
		var s:TypeSafeEventListenerSource = getTypeSafeEventListenerSource();
		s.addAllListeners([l1, l2, l3]);
		assertSame(s.getAllListeners().length, 3);
		assertSame(s.getAllListeners()[0], l1);
		assertSame(s.getAllListeners()[1], l2);
		assertSame(s.getAllListeners()[2], l3);
	}
	
	public function testAddAllListenersWithIllegalListenerTypes(Void):Void {
		var l0:Object = new Object();
		var l1:EventListener = createEventListener();
		var l2:Object = new Object();
		var l3:EventListener = createEventListener();
		var l4:EventListener = createEventListener();
		var l5:Object = new Object();
		var s:TypeSafeEventListenerSource = getTypeSafeEventListenerSource();
		try {
			s.addAllListeners([l0, l1, l2, l3, l4, l5]);
			fail("expected org.as2lib.env.except.IllegalArgumentException exception");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		assertSame(s.getAllListeners().length, 3);
		assertSame(s.getAllListeners()[0], l1);
		assertSame(s.getAllListeners()[1], l3);
		assertSame(s.getAllListeners()[2], l4);
	}
	
}