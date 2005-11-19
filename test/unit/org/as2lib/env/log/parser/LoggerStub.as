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
import org.as2lib.env.log.parser.LevelStub;
import org.as2lib.env.log.parser.HandlerStub;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.LoggerStub {
	
	public static var testCase:TestCase;
	
	private static var count:Number = 0;
	private static var nameCount:Number = 0;
	private static var numberCount:Number = 0;
	private static var stringCount:Number = 0;
	private static var booleanCount:Number = 0;
	private static var handlerCount:Number = 0;
	
	public static function verify(Void):Void {
		testCase["assertSame"]("LoggerStub.verify: unexpected instantiation count", count, 2);
		testCase["assertSame"]("LoggerStub.verify: unexpected name count", nameCount, 2);
		testCase["assertSame"]("LoggerStub.verify: unexpected number count", numberCount, 1);
		testCase["assertSame"]("LoggerStub.verify: unexpected boolean count", booleanCount, 1);
		testCase["assertSame"]("LoggerStub.verify: unexpected string count", stringCount, 1);
		testCase["assertSame"]("LoggerStub.verify: unexpected handler count", handlerCount, 1);
		count = 0;
		nameCount = 0;
		numberCount = 0;
		stringCount = 0;
		booleanCount = 0;
		handlerCount = 0;
	}
	
	public function LoggerStub() {
		count++;
		if (count == 1) {
			testCase["assertTrue"]("LoggerStub expects one constructor arg", arguments[0] instanceof LevelStub);
			return;
		}
		if (count == 2) {
			testCase["assertSame"]("LoggerStub expects no constructor args", arguments.length, 0);
			return;
		}
		testCase["fail"]("LoggerStub.new was invoked too often");
	}
	
	public function setName(name:String):Void {
		nameCount++;
		if (count == 1) {
			testCase["assertSame"]("LoggerStub: illegal name for instance 1", name, "com.simonwacker.test.package.MyClass");
			return;
		}
		if (count == 2) {
			testCase["assertSame"]("LoggerStub: illegal name for instance 2", name, "useless");
			return;
		}
		testCase["fail"]("LoggerStub.setName invoked in illegal state");
	}
	
	public function setNumber(number:Number):Void {
		numberCount++;
		if (count == 2) {
			testCase["assertSame"]("LoggerStub.setNumber", number, 3);
		} else {
			testCase["fail"]("LoggerStub.setNumber: unexpected call");
		}
	}
	
	public function setBoolean(boolean:Boolean):Void {
		booleanCount++;
		if (count == 2) {
			testCase["assertSame"]("LoggerStub.setBoolean", boolean, false);
		} else {
			testCase["fail"]("LoggerStub.setBoolean: unexpected call");
		}
	}
	
	public function setString(string:String):Void {
		stringCount++;
		if (count == 2) {
			testCase["assertSame"]("LoggerStub.setString", string, "test");
		} else {
			testCase["fail"]("LoggerStub.setString: unexpected call");
		}
	}
	
	public function setHandler(handler:HandlerStub):Void {
		handlerCount++;
		if (count == 2) {
			testCase["assertTrue"]("LoggerStub.setHandler: hanlder is not instance of HandlerStub", handler instanceof HandlerStub);
		} else {
			testCase["fail"]("LoggerStub.setHandler: unexpected call");
		}
	}
	
}