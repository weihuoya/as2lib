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
import org.as2lib.env.log.HierarchicalLogger;
import org.as2lib.env.log.logger.SimpleLogger;
import org.as2lib.env.log.repository.LoggerHierarchy;
import org.as2lib.env.log.repository.ConfigurableHierarchicalLoggerFactory;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.log.repository.TLoggerHierarchy extends TestCase {
	
	public function testGetLoggerByFactoryWithParent(Void):Void {
		var root:SimpleLogger = new SimpleLogger("root");
		
		var loggerControl:MockControl = new SimpleMockControl(SimpleLogger);
		var loggerMock:SimpleLogger = loggerControl.getMock();
		loggerMock.setParent(root);
		loggerControl.setVoidCallable();
		loggerControl.replay();
		
		var factoryControl:MockControl = new SimpleMockControl(ConfigurableHierarchicalLoggerFactory);
		var factoryMock:ConfigurableHierarchicalLoggerFactory = factoryControl.getMock();
		factoryMock.getLogger();
		factoryControl.setReturnValue(loggerMock);
		factoryControl.replay();
		
		var repository:LoggerHierarchy = new LoggerHierarchy(root);
		var returnedLogger:HierarchicalLogger = HierarchicalLogger(repository.getLoggerByFactory("any.name", factoryMock));
		assertSame("The returned logger [" + returnedLogger + "] and expected logger [" + loggerMock + "] should be the same.", loggerMock, returnedLogger);
		
		loggerControl.verify(this);
		factoryControl.verify(this);
	}
	
	public function testGetLoggerByFactoryWithChildren(Void):Void {
		var root:SimpleLogger = new SimpleLogger("root");
		
		var loggerControl:MockControl = new SimpleMockControl(SimpleLogger);
		var loggerMock:SimpleLogger = loggerControl.getMock();
		loggerMock.setParent(root);
		loggerControl.setVoidCallable();
		loggerControl.replay();
		
		var child1Control:MockControl = new SimpleMockControl(SimpleLogger);
		var child1Mock:SimpleLogger = loggerControl.getMock();
		child1Mock.setParent(loggerMock);
		child1Control.setVoidCallable();
		child1Control.replay();
		
		var child2Control:MockControl = new SimpleMockControl(SimpleLogger);
		var child2Mock:SimpleLogger = loggerControl.getMock();
		child2Mock.setParent(loggerMock);
		child2Control.setVoidCallable();
		child2Control.replay();
		
		var factoryControl:MockControl = new SimpleMockControl(ConfigurableHierarchicalLoggerFactory);
		var factoryMock:ConfigurableHierarchicalLoggerFactory = factoryControl.getMock();
		factoryMock.getLogger();
		factoryControl.setReturnValue(loggerMock);
		factoryControl.replay();
		
		var repository:LoggerHierarchy = new LoggerHierarchy(root);
		repository.putLogger("any.name.child1", child1Mock);
		repository.putLogger("any.name.subNode1.subNode2.child2", child2Mock);
		var returnedLogger:HierarchicalLogger = HierarchicalLogger(repository.getLoggerByFactory("any.name", factoryMock));
		assertSame("The returned logger [" + returnedLogger + "] and expected logger [" + loggerMock + "] should be the same.", loggerMock, returnedLogger);
		
		loggerControl.verify(this);
		child1Control.verify(this);
		child2Control.verify(this);
		factoryControl.verify(this);
	}
	
	public function testPutLoggerWithReservedName(Void):Void {
		var root:SimpleLogger = new SimpleLogger("root");
		var repository:LoggerHierarchy = new LoggerHierarchy(root);
		repository.putLogger("reserved.name", new SimpleLogger());
		assertThrows("Repository should throw an exception in case passed-in name is reserved.", IllegalArgumentException, repository, repository.putLogger, ["reserved.name", new SimpleLogger()]);
	}
	
	/** ----------------------------------------------------- **/
	/** ---------- OLD TESTS. SHOULD BE REVISITED. ---------- **/
	/** ----------------------------------------------------- **/
	
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