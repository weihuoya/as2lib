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

import org.as2lib.test.unit.TestCase;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.parser.HandlerStub;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.SpecialLoggerStub {
	
	public static var testCase:TestCase;
	
	private static var count:Number = 0;
	private static var handlerCount:Number = 0;
	private static var nameCount:Number = 0;
	private static var levelCount:Number = 0;
	
	public static function verify(Void):Void {
		testCase["assertSame"]("SpecialLoggerStub.verify: unexpected instantiation count", count, 1);
		testCase["assertSame"]("SpecialLoggerStub.verify: unexpected name count", nameCount, 1);
		testCase["assertSame"]("SpecialLoggerStub.verify: unexpected handler count", handlerCount, 3);
		testCase["assertSame"]("SpecialLoggerStub.verify: unexpected level count", levelCount, 1);
		count = 0;
		handlerCount = 0;
		nameCount = 0;
		levelCount = 0;
	}
	
	public function SpecialLoggerStub(Void) {
		count++;
		if (count == 1) {
			testCase["assertSame"]("SpecialLoggerStub.new: unexpected args", arguments.length, 0);
		} else {
			testCase["fail"]("SpecialLoggerStub.new: unexpected invocation");
		}
	}
	
	public function setName(name:String):Void {
		nameCount++;
		if (count == 1) {
			testCase["assertSame"]("SpecialLoggerStub.setName: illegal name", name, "com.simonwacker.test");
		} else {
			testCase["fail"]("SpecialLoggerStub.setName invoked in illegal state");
		}
	}
	
	public function addHandler(handler:HandlerStub):Void {
		if (count == 1) {
			handlerCount++;
			if (handlerCount <= 3) {
				testCase["assertTrue"]("SpecialLoggerStub.addHandler: wrong handler class", handler instanceof HandlerStub);
			} else {
				testCase["fail"]("SpecialLoggerStub.addHandler: unexpected call; too many handlers");
			}
		} else {
			testCase["fail"]("SpecialLoggerStub.addHandler: unexpected call");
		}
	}
	
	public function setLevel(level:LogLevel):Void {
		levelCount++;
		if (count == 1) {
			testCase["assertTrue"]("SpecialLoggerStub.setLevel: level is not instance of LogLevel", level instanceof LogLevel);
		} else {
			testCase["fail"]("SpecialLoggerStub.setLevel: unexpected call");
		}
	}
	
}