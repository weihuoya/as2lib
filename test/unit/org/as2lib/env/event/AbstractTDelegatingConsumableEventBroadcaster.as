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

import org.as2lib.test.mock.MockControl;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventListener;
import org.as2lib.env.event.SampleEventListener;
import org.as2lib.env.event.ConsumableEventBroadcaster;
import org.as2lib.env.event.DelegatingConsumableEventBroadcaster;
import org.as2lib.env.event.ConsumableEventInfo;
import org.as2lib.env.event.AbstractTConsumableEventBroadcaster;

class org.as2lib.env.event.AbstractTDelegatingConsumableEventBroadcaster extends AbstractTConsumableEventBroadcaster {
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	private function getConsumableEventBroadcaster(Void):ConsumableEventBroadcaster {
		return getDelegatingConsumableEventBroadcaster();
	}
	
	private function getDelegatingConsumableEventBroadcaster(Void):DelegatingConsumableEventBroadcaster {
		return null;
	}
}