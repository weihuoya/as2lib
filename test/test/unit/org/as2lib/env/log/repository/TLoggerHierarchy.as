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
import org.as2lib.test.mock.support.TypeArgumentsMatcher;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.HierarchicalLogger;
import org.as2lib.env.log.ConfigurableHierarchicalLogger;
import org.as2lib.env.log.logger.SimpleLogger;
import org.as2lib.env.log.repository.LoggerHierarchy;
import org.as2lib.env.log.repository.ConfigurableHierarchicalLoggerFactory;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.log.repository.TLoggerHierarchy extends TestCase {
	
	public function testNewWithNullArgument(Void):Void {
		try {
			new LoggerHierarchy(null);
			fail("null argument should cause the throwing of an IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithRealArgumentWithNullReturningGetNameMethodViaGetLogger(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue(null);
		rc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertSame(h.getLogger("root"), r);
		
		rc.verify();
	}
	
	public function testNewWithRealArgumentViaGetLogger(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("loggerName", 2);
		rc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertSame(h.getLogger("loggerName"), r);
		
		rc.verify();
	}
	
	public function testGetRootLogger(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("loggerName", 2);
		rc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertSame(h.getRootLogger(), r);
		
		rc.verify();
	}
	
	public function testPutLoggerWithNullLogger(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		try {
			h.putLogger(null);
			fail("null logger should cause an IllegalArgumentException to be thrown");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		rc.verify();
	}
	
	public function testPutLoggerWithNullName(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var lc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue(null);
		lc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		try {
			h.putLogger(l);
			fail("logger with null returning getName() method should cause the IllegalArgumentException to be thrown");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		rc.verify();
		lc.verify();
	}
	
	public function testPutLoggerWithBlankStringName(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var lc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue("");
		lc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		try {
			h.putLogger(l);
			fail("logger with blank string returning getName() method should cause the IllegalArgumentException to be thrown");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		rc.verify();
		lc.verify();
	}
	
	public function testPutLoggerWithReservedName(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setDefaultReturnValue("root");
		rc.replay();
		
		var lc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setDefaultReturnValue("MyLogger");
		l.setName("MyLogger");
		lc.setVoidCallable();
		l.setParent(r);
		lc.setVoidCallable();
		lc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.putLogger(l);
		assertSame(h.getLogger("MyLogger"), l);
		try {
			h.putLogger(l);
			fail("same name -> exception");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		rc.verify();
		lc.verify();
	}
	
	public function testPutLoggerWithAllRealValues(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setDefaultReturnValue("root");
		rc.replay();
		
		var lc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setDefaultReturnValue("MyLogger");
		l.setName("MyLogger");
		lc.setVoidCallable();
		l.setParent(r);
		lc.setVoidCallable();
		lc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.putLogger(l);
		assertSame(h.getLogger("MyLogger"), l);
		
		rc.verify();
		lc.verify();
	}
	
	public function testPutLoggerWithParent(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setDefaultReturnValue("root");
		rc.replay();
		
		var pc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var p:ConfigurableHierarchicalLogger = pc.getMock();
		p.getName();
		pc.setDefaultReturnValue("org.as2lib");
		p.setName("org.as2lib");
		pc.setVoidCallable();
		p.setParent(r);
		pc.setVoidCallable();
		pc.replay();
		
		var lc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setDefaultReturnValue("org.as2lib.core.test.t2.MyLogger");
		l.setName("org.as2lib.core.test.t2.MyLogger");
		lc.setVoidCallable();
		l.setParent(p);
		lc.setVoidCallable();
		lc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.putLogger(p);
		h.putLogger(l);
		assertSame(h.getLogger("org.as2lib"), p);
		assertSame(h.getLogger("org.as2lib.core.test.t2.MyLogger"), l);
		
		rc.verify();
		pc.verify();
		lc.verify();
	}
	
	public function testPutLoggerWithChildren(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setDefaultReturnValue("root");
		rc.replay();
		
		var pc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var p:ConfigurableHierarchicalLogger = pc.getMock();
		p.getName();
		pc.setDefaultReturnValue("org.as2lib");
		p.setName("org.as2lib");
		pc.setVoidCallable();
		p.setParent(r);
		pc.setVoidCallable(3);
		pc.replay();
		
		var lc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setDefaultReturnValue("org.as2lib.core.test.t2.MyLogger", 2);
		l.setName("org.as2lib.core.test.t2.MyLogger");
		lc.setVoidCallable();
		l.setParent(r);
		lc.setVoidCallable();
		l.setParent(p);
		lc.setVoidCallable();
		l.getParent();
		lc.setReturnValue(r, 2);
		lc.replay();
		
		var l2c:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var l2:ConfigurableHierarchicalLogger = l2c.getMock();
		l2.getName();
		l2c.setDefaultReturnValue("org.as2lib.SecondLogger", 2);
		l2.setName("org.as2lib.SecondLogger");
		l2c.setVoidCallable();
		l2.setParent(r);
		l2c.setVoidCallable();
		l2.setParent(p);
		l2c.setVoidCallable();
		l2.getParent();
		l2c.setReturnValue(r, 2);
		l2c.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.putLogger(l);
		h.putLogger(l2);
		h.putLogger(p);
		assertSame(h.getLogger("org.as2lib.core.test.t2.MyLogger"), l);
		assertSame(h.getLogger("org.as2lib.SecondLogger"), l2);
		assertSame(h.getLogger("org.as2lib"), p);
		
		rc.verify();
		pc.verify();
		lc.verify();
		l2c.verify();
	}
	
	public function testGetLoggerWithNullName(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertNull(h.getLogger(null));
		
		rc.verify();
	}
	
	public function testGetLoggerByFactoryWithNullName(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var fc:MockControl = new MockControl(ConfigurableHierarchicalLoggerFactory);
		var f:ConfigurableHierarchicalLoggerFactory = fc.getMock();
		fc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertNull(h.getLoggerByFactory(null, f));
		
		rc.verify();
		fc.verify();
	}
	
	public function testGetLoggerByFactoryWithNullFactory(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var lc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue("MyLogger");
		l.setName("MyLogger");
		lc.setVoidCallable();
		l.setParent(r);
		lc.setVoidCallable();
		lc.replay();
		
		var fc:MockControl = new MockControl(ConfigurableHierarchicalLoggerFactory);
		var f:ConfigurableHierarchicalLoggerFactory = fc.getMock();
		f.getLogger();
		fc.setReturnValue(l);
		fc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.setDefaultLoggerFactory(f);
		assertSame(h.getLoggerByFactory("MyLogger", null), l);
		
		rc.verify();
		fc.verify();
		lc.verify();
	}
	
	public function testGetLoggerByFactory(Void):Void {
		var rc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var lc:MockControl = new MockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue("MyLogger");
		l.setName("MyLogger");
		lc.setVoidCallable();
		l.setParent(r);
		lc.setVoidCallable();
		lc.replay();
		
		var fc:MockControl = new MockControl(ConfigurableHierarchicalLoggerFactory);
		var f:ConfigurableHierarchicalLoggerFactory = fc.getMock();
		f.getLogger();
		fc.setReturnValue(l);
		fc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertSame(h.getLoggerByFactory("MyLogger", f), l);
		
		rc.verify();
		fc.verify();
		lc.verify();
	}
	
	/*public function testGetLoggerByFactoryWithParent(Void):Void {
		var root:SimpleLogger = new SimpleLogger("root");
		
		var loggerControl:MockControl = new MockControl(SimpleLogger);
		var loggerMock:SimpleLogger = loggerControl.getMock();
		loggerMock.setParent(root);
		loggerControl.setVoidCallable();
		loggerControl.replay();
		
		var factoryControl:MockControl = new MockControl(ConfigurableHierarchicalLoggerFactory);
		var factoryMock:ConfigurableHierarchicalLoggerFactory = factoryControl.getMock();
		factoryMock.getLogger();
		factoryControl.setReturnValue(loggerMock);
		factoryControl.replay();
		
		var repository:LoggerHierarchy = new LoggerHierarchy(root);
		var returnedLogger:HierarchicalLogger = HierarchicalLogger(repository.getLoggerByFactory("any.name", factoryMock));
		assertSame("The returned logger [" + returnedLogger + "] and expected logger [" + loggerMock + "] should be the same.", loggerMock, returnedLogger);
		
		loggerControl.verify();
		factoryControl.verify();
	}
	
	public function testGetLoggerByFactoryWithChildren(Void):Void {
		var root:SimpleLogger = new SimpleLogger("root");
		
		var loggerControl:MockControl = new MockControl(SimpleLogger);
		var loggerMock:SimpleLogger = loggerControl.getMock();
		loggerMock.setParent(root);
		loggerControl.setVoidCallable();
		loggerControl.replay();
		
		var child1Control:MockControl = new MockControl(SimpleLogger);
		var child1Mock:SimpleLogger = loggerControl.getMock();
		child1Mock.setParent(loggerMock);
		child1Control.setVoidCallable();
		child1Control.replay();
		
		var child2Control:MockControl = new MockControl(SimpleLogger);
		var child2Mock:SimpleLogger = loggerControl.getMock();
		child2Mock.setParent(loggerMock);
		child2Control.setVoidCallable();
		child2Control.replay();
		
		var factoryControl:MockControl = new MockControl(ConfigurableHierarchicalLoggerFactory);
		var factoryMock:ConfigurableHierarchicalLoggerFactory = factoryControl.getMock();
		factoryMock.getLogger();
		factoryControl.setReturnValue(loggerMock);
		factoryControl.replay();
		
		var repository:LoggerHierarchy = new LoggerHierarchy(root);
		repository.putLogger("any.name.child1", child1Mock);
		repository.putLogger("any.name.subNode1.subNode2.child2", child2Mock);
		var returnedLogger:HierarchicalLogger = HierarchicalLogger(repository.getLoggerByFactory("any.name", factoryMock));
		assertSame("The returned logger [" + returnedLogger + "] and expected logger [" + loggerMock + "] should be the same.", loggerMock, returnedLogger);
		
		loggerControl.verify();
		child1Control.verify();
		child2Control.verify();
		factoryControl.verify();
	}
	
	public function testPutLoggerWithReservedName(Void):Void {
		var root:SimpleLogger = new SimpleLogger("root");
		var repository:LoggerHierarchy = new LoggerHierarchy(root);
		repository.putLogger("reserved.name", new SimpleLogger());
		assertThrows("Repository should throw an exception in case passed-in name is reserved.", IllegalArgumentException, repository, repository.putLogger, ["reserved.name", new SimpleLogger()]);
	}
	
	// ----------------------------------------------------- //
	// ---------- OLD TESTS. SHOULD BE REVISITED. ---------- //
	// ----------------------------------------------------- //
	
	public function testGetLogger(Void):Void {
		var control:MockControl = new MockControl(ConfigurableHierarchicalLoggerFactory);
		var mockFactory:ConfigurableHierarchicalLoggerFactory = control.getMock();
		mockFactory.getLogger();
		var logger:Logger = new SimpleLogger();
		control.setDefaultReturnValue(logger);
		control.replay();
		
		var root:SimpleLogger = new SimpleLogger("root");
		var repository:LoggerHierarchy = new LoggerHierarchy(root);
		repository.setDefaultFactory(mockFactory);
		assertSame(logger, repository.getLogger("any.name"));
		
		control.verify();
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
	}*/
	
}