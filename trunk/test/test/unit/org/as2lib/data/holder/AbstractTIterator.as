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

import org.as2lib.env.except.IllegalStateException;
import org.as2lib.test.unit.TestCase;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.NoSuchElementException;

/**
 * Abtract Testcase for any iterator.
 *
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.data.holder.AbstractTIterator extends TestCase {
	
	/* Internal holder for the iterator */
	private var iterator:Iterator;
	
	/**
	 * Blocks the Framework from collecting this Test.
	 */
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	/**
	 * Iterates for all elements and checks whether they work properly.
	 */
	public function testLength(Void):Void {
		var i=0;
		while(iterator.hasNext()){
			iterator.next();
			i++;
		}
		assertEquals("The Iterator has to iterate for every element", 12, i);
	}
	
	/**
	 * Removes all elements and checks if it works properly.
	 */
	public function testRemoveAll(Void):Void {
		assertThrows("A exception should be thrown by remove if next was not called", IllegalStateException, iterator, "remove", []);
		while(iterator.hasNext()){
			iterator.next();
			iterator.remove();
		}
		assertThrows("A exception should be thrown by remove if nothing was available", IllegalStateException, iterator, "remove", []);
		assertThrows("A exception should be thrown by next if nothing was available", NoSuchElementException, iterator, "next", []);
	}
	
	/**
	 * Template method (to be extended).
	 * 
	 * @return The expected content.
	 */
	public function getElements(Void):Array {
		return [];
	}
	
	/**
	 * Validates that the content is in the correct direction.
	 */
	public function testContent(Void):Void {
		var expectedContent:Array = getElements();
		for(var i=0; iterator.hasNext(); i++) {
			assertEquals("Element "+i+" does not match its expected value "+expectedContent[i], iterator.next(), expectedContent[i]);
		}
	}
}
