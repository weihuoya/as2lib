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

import org.as2lib.env.event.ConsumableEventBroadcaster;
import org.as2lib.env.event.ConsumableEventDispatcher;

/**
 * Special form of EventBroadcaster that delegates the dispatching process
 * to a EventDispatcher. You can implement your own EventDispatcher and
 * have thus the freedom to dispatch events at your will.
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 */
interface org.as2lib.env.event.DelegatingConsumableEventBroadcaster extends ConsumableEventBroadcaster {
	/**
	 * Sets the EventDispatcher to delegate to.
	 * 
	 * @param eventDispatcher EventDispatcher instance to delegate to
	 */
	public function setDispatcher(eventDispatcher:ConsumableEventDispatcher):Void;
}