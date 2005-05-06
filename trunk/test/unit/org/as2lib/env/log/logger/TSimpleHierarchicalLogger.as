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
import org.as2lib.env.log.logger.SimpleHierarchicalLogger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.logger.TSimpleHierarchicalLogger extends TestCase {
	
	private function getLogLevel(Void):LogLevel {
		var result = new Object();
		result.__proto__ = LogLevel["prototype"];
		return result;
	}
	
	private function getLogHandler(Void):LogHandler {
		var result = new Object();
		result.__proto__ = LogHandler["prototype"];
		return result;
	}
	
	public function testNewWithNullAndUndefinedArgument(Void):Void {
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		assertNull("returned name should be null", logger.getName());
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(undefined);
		assertUndefined("returned name should be undefined", logger.getName());
	}
	
	public function testNewWithRealArgument(Void):Void {
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger("org.as2lib.core.BasicClass");
		assertSame(logger.getName(), "org.as2lib.core.BasicClass");
	}
	
	public function testSetLevelWithValidLevel(Void):Void {
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		var level:LogLevel = getLogLevel();
		logger.setLevel(level);
		var returnedLevel:LogLevel = logger.getLevel();
		assertSame("The two levels [" + level + ", " + returnedLevel + "] should be the same.", level, returnedLevel);
	}
	
	public function testSetLevelWithNullLevel(Void):Void {
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger();
		logger.setLevel(null);
		var returnedLevel:LogLevel = logger.getLevel();
		assertNull("The returned level [" + returnedLevel + "] should be null.", returnedLevel);
	}
	
	public function testSetLevelWithNullLevelAndParentWithValidLevel(Void):Void {
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger();
		var parent:SimpleHierarchicalLogger = new SimpleHierarchicalLogger();
		var level:LogLevel = getLogLevel();
		parent.setLevel(level);
		logger.setParent(parent);
		var returnedLevel:LogLevel = logger.getLevel();
		assertSame("The two levels [" + level + ", " + returnedLevel + "] should be the same.", level, returnedLevel);
	}
	
	public function testSetNameWithRealArgument(Void):Void {
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger();
		logger.setName("any.name");
		var returnedName:String = logger.getName();
		assertSame("The returned name [" + returnedName + "] should be 'any.name'.", "any.name", returnedName);
	}
	
	public function testSetNameWithNullArgument(Void):Void {
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger();
		logger.setName(null);
		assertNull(logger.getName());
	}
	
	public function testAddHandlerViaGetAllHandler(Void):Void {
		var h1c:MockControl = new MockControl(LogHandler);
		var h1:LogHandler = h1c.getMock();
		h1c.replay();
		
		var h3c:MockControl = new MockControl(LogHandler);
		var h3:LogHandler = h3c.getMock();
		h3c.replay();
		
		var h4c:MockControl = new MockControl(LogHandler);
		var h4:LogHandler = h4c.getMock();
		h4c.replay();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.addHandler(h1);
		logger.addHandler(h3);
		logger.addHandler(h4);
		assertSame(logger.getAllHandlers()[0], h1);
		assertSame(logger.getAllHandlers()[1], h3);
		assertSame(logger.getAllHandlers()[2], h4);
		
		h1c.verify();
		h3c.verify();
		h4c.verify();
	}
	
	public function testAddHandlerWithNullArgumentViaGetAllHandler(Void):Void {
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.addHandler(null);
		assertSame(logger.getAllHandlers().length, 0);
	}
	
	public function testRemoveHandlerVaiAddHandlerAndGetAllHandler(Void):Void {
		var h1:LogHandler = getLogHandler();
		var h2:LogHandler = getLogHandler();
		var h3:LogHandler = getLogHandler();
		
		var handlers:Array;
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		
		logger.removeHandler(h2);
		handlers = logger.getAllHandlers();
		assertSame(handlers[0], h1);
		assertSame(handlers[1], h3);
		
		logger.removeHandler(h2);
		handlers = logger.getAllHandlers();
		assertSame(handlers[0], h1);
		assertSame(handlers[1], h3);
		
		logger.removeHandler(h1);
		handlers = logger.getAllHandlers();
		assertSame(handlers[0], h3);
		
		logger.removeHandler(null);
		handlers = logger.getAllHandlers();
		assertSame(handlers[0], h3);
		
		logger.removeHandler(h3);
		handlers = logger.getAllHandlers();
		assertSame(handlers.length, 0);
	}
	
	public function testRemoveAllHandlerViaGetAllHandler(Void):Void {
		var h1:LogHandler = getLogHandler();
		var h2:LogHandler = getLogHandler();
		var h3:LogHandler = getLogHandler();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		assertSame(logger.getAllHandlers().length, 3);
		logger.removeAllHandlers();
		assertSame(logger.getAllHandlers().length, 0);
	}
	
	public function testGetAllHandler(Void):Void {
		var h1:LogHandler = getLogHandler();
		var h2:LogHandler = getLogHandler();
		var h3:LogHandler = getLogHandler();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		assertSame(logger.getAllHandlers()[0], h1);
		assertSame(logger.getAllHandlers()[1], h2);
		assertSame(logger.getAllHandlers()[2], h3);
	}
	
	public function testGetAllHandlerWithNoRegisteredHandler(Void):Void {
		var l:SimpleHierarchicalLogger = new SimpleHierarchicalLogger();
		assertSame(l.getAllHandlers().length, 0);
	}
	
	public function testIsEnabledWithNullArgument(Void):Void {
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		lc.replay();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.setLevel(l);
		assertFalse(logger.isEnabled(null));
		
		lc.verify();
	}
	
	public function testIsEnabledWithGreaterLogLevel(Void):Void {
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(1);
		ac.replay();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.toNumber();
		lc.setReturnValue(4);
		lc.replay();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.setLevel(l);
		assertTrue(logger.isEnabled(a));
		
		lc.verify();
	}
	
	public function testIsEnabledWithSmallerLogLevel(Void):Void {
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(29);
		ac.replay();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.toNumber();
		lc.setReturnValue(10);
		lc.replay();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.setLevel(l);
		assertFalse(logger.isEnabled(a));
		
		lc.verify();
	}
	
	public function testLogWithNullLevel(Void):Void {
		var h1c:MockControl = new MockControl(LogHandler);
		var h1:LogHandler = h1c.getMock();
		h1c.replay();
		
		var h2c:MockControl = new MockControl(LogHandler);
		var h2:LogHandler = h2c.getMock();
		h2c.replay();
		
		var h3c:MockControl = new MockControl(LogHandler);
		var h3:LogHandler = h3c.getMock();
		h3c.replay();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		logger.log("message", null);
		
		h1c.verify();
		h2c.verify();
		h3c.verify();
	}
	
	public function testLogWithDisabledLevel(Void):Void {
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(100);
		ac.replay();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.toNumber();
		lc.setReturnValue(0);
		lc.replay();
		
		var h1c:MockControl = new MockControl(LogHandler);
		var h1:LogHandler = h1c.getMock();
		h1c.replay();
		
		var h2c:MockControl = new MockControl(LogHandler);
		var h2:LogHandler = h2c.getMock();
		h2c.replay();
		
		var h3c:MockControl = new MockControl(LogHandler);
		var h3:LogHandler = h3c.getMock();
		h3c.replay();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.setLevel(l);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		logger.log("message", a);
		
		lc.verify();
		h1c.verify();
		h2c.verify();
		h3c.verify();
	}
	
	/*public function testLogWithEnabledLevelNoHandlersAndNullParent(Void):Void {
		var m:Object = new Object();
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(20);
		ac.replay();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.toNumber();
		lc.setReturnValue(60);
		lc.replay();
		
		var h1c:MockControl = new MockControl(LogHandler);
		var h1:LogHandler = h1c.getMock();
		h1.write(null);
		h1c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h1c.replay();
		
		var h2c:MockControl = new MockControl(LogHandler);
		var h2:LogHandler = h2c.getMock();
		h2.write(null);
		h2c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h2c.replay();
		
		var h3c:MockControl = new MockControl(LogHandler);
		var h3:LogHandler = h3c.getMock();
		h3.write(null);
		h3c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h3c.replay();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.setLevel(l);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		logger.log(m, a);
		
		lc.verify();
		h1c.verify();
		h2c.verify();
		h3c.verify();
	}*/
	
	public function testLogWithEnabledLevelAndHandlersAndNullParent(Void):Void {
		var m:Object = new Object();
		
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(10);
		ac.replay();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.toNumber();
		lc.setReturnValue(30);
		lc.replay();
		
		var h1c:MockControl = new MockControl(LogHandler);
		var h1:LogHandler = h1c.getMock();
		h1.write(null);
		h1c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h1c.replay();
		
		var h2c:MockControl = new MockControl(LogHandler);
		var h2:LogHandler = h2c.getMock();
		h2.write(null);
		h2c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h2c.replay();
		
		var h3c:MockControl = new MockControl(LogHandler);
		var h3:LogHandler = h3c.getMock();
		h3.write(null);
		h3c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h3c.replay();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.setLevel(l);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		logger.log(m, a);
		
		lc.verify();
		h1c.verify();
		h2c.verify();
		h3c.verify();
	}
	
	public function testLogWithEnabledLevelNoHandlersAndDefinedParents(Void):Void {
		var h1c:MockControl = new MockControl(LogHandler);
		var h1:LogHandler = h1c.getMock();
		h1.write(null);
		h1c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h1c.replay();
		
		var h2c:MockControl = new MockControl(LogHandler);
		var h2:LogHandler = h2c.getMock();
		h2.write(null);
		h2c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h2c.replay();
		
		var h3c:MockControl = new MockControl(LogHandler);
		var h3:LogHandler = h3c.getMock();
		h3.write(null);
		h3c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h3c.replay();
		
		var loc:MockControl = new MockControl(SimpleHierarchicalLogger);
		var lo:SimpleHierarchicalLogger = loc.getMock();
		lo.getAllHandlers();
		loc.setReturnValue([h1, h2, h3]);
		loc.replay();
		
		var m:Object = new Object();
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(1);
		ac.replay();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.toNumber();
		lc.setReturnValue(2);
		lc.replay();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.setLevel(l);
		logger.setParent(lo);
		logger.log(m, a);
		
		lc.verify();
		loc.verify();
		h1c.verify();
		h2c.verify();
		h3c.verify();
	}
	
	public function testLogWithEnabledLevelHandlersAndDefinedParents(Void):Void {
		var h1c:MockControl = new MockControl(LogHandler);
		var h1:LogHandler = h1c.getMock();
		h1.write(null);
		h1c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h1c.replay();
		
		var h2c:MockControl = new MockControl(LogHandler);
		var h2:LogHandler = h2c.getMock();
		h2.write(null);
		h2c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h2c.replay();
		
		var h3c:MockControl = new MockControl(LogHandler);
		var h3:LogHandler = h3c.getMock();
		h3.write(null);
		h3c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h3c.replay();
		
		var h4c:MockControl = new MockControl(LogHandler);
		var h4:LogHandler = h4c.getMock();
		h4.write(null);
		h4c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h4c.replay();
		
		var h5c:MockControl = new MockControl(LogHandler);
		var h5:LogHandler = h5c.getMock();
		h5.write(null);
		h5c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h5c.replay();
		
		var h6c:MockControl = new MockControl(LogHandler);
		var h6:LogHandler = h6c.getMock();
		h6.write(null);
		h6c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		h6c.replay();
		
		var loc:MockControl = new MockControl(SimpleHierarchicalLogger);
		var lo:SimpleHierarchicalLogger = loc.getMock();
		lo.getAllHandlers();
		loc.setReturnValue([h4, h5, h6]);
		loc.replay();
		
		var m:Object = new Object();
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(13);
		ac.replay();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.toNumber();
		lc.setReturnValue(18);
		lc.replay();
		
		var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger(null);
		logger.setLevel(l);
		logger.setParent(lo);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		logger.log(m, a);
		
		lc.verify();
		loc.verify();
		loc.verify();
		h1c.verify();
		h2c.verify();
		h3c.verify();
		h4c.verify();
		h5c.verify();
		h6c.verify();
	}
	
}