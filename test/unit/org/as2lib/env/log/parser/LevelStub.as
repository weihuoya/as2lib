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

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.LevelStub {
	
	public static var testCase:TestCase;
	private static var count:Number = 0;
	
	public static function verify(Void):Void {
		testCase["assertSame"]("LevelStub.verify: unexpected instantiation count", count, 1);
	}
	
	public function LevelStub(number:Number, string:String, boolean:Boolean) {
		count++;
		testCase["assertSame"](number, 32);
		testCase["assertSame"](string, "CustomLevel");
		testCase["assertSame"](boolean, true);
	}
	
}