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
 * TraceHandler is an implementation of the LogHandler interface. It uses
 * #trace(String) to write out the information.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.handler.TraceHandler extends BasicClass implements LogHandler {
	
	/** Holder for the traceHandler instance */
	private static var traceHandler:TraceHandler;
	
	/**	
	 * Private instanciation only, use .getInstance.
	 * Since Flash supports only one output console, only one TraceHandler is necessary.
	 *
	 * @see #getInstance
	 */
	private function TraceHandler() {}
	
	/**
	 * Returns a instance of the TraceHandler.
	 *
	 * @return Instance of a TraceHandler.
	 */
	public static function getInstance(Void):TraceHandler {
		if(!traceHandler) traceHandler = new TraceHandler();
		return traceHandler;
	}
	
	/**
	 * Uses #trace(String) to make the output.
	 *
	 * @see LogHandler#write()
	 */
	public function write(message:LogMessage):Void {
		trace(message);
	}
	
}