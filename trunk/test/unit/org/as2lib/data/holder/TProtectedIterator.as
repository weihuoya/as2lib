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
import org.as2lib.env.except.UnsupportedOperationException;
import org.as2lib.data.holder.ProtectedIterator;
import org.as2lib.data.holder.TestIterator;

/**
 * Proofes the ability of the protected iterator.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.data.holder.TProtectedIterator extends TestCase {
	
	// Holder for the protected iterator
	private var iterator:ProtectedIterator;
	
	// TestIterator to validate the delegation
	private var content:TestIterator;
	
	// creates a testiterator and a protectediterator
	public function setUp(Void):Void {
		content = new TestIterator();
		iterator = new ProtectedIterator(content);
	}
	
	/**
	 * Tests if the ProtectedIterator really protects from removing.
	 */
	public function testProtection(Void):Void {
		assertThrows("Exception should be thrown if you try to access remove", UnsupportedOperationException, iterator, "remove", []);
		assertNotEquals("remove must not be called if you access removed", content.getLastExecuted(), "remove");
	}
	
	/**
	 * Test if the ProtectedIterator delegates to its contained iterator the contained methods.
	 */
	public function testDelegation(Void):Void {
		assertEquals("Next should return as static result 'b'", iterator.next(), "b");
		assertEquals("Next should be called to the containing iterator", content.getLastExecuted(), "next");
		assertTrue("hasNext should return as static result true", iterator.hasNext());
		assertEquals("hasNext should be called to the containing iterator", content.getLastExecuted(), "hasNext");
	}
}