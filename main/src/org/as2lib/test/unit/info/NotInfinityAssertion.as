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

import org.as2lib.test.unit.Assertion;

/**
 * {@code NotInfinityAssertion} asserts that a given value is not infinity.
 * Represents an {@code assertNotInfinity} call in a test case.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.info.NotInfinityAssertion extends Assertion {

	private var value:Number;

	/**
	 * Constructs a new {@code NotInfinityAssertion} assertion.
	 *
	 * @param message the message describing this assertion
	 * @param value the value that should not be infinity
	 */
	public function NotInfinityAssertion(message:String, value:Number) {
		super(message, "assertNotInfinity");
		this.value = value;
	}

	private function execute(Void):Boolean {
		return (value === Infinity);
	}

	private function getFailureMessage(Void):String {
		var result:String = super.getFailureMessage();
		result += "!\n  " + value + " === Infinity";
		return result;
	}

	private function getSuccessMessage(Void):String {
		return (super.getSuccessMessage() + " " + value + " !== Infinity.");
	}

}