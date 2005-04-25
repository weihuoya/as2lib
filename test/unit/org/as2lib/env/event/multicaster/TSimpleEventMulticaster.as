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

import org.as2lib.env.event.multicaster.AbstractTEventMulticaster;
import org.as2lib.env.event.multicaster.SimpleEventMulticaster;
import org.as2lib.env.event.multicaster.EventMulticaster;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.event.multicaster.TSimpleEventMulticaster extends AbstractTEventMulticaster {
	
	private function getEventMulticaster(eventName:String):EventMulticaster {
		return new SimpleEventMulticaster(eventName);
	}
	
	public function testNewWithNullArgument(Void):Void {
		try {
			getEventMulticaster(null);
			fail("expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithEmptyStringArgument(Void):Void {
		try {
			getEventMulticaster("");
			fail("expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithoutArgument(Void):Void {
		try {
			getEventMulticaster();
			fail("expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
}