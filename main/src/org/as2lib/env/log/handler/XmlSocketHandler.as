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

import org.as2lib.core.BasicClass;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;

/**
 * XmlSocketHandler is an implementation of the LogHandler interface
 * that uses the XMLSocket to handle the received data. It was originally
 * designed to work with the POWERFLASHER's SOS XML-Socket-Server.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.handler.XmlSocketHandler extends BasicClass implements LogHandler {
	
	/** Socket to connect to the specified host. */
	private var socket:XMLSocket;
	
	/**
	 * Constructs a new instance.
	 *
	 * @param host a fully qualified DNS domain name
	 * @param port the TCP port number on the host used to establish a connection
	 */
	public function XmlSocketHandler(host:String, port:Number) {
		socket = new XMLSocket();
		socket.connect(host, port);
	}
	
	/**
	 * Uses the XMLSocket connection for the output.
	 *
	 * @see LogMessageHandler#write()
	 */
	public function write(message:LogMessage):Void {
		socket.send(message + "\n");
	}
	
}