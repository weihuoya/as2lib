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
import org.as2lib.env.out.OutConfig;
import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.local.LocalClient;
import org.as2lib.data.io.conn.local.SimpleListener;
import org.as2lib.data.io.ConnectorRequest;

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
	
	public function ExternalConsoleHandler(Void){
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
		client.handleRequest(new ConnectorRequest("","",OutConfig.getWriteStringifier().execute(info)));
	}
	
	/**
	 *  Uses LocalClient to connect to external console e.g. 'as2libconsole' to make the output. 
	 * The String representation is obtained via the OutUtil.stringifyErrorInfo(OutErrorInfo) operation.
	 * You can modify the Stringifier used by this operation in the OutConfig class.
	 *
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function error(info:OutErrorInfo):Void {
		client.handleRequest(new ConnectorRequest("","",OutConfig.getErrorStringifier().execute(info)));
	}
}