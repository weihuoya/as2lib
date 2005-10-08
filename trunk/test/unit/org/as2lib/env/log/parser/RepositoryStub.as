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

import org.as2lib.env.log.parser.LoggerStub;
import org.as2lib.env.log.parser.SpecialLoggerStub;
import org.as2lib.test.unit.TestCase;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.RepositoryStub {
	
	public static var testCase:TestCase;
	
	private static var count:Number = 0;
	private static var loggerCount:Number = 0;
	
	public static function verify(Void):Void {
		testCase["assertSame"]("RepositoryStub.verify: unexpected instantiation count", count, 1);
		testCase["assertSame"]("RepositoryStub.verify: unexpected name count", loggerCount, 2);
	}
	
	public function RepositoryStub(Void) {
		count++;
		if (count == 1) {
			testCase["assertSame"]("RepositoryStub.new: unexpected args", arguments.length, 0);
		} else {
			testCase["fail"]("RepositoryStub.new: unexpected inv.");
		}
	}
	
	public function addLogger(logger:LoggerStub):Void {
		loggerCount++;
		if (loggerCount == 1) {
			testCase["assertTrue"]("RepositoryStub.addLogger: wrong 1. logger type", logger instanceof SpecialLoggerStub);
			return;
		}
		if (loggerCount == 2) {
			testCase["assertTrue"]("RepositoryStub.addLogger: wrong 2. logger type", logger instanceof LoggerStub);
			return;
		}
		testCase["fail"]("RepositoryStub.addLogger: unexpected inv.");
	}
	
}