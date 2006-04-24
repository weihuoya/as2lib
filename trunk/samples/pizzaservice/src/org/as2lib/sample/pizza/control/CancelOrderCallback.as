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

import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.io.conn.core.event.ContextMethodInvocationCallback;
import org.as2lib.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.io.conn.core.event.MethodInvocationReturnInfo;
import org.as2lib.sample.pizza.event.OrderPlacedEvent;
import org.as2lib.sample.pizza.event.OrdersLoadedEvent;
import org.as2lib.util.StringUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.pizza.control.CancelOrderCallback extends ContextMethodInvocationCallback {
	
	private static var logger:Logger = LogManager.getLogger("org.as2lib.sample.pizza.control.CancelOrderCallback");
	
	public function CancelOrderCallback(Void) {
	}
	
	public function onReturn(returnInfo:MethodInvocationReturnInfo):Void {
		if (returnInfo.getReturnValue() == false) {
			var errorInfo:MethodInvocationErrorInfo = new MethodInvocationErrorInfo(
					returnInfo.getServiceProxy(), returnInfo.getMethodName(), returnInfo.getMethodArguments());
			onError(errorInfo);
		}
		else {
			super.onReturn(returnInfo);
		}
	}
	
}