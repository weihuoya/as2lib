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

import org.as2lib.aop.AopException;

/**
 * UnsupportedAdviceException gets thrown when you try to pass an Advice to an
 * operation that is not supported by it.
 *
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.UnsupportedAdviceException extends AopException {
	/**
	 * @see org.as2lib.env.except.AopException#Constructor()
	 */
	public function UnsupportedAdviceException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}