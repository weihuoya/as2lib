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
import org.as2lib.env.event.EventInfo;
import org.as2lib.core.BasicClass;

/**
 * Detailed information to exception occurred in connector.
 * Includes an exception.
 * 
 * @author Christoph Atteneder
 * @see org.as2lib.env.except.Exception
 */
class org.as2lib.data.io.conn.ConnectorError extends BasicClass implements EventInfo{
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	 
	/** Name of the event */
	private var name:String;
	
	/** Thrown Exception */
	private var exception:Exception;
		 
	public function ConnectorError(exception:Exception) {
		
		name = "onError";
		this.exception = exception;
	}
	
	/**
	 * @return The specified name.
	 */
	public function getName(Void):String {
		return this.name;
	}
	
	/**
	 * @return The specified Exception.
	 */
	public function getException(Void):Exception {
		return exception;
	}
}