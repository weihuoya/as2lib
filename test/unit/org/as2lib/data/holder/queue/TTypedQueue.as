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
import org.as2lib.data.holder.queue.TypedQueue;

/**
 * Test for the typed implementation of Queue
 * 
 * @author Martin Heidegger
 */
class org.as2lib.data.holder.queue.TTypedQueue extends AbstractTQueue {
	
	/**
	 * Extended template method.
	 * 
	 * @returns a new instance of TypedQueue
	 */
	private function getQueue(Void):Queue {
		return new TypedQueue(Object, new LinearQueue());
	}
	
	/**
	 * Extends .testEnqueue and tests if enqueueing of wrong types work proper.
	 */
	public function testEnqueue(Void):Void {
		super.testEnqueue();
		var queue2:Queue = new TypedQueue(String, new LinearQueue());
		assertThrows("queue2 should throw a exception if you push a number", queue2, "enqueue", [1]);
		assertTrue("queue2 should be empty, nothing has been enqueued!", queue2.isEmpty());
	}
}