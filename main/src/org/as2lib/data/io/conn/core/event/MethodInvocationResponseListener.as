﻿/*
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

import org.as2lib.env.event.EventListener;
import org.as2lib.data.io.conn.core.event.MethodInvocationResponseInfo;

/**
 * @author Simon Wacker
 */
interface org.as2lib.data.io.conn.core.event.MethodInvocationResponseListener extends EventListener {
	
	/**
	 * Gets executed when the method invocation succeeded.
	 *
	 * @param info contains the result of the method invocation
	 */
	public function onResponse(info:MethodInvocationResponseInfo):Void;
	
}