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

import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;
import org.as2lib.core.BasicClass;

/**
 * TraceHandler uses trace to log the message. Or better to output the
 * message to Flash's output console.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.handler.TraceHandler extends BasicClass implements LogHandler {
	
	/** Holds a trace handler instance. */
	private static var traceHandler:TraceHandler;
	
	/**
	 * Returns an instance of this class.
	 *
	 * <p>This method always returns the same instance.
	 *
	 * @return a trace handler
	 */
	public static function getInstance(Void):TraceHandler {
		if(!traceHandler) traceHandler = new TraceHandler();
		return traceHandler;
	}
	
	/**	
	 * Constructs a new TraceHandler instance.
	 *
	 * <p>You can use one and the same instance for multiple loggers. So
	 * think about using the handler returned by the static {@link #getInstance}
	 * method.
	 * Using this instance prevents the instantiation of unnecessary trace
	 * handlers and and saves storage.
	 */
	public function TraceHandler(Void) {
	}
	
	/**
	 * Uses trace to write the log message out.
	 *
	 * <p>Uses the {@link LogMessage#toString} method to obtain the string that
	 * gets written out.
	 *
	 * @param message the log message to write out
	 */
	public function write(message:LogMessage):Void {
		trace(message.toString());
	}
	
}