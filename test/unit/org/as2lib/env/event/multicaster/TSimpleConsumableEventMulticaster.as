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

import org.as2lib.env.event.multicaster.AbstractTConsumableEventMulticaster;
import org.as2lib.env.event.multicaster.SimpleConsumableEventMulticaster;
import org.as2lib.env.event.multicaster.ConsumableEventMulticaster;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.event.multicaster.TSimpleConsumableEventMulticaster extends AbstractTConsumableEventMulticaster {
	
	private function getConsumableEventMulticaster(eventName:String):ConsumableEventMulticaster {
		return new SimpleConsumableEventMulticaster(eventName);
	}
	
	public function testNewWithNullArgument(Void):Void {
		try {
			getConsumableEventMulticaster(null);
			fail("expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithEmptyStringArgument(Void):Void {
		try {
			getConsumableEventMulticaster("");
			fail("expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithoutArgument(Void):Void {
		try {
			getConsumableEventMulticaster();
			fail("expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
}