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
import org.as2lib.test.mock.support.SimpleMockControl;
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
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue(null);
		rc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertSame(h.getLogger("root"), r);
		
		rc.verify(this);
	}
	
	public function testNewWithRealArgumentViaGetLogger(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("loggerName", 2);
		rc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertSame(h.getLogger("loggerName"), r);
		
		rc.verify(this);
	}
	
	public function testGetRootLogger(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("loggerName", 2);
		rc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertSame(h.getRootLogger(), r);
		
		rc.verify(this);
	}
	
	public function testPutLoggerWithBothNamesNull(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var lc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue(null);
		lc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		try {
			h.putLogger(null, l);
			fail("null name should cause an IllegalArgumentException to get thrown");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		rc.verify(this);
		lc.verify(this);
	}
	
	public function testPutLoggerWithNullName(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var lc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue("MyLogger", 2);
		l.setName("MyLogger");
		lc.setVoidCallable();
		l.setParent(r);
		lc.setVoidCallable();
		lc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.putLogger(null, l);
		assertSame(h.getLogger("MyLogger"), l);
		
		rc.verify(this);
		lc.verify(this);
	}
	
	public function testPutLoggerWithReservedName(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var lc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue("MyLogger");
		l.setName("MyLogger");
		lc.setVoidCallable();
		l.setParent(r);
		lc.setVoidCallable();
		lc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.putLogger("MyLogger", l);
		assertSame(h.getLogger("MyLogger"), l);
		try {
			h.putLogger("MyLogger", l);
			fail("same name -> exception");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		rc.verify(this);
		lc.verify(this);
	}
	
	public function testPutLoggerWithNullLogger(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.putLogger("MyLogger", null);
		assertNotNull(h.getLogger("MyLogger"));
		
		rc.verify(this);
	}
	
	public function testPutLoggerWithAllRealValues(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var lc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue("MyLogger");
		l.setName("MyLogger");
		lc.setVoidCallable();
		l.setParent(r);
		lc.setVoidCallable();
		lc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.putLogger("MyLogger", l);
		assertSame(h.getLogger("MyLogger"), l);
		
		rc.verify(this);
		lc.verify(this);
	}
	
	public function testPutLoggerWithParent(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var pc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var p:ConfigurableHierarchicalLogger = pc.getMock();
		p.getName();
		pc.setReturnValue("org.as2lib");
		p.setName("org.as2lib");
		pc.setVoidCallable();
		p.setParent(r);
		pc.setVoidCallable();
		pc.replay();
		
		var lc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue("org.as2lib.core.test.t2.MyLogger");
		l.setName("org.as2lib.core.test.t2.MyLogger");
		lc.setVoidCallable();
		l.setParent(p);
		lc.setVoidCallable();
		lc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.putLogger("org.as2lib", p);
		h.putLogger("org.as2lib.core.test.t2.MyLogger", l);
		assertSame(h.getLogger("org.as2lib"), p);
		assertSame(h.getLogger("org.as2lib.core.test.t2.MyLogger"), l);
		
		rc.verify(this);
		pc.verify(this);
		lc.verify(this);
	}
	
	public function testPutLoggerWithChildren(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 4);
		rc.replay();
		
		var pc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var p:ConfigurableHierarchicalLogger = pc.getMock();
		p.getName();
		pc.setReturnValue("org.as2lib", 3);
		p.setName("org.as2lib");
		pc.setVoidCallable();
		p.setParent(r);
		pc.setVoidCallable(3);
		pc.replay();
		
		var lc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue("org.as2lib.core.test.t2.MyLogger");
		l.setName("org.as2lib.core.test.t2.MyLogger");
		lc.setVoidCallable();
		
		// Multiple calls with different arguments are not supported. ////////////////////////////////////////////// TODO ////////////////////////////////
		/*l.setParent(r);
		lc.setVoidCallable();
		l.setParent(p);
		lc.setVoidCallable();*/
		
		l.setParent(null);
		lc.setVoidCallable(2);
		lc.setArgumentsMatcher(new TypeArgumentsMatcher([ConfigurableHierarchicalLogger]));
		l.getParent();
		lc.setReturnValue(r, 2);
		lc.replay();
		
		var l2c:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var l2:ConfigurableHierarchicalLogger = l2c.getMock();
		l2.getName();
		l2c.setReturnValue("org.as2lib.SecondLogger");
		l2.setName("org.as2lib.SecondLogger");
		l2c.setVoidCallable();
		
		// Multiple calls with different arguments are not supported. ////////////////////////////////////////////// TODO ////////////////////////////////
		/*l2.setParent(r);
		l2c.setVoidCallable();
		l2.setParent(p);
		l2c.setVoidCallable();*/
		
		l2.setParent(null);
		l2c.setVoidCallable(2);
		l2c.setArgumentsMatcher(new TypeArgumentsMatcher([ConfigurableHierarchicalLogger]));
		l2.getParent();
		l2c.setReturnValue(r, 2);
		l2c.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.putLogger("org.as2lib.core.test.t2.MyLogger", l);
		h.putLogger("org.as2lib.SecondLogger", l2);
		h.putLogger("org.as2lib", p);
		assertSame(h.getLogger("org.as2lib"), p);
		assertSame(h.getLogger("org.as2lib.core.test.t2.MyLogger"), l);
		assertSame(h.getLogger("org.as2lib.SecondLogger"), l2);
		
		rc.verify(this);
		pc.verify(this);
		lc.verify(this);
		l2c.verify(this);
	}
	
	public function testGetLoggerWithNullName(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertNull(h.getLogger(null));
		
		rc.verify(this);
	}
	
	public function testGetLoggerByFactoryWithNullName(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var fc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLoggerFactory);
		var f:ConfigurableHierarchicalLoggerFactory = fc.getMock();
		fc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertNull(h.getLoggerByFactory(null, f));
		
		rc.verify(this);
		fc.verify(this);
	}
	
	public function testGetLoggerByFactoryWithNullFactory(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var lc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue("MyLogger");
		l.setName("MyLogger");
		lc.setVoidCallable();
		l.setParent(r);
		lc.setVoidCallable();
		lc.replay();
		
		var fc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLoggerFactory);
		var f:ConfigurableHierarchicalLoggerFactory = fc.getMock();
		f.getLogger();
		fc.setReturnValue(l);
		fc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		h.setDefaultLoggerFactory(f);
		assertSame(h.getLoggerByFactory("MyLogger", null), l);
		
		rc.verify(this);
		fc.verify(this);
		lc.verify(this);
	}
	
	public function testGetLoggerByFactory(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var r:ConfigurableHierarchicalLogger = rc.getMock();
		r.getName();
		rc.setReturnValue("root", 2);
		rc.replay();
		
		var lc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLogger);
		var l:ConfigurableHierarchicalLogger = lc.getMock();
		l.getName();
		lc.setReturnValue("MyLogger");
		l.setName("MyLogger");
		lc.setVoidCallable();
		l.setParent(r);
		lc.setVoidCallable();
		lc.replay();
		
		var fc:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLoggerFactory);
		var f:ConfigurableHierarchicalLoggerFactory = fc.getMock();
		f.getLogger();
		fc.setReturnValue(l);
		fc.replay();
		
		var h:LoggerHierarchy = new LoggerHierarchy(r);
		assertSame(h.getLoggerByFactory("MyLogger", f), l);
		
		rc.verify(this);
		fc.verify(this);
		lc.verify(this);
	}
	
	/*public function testGetLoggerByFactoryWithParent(Void):Void {
		var root:SimpleLogger = new SimpleLogger("root");
		
		var loggerControl:SimpleMockControl = new SimpleMockControl(SimpleLogger);
		var loggerMock:SimpleLogger = loggerControl.getMock();
		loggerMock.setParent(root);
		loggerControl.setVoidCallable();
		loggerControl.replay();
		
		var factoryControl:SimpleMockControl = new SimpleMockControl(ConfigurableHierarchicalLoggerFactory);
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
	
	// ----------------------------------------------------- //
	// ---------- OLD TESTS. SHOULD BE REVISITED. ---------- //
	// ----------------------------------------------------- //
	
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
	}*/
	
}