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

import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventDispatcher;

/**
 * Special form of EventBroadcaster that delegates dispatch to a EventDispatcher.
 * You can define a dispatcher for the dispatch method. In this way it is possible
 * to define in a free way how you want to dispatch a event.
 * 
 * @see EventBroadcaster
 * @autor Martin Heidegger
 */
interface org.as2lib.env.event.DelegatingEventBroadcaster extends EventBroadcaster {
	/**
	 * Sets the EventDispatcher to delegate to.
	 * 
	 * @param eventDispatcher Dispatcher instance to delegate to.
	 */
	public function setDispatcher(eventDispatcher:EventDispatcher):Void;
}