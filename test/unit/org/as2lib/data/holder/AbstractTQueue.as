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
import org.as2lib.data.holder.Queue;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.data.holder.Iterator;

/**
 * Abstract Test for Queue, simple extend this test and overwrite getQueue to test principially your implementation.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.data.holder.AbstractTQueue extends TestCase {
	
	/** Internal holder of a queue */
	private var queue:Queue;
	
	/**
	 * Static method to block this test from getting collected with the TestSuiteFactory.
	 */
	public static function blockCollecting(Void):Boolean {
		return true
	}
	
	/**
	 * Template method to get a new (clean) instance of a Queue implementation.
	 * 
	 * @return new instance of a queue implementation.
	 */
	private function getQueue(Void):Queue {
		return null;
	}
	
	/**
	 * Method to get a new queue for every method.
	 */
	public function setUp(Void):Void {
		queue = getQueue();
	}
	
	/**
	 * Validates if enqueue works with different kind of types and it won't modify the result by multiple useage.
	 */
	public function testEnqueue(Void):Void {
		// Normal string test
		queue.enqueue("a");
		assertEquals("The first content should be a", queue.peek(), "a");
		
		// Double string test
		queue.enqueue("b");
		assertEquals("The first content should still be a after inserting b", queue.peek(), "a");
		
		// Number test
		queue = getQueue();
		queue.enqueue(1);
		assertEquals("The first content should be 1", queue.peek(), 1);
		
		// Null test
		queue = getQueue();
		queue.enqueue(null);
		assertNull("The first content should be null", queue.peek());
		
		// Double use test (if null is not used as stack, anyway
		queue.enqueue(undefined);
		assertNull("The first content should still be null", queue.peek());
		
		// Undefined test
		queue = getQueue();
		queue.enqueue(undefined);
		assertUndefined("The first content should be undefined", queue.peek());
		
		// Double use test (if null is not used as stack, anyway
		queue.enqueue(undefined);
		assertUndefined("The first content should still be undefined", queue.peek());
	}
	
	/**
	 * Tests if dequeue works in multiple useage.
	 */
	public function testDequeue(Void):Void {
		// Empty use test
		assertThrows("dequeue should throw a exception if the queue was empty", EmptyDataHolderException, queue, "dequeue", []);
		
		// Normal use Test
		queue.enqueue("a");
		assertEquals("The first content should be a", queue.peek(), "a");
		queue.enqueue("b");
		assertEquals("The first entry ('a') should be removed", queue.dequeue(), "a");
		
		// Double use test
		assertEquals("The first content should be b", queue.peek(), "b");
		assertEquals("The first entry ('b') should be removed", queue.dequeue(), "b");
		assertThrows("dequeue should throw a exception if the queue was completly cleared", EmptyDataHolderException, queue, "dequeue", []);
	}
	
	/**
	 * Tests if peek works even in special cases.
	 */
	public function testPeek(Void):Void {
		// Empty use test
		assertThrows("peek should throw a exception if the queue was empty", EmptyDataHolderException, queue, "peek", []);
		
		// Normal use test
		queue.enqueue("a");
		assertEquals("The first entry ('a') should be returned by peek", queue.peek('a'), "a");
		
		// Double use test
		assertEquals("The first entry ('a') should still be returned by peek", queue.peek('a'), "a");
		
		// Tests the state if some value was enqueued
		queue.enqueue("b");
		assertEquals("The first entry ('a') should be returned by peek even if b was enqueued", queue.peek('a'), "a");
		assertEquals("The first entry ('a') should still be returned by peek even if b was enqueued", queue.peek('a'), "a");
		
		// Tests if it still works if the first entry was removed
		queue.dequeue();
		assertEquals("The first entry ('b') should be returned by peek", queue.peek('b'), "b");
		assertEquals("The first entry ('b') should still be returned by peek", queue.peek('b'), "b");
		
		// Clearing the queue and test if exception will raise.
		queue.dequeue();
		assertThrows("peek should throw a exception if the queue was cleared again", EmptyDataHolderException, queue, "peek", []);
	}
	
	/**
	 * Validates that isEmpty only returns true if the queue was really empty.
	 */
	public function testIsEmpty(Void):Void {
		// Test with a new list
		assertTrue("A fresh queue should be empty", queue.isEmpty());
		
		// Test with a filled list
		queue.enqueue(1);
		assertFalse("After inserting one element it should not be empty", queue.isEmpty());
		queue.enqueue(2);
		assertFalse("After inserting two elements it should not be empty", queue.isEmpty());
		
		// Check after all entries were dequeued.
		queue.dequeue();
		queue.dequeue();
		assertTrue("A queue should be empty after all entries were dequeued", queue.isEmpty());
	}
	
	/**
	 * Tests if size() returns the right number of elements.
	 */
	public function testSize(Void):Void {
		// empty queue
		assertSame("No elements added -> size = 0.", queue.size(), 0);
		
		// filled queue
		queue.enqueue(1);
		assertSame("One element added", queue.size(), 1);
		queue.enqueue("second");
		assertSame("Two elements added", queue.size(), 2);
		queue.enqueue(new Object());
		assertSame("Three elements added", queue.size(), 3);
		queue.dequeue();
		assertSame("Two elements left", queue.size(), 2);
		queue.dequeue();
		queue.dequeue();
		assertSame("Null elements left", queue.size(), 0);
	}
	
	/**
	 * Validates that iterator() returns always a proper iterator.
	 */
	public function testIterator(Void):Void {
		var iterator:Iterator = queue.iterator();
		var obj1:Object = {};
		var obj2:Object = {};
		
		assertFalse("A iterator of a empty queue may not allow hasNext", iterator.hasNext());
		
		// Queue filling
		queue.enqueue(obj1);
		queue.enqueue(obj2);
		
		// Tests if the former used iterator is ma
		assertFalse("The iterator must not be affected of a change of the queue", iterator.hasNext());
		
		// Norma literator test.
		iterator = queue.iterator();
		assertTrue("A queue with a iterator has to have something 'next'", iterator.hasNext());
		assertEquals("The first object in the iterator should match obj1", obj1, iterator.next());
		assertEquals("The second object in the iterator should match obj2", obj2, iterator.next());
		assertFalse("There should be only two entries in the iterator", iterator.hasNext());
	}
	
	public function testToArray(Void):Void {
		var obj:Object = new Object();
		var obj1:Object = new Object();
		var obj2:Object = new Object();
		
		assertSame("Queue is empty and so should be the array representation.", queue.toArray().length, 0);
		queue.enqueue(obj1);
		assertSame("Array representation should contain exactly one element.", queue.toArray().length, 1);
		assertSame("The first and only element should be obj1.", queue.toArray()[0], obj1);
		queue.enqueue(obj2);
		assertSame("Array representation should contain exactly two elements.", queue.toArray().length, 2);
		assertSame("The first element should be obj1.", queue.toArray()[0], obj1);
		assertSame("The second element should be obj2.", queue.toArray()[1], obj2);
		queue.enqueue(obj);
		assertSame("Array representation should contain exactly three elements.", queue.toArray().length, 3);
		assertSame("The first element should be obj1.", queue.toArray()[0], obj1);
		assertSame("The second element should be obj2.", queue.toArray()[1], obj2);
		assertSame("The third element should be obj.", queue.toArray()[2], obj);
		queue.dequeue();
		queue.dequeue();
		queue.dequeue();
		assertSame("Queue is again empty and so should be the array representation.", queue.toArray().length, 0);
	}
	
}
