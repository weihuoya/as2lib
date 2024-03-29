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

import asunit.framework.TestCase;

/**
 * @author Simon Wacker
 */
class com.simonwacker.MyTest extends TestCase {

	public function testEquals(Void):Void {
		assertEquals("claire", "claire");
	}

	public function testSame(Void):Void {
		assertSame(1, new Number(1));
	}

	public function testFail(Void):Void {
		fail("Fail message.");
	}

	public function testTrue(Void):Void {
		assertTrue(false);
	}

	public function testException(Void):Void {
		throw new Error("Error message.");
	}

}