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
import org.as2lib.test.mock.MockControl;
import org.as2lib.test.mock.support.SimpleMockControl;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.logger.SimpleLogger;
import org.as2lib.env.log.repository.LoggerHierarchy;
import org.as2lib.env.log.repository.ConfigurableHierarchicalLoggerFactory;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.log.repository.TLoggerHierarchy extends TestCase {
	
	public function testGetLogger(Void):Void {
		var control:MockControl = new SimpleMockControl(ConfigurableHierarchicalLoggerFactory);
		var mockFactory:ConfigurableHierarchicalLoggerFactory = control.getMock();
		mockFactory.getLogger();
		var logger:Logger = new SimpleLogger();
		control.setDefaultReturnValue(logger);
		control.replay();
		
		var root:SimpleLogger = new SimpleLogger("root");
		var repository:LoggerHierarchy = new LoggerHierarchy(root);
		repository.setDefaultFactory(mockFactory);
		assertSame(logger, repository.getLogger("any.name"));
		
		control.verify(this);
	}
	
	public function testGetLoggerByName(Void):Void {
		var root:SimpleLogger = new SimpleLogger("root");
		var repository:LoggerHierarchy = new LoggerHierarchy(root);
		
		var logger1:Logger = repository.getLogger("test.unit.org.as2lib.env.logger");
		assertNotNull(logger1);
		assertNotUndefined(logger1);
		assertSame("logger1's parent must be root", logger1["getParent"](), root);
		
		var logger2:Logger = repository.getLogger("test.unit.org.as2lib.env.logger.Test");
		assertNotNull(logger2);
		assertNotUndefined(logger2);
		assertSame("logger2's parent must be logger1", logger2["getParent"](), logger1);
		
		var logger4:Logger = repository.getLogger("test.unit.org.as2lib.core.Test");
		assertNotNull(logger4);
		assertNotUndefined(logger4);
		assertSame("logger4's parent must be root", logger4["getParent"](), root);
		
		var logger3:Logger = repository.getLogger("test.unit.org.as2lib");
		assertNotNull(logger3);
		assertNotUndefined(logger3);
		assertSame("logger3's parent must be root", logger3["getParent"](), root);
		assertSame("logger1's parent must be logger3", logger1["getParent"](), logger3);
		assertSame("logger4's parent must be logger3", logger4["getParent"](), logger3);
		assertSame("logger2's parent must still be logger1", logger2["getParent"](), logger1);
	}
	
}