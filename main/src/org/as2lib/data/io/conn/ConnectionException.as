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

import org.as2lib.data.io.conn.ConnectorException;

/**
 * ConnectionException is the base Exception of all Exceptions,
 * which occur during or while establishing a connection with a Connector.
 * All Exceptions contained in this package extend it.
 *
 * @author Christoph Atteneder
 */
class org.as2lib.data.io.conn.ConnectionException extends ConnectorException {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function ConnectionException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}