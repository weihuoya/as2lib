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
import org.as2lib.env.log.parser.LoggerStub;
import org.as2lib.env.log.parser.RepositoryStub;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.LogManagerStub {
	
	private var testCase:TestCase;
	private var rep:Boolean;
	private var log:Boolean;
	
	public function LogManagerStub(testCase:TestCase) {
		this.testCase = testCase;
	}
	
	public function setRepository(repository:RepositoryStub):Void {
		rep = true;
		testCase["assertNotEmpty"]("argument 'repository' should not be empty", repository);
		testCase["assertTrue"]("repository should be instanceof RepositoryStub", repository instanceof RepositoryStub);
	}
	
	public function addLogger(logger:LoggerStub):Void {
		log = true;
		testCase["assertNotEmpty"]("argument 'logger' sould not be empty", logger);
		testCase["assertTrue"]("logger should be instanceof LoggerStub", logger instanceof LoggerStub);
	}
	
	public function setRegister():Void {
		testCase["fail"]("setRegister should not be invoked");
	}
	
	public function addRegister():Void {
		testCase["fail"]("addRegister should not be invoked");
	}
	
	public function verify(Void):Void {
		testCase["assertTrue"]("LogManagerStub.verify: logger not set", rep);
		testCase["assertTrue"]("LogManagerStub.verify: repository not set", log);
		rep = undefined;
		log = undefined;
	}
	
}