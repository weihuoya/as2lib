/**
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
import org.as2lib.test.mock.MethodCallRange;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.TMethodCallRange extends TestCase {
	
	public function testNewWithoutArguments(Void):Void {
		var r:MethodCallRange = new MethodCallRange();
		assertSame(r.getMinimum(), MethodCallRange.ANY_QUANTITY);
		assertSame(r.getMaximum(), MethodCallRange.ANY_QUANTITY);
	}
	
	public function testNewWithOneArgument(Void):Void {
		var r:MethodCallRange = new MethodCallRange(3);
		assertSame(r.getMinimum(), 3);
		assertSame(r.getMaximum(), 3);
	}
	
	public function testNewWithOneNullArgument(Void):Void {
		var r:MethodCallRange = new MethodCallRange(null);
		assertSame(r.getMinimum(), MethodCallRange.ANY_QUANTITY);
		assertSame(r.getMaximum(), MethodCallRange.ANY_QUANTITY);
	}
	
	public function testNewWithTwoNullArguments(Void):Void {
		var r:MethodCallRange = new MethodCallRange(null, null);
		assertSame(r.getMinimum(), MethodCallRange.ANY_QUANTITY);
		assertSame(r.getMaximum(), MethodCallRange.ANY_QUANTITY);
	}
	
	public function testNewWithNullMinimum(Void):Void {
		var r:MethodCallRange = new MethodCallRange(null, 32);
		assertSame(r.getMinimum(), 32);
		assertSame(r.getMaximum(), MethodCallRange.ANY_QUANTITY);
	}
	
	public function testNewWithNullMaximum(Void):Void {
		var r:MethodCallRange = new MethodCallRange(32, null);
		assertSame(r.getMinimum(), 32);
		assertSame(r.getMaximum(), MethodCallRange.ANY_QUANTITY);
	}
	
	public function testNewWithTwoSameArguments(Void):Void {
		var r:MethodCallRange = new MethodCallRange(3, 3);
		assertSame(r.getMinimum(), 3);
		assertSame(r.getMaximum(), 3);
	}
	
	public function testNewWithRealRange(Void):Void {
		var r:MethodCallRange = new MethodCallRange(21, 49);
		assertSame(r.getMinimum(), 21);
		assertSame(r.getMaximum(), 49);
	}
	
	public function testNewWithExchangedMinimumAndMaximum(Void):Void {
		var r:MethodCallRange = new MethodCallRange(49, 21);
		assertSame(r.getMinimum(), 21);
		assertSame(r.getMaximum(), 49);
	}
	
	public function testNewWithNegativeMinimum(Void):Void {
		var r:MethodCallRange = new MethodCallRange(-21, 49);
		assertSame(r.getMinimum(), 21);
		assertSame(r.getMaximum(), 49);
	}
	
	public function testNewWithNegativeMaximum(Void):Void {
		var r:MethodCallRange = new MethodCallRange(21, -49);
		assertSame(r.getMinimum(), 21);
		assertSame(r.getMaximum(), 49);
	}
	
	public function testContainsWithEveryQuantityAllowed(Void):Void {
		var r:MethodCallRange = new MethodCallRange();
		assertTrue(r.contains(100));
		assertTrue(r.contains(0));
		assertTrue(r.contains(-29));
	}
	
	public function testContainsWithoutRange(Void):Void {
		var r:MethodCallRange = new MethodCallRange(3, 3);
		assertTrue(r.contains(3));
		assertFalse(r.contains(4));
		assertFalse(r.contains(2));
		assertFalse(r.contains(28));
	}
	
	public function testContainsWithRange(Void):Void {
		var r:MethodCallRange = new MethodCallRange(32, 39);
		assertTrue(r.contains(32));
		assertTrue(r.contains(39));
		assertTrue(r.contains(34));
		assertFalse(r.contains(4));
		assertFalse(r.contains(2));
		assertFalse(r.contains(28));
		assertFalse(r.contains(49));
	}
	
	public function testContainsWithNullArgument(Void):Void {
		var r:MethodCallRange = new MethodCallRange(32, 39);
		assertFalse(r.contains(null));
	}
	
	public function testContainsWithNegativeArgument(Void):Void {
		var r:MethodCallRange = new MethodCallRange(32, 39);
		assertTrue(r.contains(-33));
		assertTrue(r.contains(-39));
		assertFalse(r.contains(-3));
		assertFalse(r.contains(-399));
	}
	
}