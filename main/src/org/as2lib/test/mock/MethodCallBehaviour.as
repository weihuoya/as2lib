﻿/**
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
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * @author Simon Wacker
 */
interface org.as2lib.test.mock.MethodCallBehaviour extends BasicInterface {
	
	public function setExpectedCall(expectedCall:MethodCall):Void;
	
	public function addActualCall(actualArguments:MethodCall):Void;
	
	public function setExpectedRange(expectedRange:MethodCallRange):Void;
	
	public function setResponse(response:MethodResponse):Void;
	
	public function response(Void);
	
	public function verify(testCase:TestCase):Void;
	
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void;
	
}