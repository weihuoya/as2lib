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
import org.as2lib.data.io.conn.local.LocalClient;
import org.as2lib.data.io.conn.listener.SimpleListener;
import org.as2lib.data.io.conn.ConnectorRequest;
import org.as2lib.env.out.level.AllLevel;
import org.as2lib.env.out.OutConfig;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.OutLevel;
import org.as2lib.Config;
import org.as2lib.env.out.OutAccess;

/**
 * ExternalConsoleHandler is a concrete instance of the OutHandler interface. It uses e.g. the
 * as2lib console to write out the information. The Strings are generated from the 
 * OutWriteInfo with the help of the OutUtil.stringifyWriteInfo(OutWriteInfo) operation
 * or from the OurErrorInfo with the OutUtil.stringifyErrorInfo(OutErrorInfo) operation.
 * The Stringifiers used by these two methods can be set in the OutConfig class.
 *
 * @author Christoph Atteneder
 */
class org.as2lib.env.out.handler.ExternalConsoleHandler extends BasicClass implements OutHandler {
	
	private var client:LocalClient;
	
	/* Standard debug output */
	private var aOut:OutAccess;
	
	public function ExternalConsoleHandler(Void){
		aOut = Config.getOut();
		aOut.debug(getClass().getName()+" - Constructor");
		client = new LocalClient();
		client.addListener(new SimpleListener());
		client.initConnection();
	}
	
	/**
	 * Uses LocalClient to connect to external console e.g. 'as2libconsole' to make the output. 
	 * The String representation is obtained via the OutUtil.stringifyWriteInfo(OutWriteInfo) operation.
	 * You can modify the Stringifier used by this operation in the OutConfig class.
	 *
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function write(info:OutWriteInfo):Void {
		var level:String = ReflectUtil.getClassInfo(info.getLevel()).getName();
		client.handleRequest(new ConnectorRequest("localhost","Output",level,info.getMessage()));
	}
	
	/**
	 *  Uses LocalClient to connect to external console e.g. 'as2libconsole' to make the output. 
	 * The String representation is obtained via the OutUtil.stringifyErrorInfo(OutErrorInfo) operation.
	 * You can modify the Stringifier used by this operation in the OutConfig class.
	 *
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function error(info:OutErrorInfo):Void {
		trace("**:: ExternalConsoleHandler.error: "+info.getThrowable().getMessage());
		var level:String = ReflectUtil.getClassInfo(info.getLevel()).getName();
		client.handleRequest(new ConnectorRequest("localhost","Output",level,info.getThrowable().getMessage()));
	}
}