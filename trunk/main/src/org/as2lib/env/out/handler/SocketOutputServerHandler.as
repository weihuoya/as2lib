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
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.core.BasicClass;

/**
 * SocketOutputServerHandler is an implementation of the OutHandler interface
 * that uses the POWERFLASHER.SOS's XML-Socket-Server to handle/print out
 * the passed information.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.out.handler.SocketOutputServerHandler extends BasicClass implements OutHandler {
	private var socket:XMLSocket;
	
	/**
	 * Constructs a new SocketOutputServerHandler.
	 *
	 * @param host a fully qualified DNS domain name
	 * @param port the TCP port number on the host used to establish a connection
	 */
	public function SocketOutputServerHandler(host:String, port:Number) {
		socket = new XMLSocket();
		socket.connect(host, port);
	}
	
	/**
	 * Uses the XMLSocket connection for the output. Uses the toString()
	 * operation of the OutWriteInfo to obtain the String representation.
	 *
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function write(info:OutWriteInfo):Void {
		socket.send(info.toString() + "\n");
	}
	
	/**
	 * Uses the XMLSocket connection for the output. Uses the toString()
	 * operation of the OutErrorInfo to obtain the String representation.
	 *
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function error(info:OutErrorInfo):Void {
		socket.send(info.toString() + "\n");
	}
}