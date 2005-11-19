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

import org.as2lib.env.log.parser.LogManagerStub;
import org.as2lib.env.log.parser.PropertiesLogConfigurationParser;
import org.as2lib.test.unit.TestCase;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.TPropertiesLogConfigurationParser extends TestCase {
	
	public function testParseComplexLogConfiguration(Void):Void {
		org.as2lib.env.log.parser.LoggerStub.testCase = this;
		org.as2lib.env.log.parser.HandlerStub.testCase = this;
		org.as2lib.env.log.parser.RepositoryStub.testCase = this;
		org.as2lib.env.log.parser.SpecialLoggerStub.testCase = this;
		org.as2lib.env.log.parser.LevelStub.testCase = this;
		
		var c:String = "";
		c += "repository = +org.as2lib.env.log.parser.RepositoryStub\n";
		c += "repository.logger#0 = +org.as2lib.env.log.parser.SpecialLoggerStub\n";
		c += "repository.logger#0.level = -FATAL\n";
		c += "repository.logger#0.name = com.simonwacker.test\n";
		c += "repository.logger#0.handler#0 = +org.as2lib.env.log.parser.HandlerStub\n";
		c += "repository.logger#0.handler#0.level = -ERROR\n";
		c += "repository.logger#0.handler#1 = +org.as2lib.env.log.parser.HandlerStub\n";
		c += "repository.logger#0.handler#1.level = -UNKNOWN\n";
		c += "repository.logger#0.handler#2 = +org.as2lib.env.log.parser.HandlerStub\n";
		c += "repository.logger#0.handler#2.constructor-arg#0 = Constructor Argument 1!\n";
		c += "repository.logger#0.handler#2.constructor-arg#1 = Constructor Argument 2!\n";
		c += "repository.logger#0.handler#2.level = -WARNING\n";
		c += "repository.logger#1 = +org.as2lib.env.log.parser.LoggerStub\n";
		c += "repository.logger#1.constructor-arg = +org.as2lib.env.log.parser.LevelStub\n";
		c += "repository.logger#1.constructor-arg.constructor-arg#0 = 32\n";
		c += "repository.logger#1.constructor-arg.constructor-arg#1 = CustomLevel\n";
		c += "repository.logger#1.constructor-arg.constructor-arg#2 = true\n";
		c += "repository.logger#1.name = com.simonwacker.test.package.MyClass\n";
		c += "logger = +org.as2lib.env.log.parser.LoggerStub\n";
		c += "logger.name = useless\n";
		c += "logger.number = 3\n";
		c += "logger.boolean = false\n";
		c += "logger.string = test\n";
		c += "logger.handler = +org.as2lib.env.log.parser.HandlerStub\n";
		
		var m:LogManagerStub = new LogManagerStub(this);
		var p:PropertiesLogConfigurationParser = new PropertiesLogConfigurationParser(m);
		try {
			p.parse(c);
		} catch (e) {
			trace(e);
		}
		
		m.verify();
		org.as2lib.env.log.parser.LoggerStub.verify();
		org.as2lib.env.log.parser.HandlerStub.verify();
		org.as2lib.env.log.parser.RepositoryStub.verify();
		org.as2lib.env.log.parser.SpecialLoggerStub.verify();
		org.as2lib.env.log.parser.LevelStub.verify();
	}
	
}