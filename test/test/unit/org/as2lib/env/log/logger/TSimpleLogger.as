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
import org.as2lib.env.log.logger.SimpleLogger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.event.EventBroadcaster;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.log.logger.TSimpleLogger extends TestCase {
	
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
		var logger:SimpleLogger = new SimpleLogger(null);
		assertNull("returned name should be null", logger.getName());
		var logger:SimpleLogger = new SimpleLogger(undefined);
		assertUndefined("returned name should be undefined", logger.getName());
	}
	
	public function testNewWithRealArgument(Void):Void {
		var logger:SimpleLogger = new SimpleLogger("org.as2lib.core.BasicClass");
		assertSame(logger.getName(), "org.as2lib.core.BasicClass");
	}
	
	public function testSetLevelWithValidLevel(Void):Void {
		var logger:SimpleLogger = new SimpleLogger(null);
		var level:LogLevel = getLogLevel();
		logger.setLevel(level);
		var returnedLevel:LogLevel = logger.getLevel();
		assertSame("The two levels [" + level + ", " + returnedLevel + "] should be the same.", level, returnedLevel);
	}
	
	public function testSetLevelWithNullLevel(Void):Void {
		var logger:SimpleLogger = new SimpleLogger();
		logger.setLevel(null);
		var returnedLevel:LogLevel = logger.getLevel();
		assertNull("The returned level [" + returnedLevel + "] should be null.", returnedLevel);
	}
	
	public function testSetLevelWithNullLevelAndParentWithValidLevel(Void):Void {
		var logger:SimpleLogger = new SimpleLogger();
		var parent:SimpleLogger = new SimpleLogger();
		var level:LogLevel = getLogLevel();
		parent.setLevel(level);
		logger.setParent(parent);
		var returnedLevel:LogLevel = logger.getLevel();
		assertSame("The two levels [" + level + ", " + returnedLevel + "] should be the same.", level, returnedLevel);
	}
	
	public function testSetNameWithRealArgument(Void):Void {
		var logger:SimpleLogger = new SimpleLogger();
		logger.setName("any.name");
		var returnedName:String = logger.getName();
		assertSame("The returned name [" + returnedName + "] should be 'any.name'.", "any.name", returnedName);
	}
	
	public function testSetNameWithNullArgument(Void):Void {
		var logger:SimpleLogger = new SimpleLogger();
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
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.addHandler(h1);
		logger.addHandler(h3);
		logger.addHandler(h4);
		assertSame(logger.getAllHandler()[0], h1);
		assertSame(logger.getAllHandler()[1], h3);
		assertSame(logger.getAllHandler()[2], h4);
		
		h1c.verify();
		h3c.verify();
		h4c.verify();
	}
	
	public function testAddHandlerWithNullArgumentViaGetAllHandler(Void):Void {
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.addHandler(null);
		assertSame(logger.getAllHandler().length, 0);
	}
	
	public function testRemoveHandlerVaiAddHandlerAndGetAllHandler(Void):Void {
		var h1:LogHandler = getLogHandler();
		var h2:LogHandler = getLogHandler();
		var h3:LogHandler = getLogHandler();
		
		var handlers:Array;
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		
		logger.removeHandler(h2);
		handlers = logger.getAllHandler();
		assertSame(handlers[0], h1);
		assertSame(handlers[1], h3);
		
		logger.removeHandler(h2);
		handlers = logger.getAllHandler();
		assertSame(handlers[0], h1);
		assertSame(handlers[1], h3);
		
		logger.removeHandler(h1);
		handlers = logger.getAllHandler();
		assertSame(handlers[0], h3);
		
		logger.removeHandler(null);
		handlers = logger.getAllHandler();
		assertSame(handlers[0], h3);
		
		logger.removeHandler(h3);
		handlers = logger.getAllHandler();
		assertSame(handlers.length, 0);
	}
	
	public function testRemoveAllHandlerViaGetAllHandler(Void):Void {
		var h1:LogHandler = getLogHandler();
		var h2:LogHandler = getLogHandler();
		var h3:LogHandler = getLogHandler();
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		assertSame(logger.getAllHandler().length, 3);
		logger.removeAllHandler();
		assertSame(logger.getAllHandler().length, 0);
	}
	
	public function testGetAllHandler(Void):Void {
		var h1:LogHandler = getLogHandler();
		var h2:LogHandler = getLogHandler();
		var h3:LogHandler = getLogHandler();
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		assertSame(logger.getAllHandler()[0], h1);
		assertSame(logger.getAllHandler()[1], h2);
		assertSame(logger.getAllHandler()[2], h3);
	}
	
	public function testGetAllHandlerWithNoRegisteredHandler(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		assertSame(l.getAllHandler().length, 0);
	}
	
	public function testIsEnabledWithNullArgument(Void):Void {
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		lc.replay();
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.setLevel(l);
		assertFalse(logger.isEnabled(null));
		
		lc.verify();
	}
	
	public function testIsEnabledWithTrueReturningLogLevel(Void):Void {
		var a:LogLevel = getLogLevel();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.isGreaterOrEqual(a);
		lc.setReturnValue(true);
		lc.replay();
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.setLevel(l);
		assertTrue(logger.isEnabled(a));
		
		lc.verify();
	}
	
	public function testIsEnabledWithFalseReturningLogLevel(Void):Void {
		var a:LogLevel = getLogLevel();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.isGreaterOrEqual(a);
		lc.setReturnValue(false);
		lc.replay();
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.setLevel(l);
		assertFalse(logger.isEnabled(a));
		
		lc.verify();
	}
	
	public function testLogWithNullLevel(Void):Void {
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		bc.replay();
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.setBroadcaster(b);
		logger.log("message", null);
		
		bc.verify();
	}
	
	public function testLogWithDisabledLevel(Void):Void {
		var a:LogLevel = getLogLevel();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.isGreaterOrEqual(a);
		lc.setReturnValue(false);
		lc.replay();
		
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		bc.replay();
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.setBroadcaster(b);
		logger.setLevel(l);
		logger.log("message", a);
		
		bc.verify();
		lc.verify();
	}
	
	public function testLogWithEnabledLevelNoHandlersAndNullParent(Void):Void {
		var m:Object = new Object();
		var a:LogLevel = getLogLevel();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.isGreaterOrEqual(a);
		lc.setReturnValue(true);
		lc.replay();
		
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setVoidCallable();
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([LogMessage]));
		b.removeAllListener();
		bc.setVoidCallable();
		bc.replay();
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.setBroadcaster(b);
		logger.setLevel(l);
		logger.log(m, a);
		
		bc.verify();
		lc.verify();
	}
	
	public function testLogWithEnabledLevelAndHandlersAndNullParent(Void):Void {
		var h1:LogHandler = getLogHandler();
		var h2:LogHandler = getLogHandler();
		var h3:LogHandler = getLogHandler();
		
		var m:Object = new Object();
		var a:LogLevel = getLogLevel();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.isGreaterOrEqual(a);
		lc.setReturnValue(true);
		lc.replay();
		
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setVoidCallable();
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([LogMessage]));
		b.removeAllListener();
		bc.setVoidCallable();
		b.addAllListener([h1, h2, h3]);
		bc.setVoidCallable();
		bc.replay();
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.setBroadcaster(b);
		logger.setLevel(l);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		logger.log(m, a);
		
		bc.verify();
		lc.verify();
	}
	
	public function testLogWithEnabledLevelNoHandlersAndDefinedParents(Void):Void {
		var h1:LogHandler = getLogHandler();
		var h2:LogHandler = getLogHandler();
		var h3:LogHandler = getLogHandler();
		
		var lo2c:MockControl = new MockControl(SimpleLogger);
		var lo2:SimpleLogger = lo2c.getMock();
		lo2.getAllHandler();
		lo2c.setReturnValue([h1, h2, h3]);
		lo2.getParent();
		lo2c.setReturnValue(null);
		lo2c.replay();
		
		var loc:MockControl = new MockControl(SimpleLogger);
		var lo:SimpleLogger = loc.getMock();
		lo.getAllHandler();
		loc.setReturnValue([h1, h2, h3]);
		lo.getParent();
		loc.setReturnValue(lo2);
		loc.replay();
		
		var m:Object = new Object();
		var a:LogLevel = getLogLevel();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.isGreaterOrEqual(a);
		lc.setReturnValue(true);
		lc.replay();
		
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setVoidCallable();
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([LogMessage]));
		b.removeAllListener();
		bc.setVoidCallable();
		b.addAllListener([h1, h2, h3]);
		bc.setVoidCallable(2);
		bc.replay();
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.setBroadcaster(b);
		logger.setLevel(l);
		logger.setParent(lo);
		logger.log(m, a);
		
		bc.verify();
		lc.verify();
		loc.verify();
		loc.verify();
	}
	
	public function testLogWithEnabledLevelHandlersAndDefinedParents(Void):Void {
		var h1:LogHandler = getLogHandler();
		var h2:LogHandler = getLogHandler();
		var h3:LogHandler = getLogHandler();
		
		var lo2c:MockControl = new MockControl(SimpleLogger);
		var lo2:SimpleLogger = lo2c.getMock();
		lo2.getAllHandler();
		lo2c.setReturnValue([h1, h2, h3]);
		lo2.getParent();
		lo2c.setReturnValue(null);
		lo2c.replay();
		
		var loc:MockControl = new MockControl(SimpleLogger);
		var lo:SimpleLogger = loc.getMock();
		lo.getAllHandler();
		loc.setReturnValue([h1, h2, h3]);
		lo.getParent();
		loc.setReturnValue(lo2);
		loc.replay();
		
		var m:Object = new Object();
		var a:LogLevel = getLogLevel();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.isGreaterOrEqual(a);
		lc.setReturnValue(true);
		lc.replay();
		
		var bc:MockControl = new MockControl(EventBroadcaster);
		var b:EventBroadcaster = bc.getMock();
		b.dispatch(null);
		bc.setVoidCallable();
		bc.setArgumentsMatcher(new TypeArgumentsMatcher([LogMessage]));
		b.removeAllListener();
		bc.setVoidCallable();
		b.addAllListener([h1, h2, h3]);
		bc.setVoidCallable(3);
		bc.replay();
		
		var logger:SimpleLogger = new SimpleLogger(null);
		logger.setBroadcaster(b);
		logger.setLevel(l);
		logger.setParent(lo);
		logger.addHandler(h1);
		logger.addHandler(h2);
		logger.addHandler(h3);
		logger.log(m, a);
		
		bc.verify();
		lc.verify();
		loc.verify();
		loc.verify();
	}
	
}