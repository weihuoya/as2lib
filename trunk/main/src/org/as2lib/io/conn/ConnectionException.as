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

import org.as2lib.env.except.Exception;

/**
 * ConnectionException is the super exception of all exceptions that have
 * to do with connections.
 *
 * <p>Every exception contained in this or any subpackage extend this
 * exception.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.ConnectionException extends Exception {
	
	/**
	 * @see org.as2lib.env.except.Exception#new()
	 */
	public function ConnectionException(message:String, thrower, args:Array) {
		super(message, thrower, args);
	}
	
}