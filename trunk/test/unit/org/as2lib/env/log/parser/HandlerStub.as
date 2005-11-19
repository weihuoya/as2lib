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
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.LogLevel;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.HandlerStub {
	
	public static var testCase:TestCase;
	private static var count:Number = 0;
	private static var levelCount:Number = 0;
	
	public static function verify(Void):Void {
		testCase["assertSame"]("HandlerStub.verify: unexpected instantiation count", count, 4);
		testCase["assertSame"]("HandlerStub.verify: unexpected level count", levelCount, 3);
		count = 0;
		levelCount = 0;
	}
	
	public function HandlerStub() {
		count++;
		if (count <= 2 || count == 4) {
			testCase["assertSame"]("HandlerStub.new: unexpected arguments", arguments.length, 0);
			return;
		}
		if (count == 3) {
			testCase["assertSame"]("HandlerStub.new: wrong 0. argument", arguments[0], "Constructor Argument 1!");
			testCase["assertSame"]("HandlerStub.new: wrong 1. argument", arguments[1], "Constructor Argument 2!");
			return;
		}
		testCase["fail"]("HandlerStub.new: unexpected invocation");
	}
	
	public function setLevel(level:LogLevel):Void {
		levelCount++;
		if (count == 1) {
			testCase["assertSame"]("HandlerStub.setLevel: 1. level should be ERROR", level, AbstractLogLevel.ERROR);
			return;
		}
		if (count == 2) {
			testCase["assertSame"]("HandlerStub.setLevel: 2. level should be INFO", level, AbstractLogLevel.INFO);
			return;
		}
		if (count == 3) {
			testCase["assertSame"]("HandlerStub.setLevel: 3. level should be WARNING", level, AbstractLogLevel.WARNING);
			return;
		}
		testCase["fail"]("HandlerStub.setLevel: unexpected invocation");
	}
	
}