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

import org.as2lib.core.BasicInterface;
import org.as2lib.data.io.conn.core.event.MethodInvocationReturnInfo;
import org.as2lib.data.io.conn.core.event.MethodInvocationErrorInfo;

/**
 * @author Simon Wacker
 */
interface org.as2lib.data.io.conn.core.event.MethodInvocationCallback extends BasicInterface {
	
	/**
	 * Gets executed when the result of the method invocation arrives.
	 *
	 * @param info contains the returned result
	 */
	public function onReturn(info:MethodInvocationReturnInfo):Void;
	
	/**
	 * Gets executed when a method invocation fails.
	 *
	 * @param info contains information about the error
	 */
	public function onError(info:MethodInvocationErrorInfo):Void;
	
}