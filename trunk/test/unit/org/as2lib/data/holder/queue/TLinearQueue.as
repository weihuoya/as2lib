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

import org.as2lib.data.holder.AbstractTQueue;
import org.as2lib.data.holder.Queue;
import org.as2lib.data.holder.queue.LinearQueue;

/**
 * Test for the standard implementation of Queue
 * 
 * @author Martin Heidegger
 */
class org.as2lib.data.holder.queue.TLinearQueue extends AbstractTQueue {
	
	/**
	 * Extended template method.
	 * 
	 * @returns a new instance of LinearQueue
	 */
	private function getQueue(Void):Queue {
		return new LinearQueue();
	}
}