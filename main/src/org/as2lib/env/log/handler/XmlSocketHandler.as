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
 * XmlSocketHandler uses the XMLSocket to log the received data.
 *
 * <p>It was originally designed to work with the POWERFLASHER's SOS 
 * XML-Socket-Server but you can use it for any output device that is
 * accessible over the XML socket.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.handler.XmlSocketHandler extends BasicClass implements LogHandler {
	
	/** Socket to connect to the specified host. */
	private var socket:XMLSocket;
	
	/**
	 * Constructs a new XmlSocketHandler instance.
	 *
	 * @param host a fully qualified DNS domain name
	 * @param port the TCP port number on the host used to establish a connection
	 */
	public function XmlSocketHandler(host:String, port:Number) {
		socket = new XMLSocket();
		socket.connect(host, port);
	}
	
	/**
	 * Uses the xml socket connection to log the passed-in message.
	 *
	 * <p>Uses the LogMessage#toString method to obtain the string to
	 * log.
	 *
	 * @param message the message to log
	 */
	public function write(message:LogMessage):Void {
		socket.send(message.toString());
	}
	
}