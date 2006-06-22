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

import org.as2lib.core.BasicClass;
import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.test.unit.ExecutionInfo;

/**
 * {@code AbstractAssertInfo} implements common methods needed by {@link ExecutionInfo}
 * implementations.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.AbstractAssertInfo extends BasicClass implements ExecutionInfo {

	/** Did this execution fail? */
	private var failed:Boolean;

	/** Has this assertion already been executed? */
	private var executed:Boolean;

	/** The message describing the assertion. */
	private var message:String;

	/**
	 * Constructs a new {@code AbstractAssertInfo} instance.
	 *
	 * @param message the message describing the assertion
	 */
	public function AbstractAssertInfo(message:String) {
		this.message = message;
		executed = false;
		failed = false;
	}

	public function isFailed(Void):Boolean {
		if (!executed) {
			failed = execute();
			executed = true;
		}
		return failed;
	}

	/**
	 * Template method to be overwritten. This will be called by the first
	 * time if isFailed() was executed.
	 *
	 * Note: The method failes by standard.
	 *
	 * @return true if the execution failed, false if it didn't.
	 */
	private function execute(Void):Boolean {
		return true;
	}

	/**
	 * Returns whether a message describing this assertion was supplied.
	 */
	private function hasMessage(Void):Boolean {
		return (message.length > 0);
	}

	/**
	 * Returns the message describing this assertion. If this assertion failed the
	 * failure message will be returned, otherwise the success message.
	 *
	 * @return the message describing this assertion
	 * @see #getFailureMessage
	 * @see #getSuccessMessage
	 */
	public function getMessage(Void):String {
		if (isFailed()) {
			return getFailureMessage();
		}
		else {
			return getSuccessMessage();
		}
	}

	/**
	 * Returns the failure message; the message to use when this assertion failed.
	 *
	 * <p>Note that this method is abstract and must be implemented by subclasses.
	 */
	private function getFailureMessage(Void):String {
		throw new AbstractOperationException("This method must be implemented in " +
				"subclasses.", this, arguments);
		return null;
	}

	/**
	 * Returns the success message; the message to use when this assertion succeeded.
	 *
	 * <p>Note that this method is abstract and must be implemented by subclasses.
	 */
	private function getSuccessMessage(Void):String {
		throw new AbstractOperationException("This method must be implemented in " +
				"subclasses.", this, arguments);
		return null;
	}

}