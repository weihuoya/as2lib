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

import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.OutHandler;
import org.as2lib.env.out.OutInfo;
import org.as2lib.core.BasicClass;

/**
 * XmlSocketHandler is an implementation of the OutHandler interface that
 * uses the XMLSocket to handle the received data. It was originally designed
 * to work with the POWERFLASHER's SOS XML-Socket-Server.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.out.handler.XmlSocketHandler extends BasicClass implements OutHandler {
	
	private var socket:XMLSocket;
	
	/**
	 * Constructs a new XmlSocketHandler.
	 *
	 * @param host a fully qualified DNS domain name
	 * @param port the TCP port number on the host used to establish a connection
	 */
	public function XmlSocketHandler(host:String, port:Number) {
		socket = new XMLSocket();
		socket.connect(host, port);
	}
	
	/**
	 * Uses the XMLSocket connection for the output. Uses the toString()
	 * operation of the OutInfo to obtain the String representation.
	 *
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function write(info:OutInfo):Void {
		socket.send(info + "\n");
	}
	
}