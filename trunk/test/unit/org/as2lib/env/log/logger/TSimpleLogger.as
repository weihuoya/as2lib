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

import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.logger.SimpleLogger;

/**
 * @author Simon Wacker */
class org.as2lib.env.log.logger.TSimpleLogger extends TestCase {
	
	public function testNewWithName(Void):Void {
		var l:SimpleLogger = new SimpleLogger("org.as2lib.env.test.MyTest");
		assertSame(l.getName(), "org.as2lib.env.test.MyTest");
		assertSame("level should by default be ALL", l.getLevel(), SimpleLogger.ALL);
		assertSame(l.getAllHandlers().length, 0);
		assertTrue("not debug enabled", l.isDebugEnabled());
		assertTrue("not info enabled", l.isInfoEnabled());
		assertTrue("not warning enabled", l.isWarningEnabled());
		assertTrue("not error enabled", l.isErrorEnabled());
		assertTrue("not fatal enabled", l.isFatalEnabled());
	}
	
	public function testNewWithoutName(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		assertEmpty(l.getName());
		assertSame("level should by default be ALL", l.getLevel(), SimpleLogger.ALL);
		assertSame(l.getAllHandlers().length, 0);
		assertTrue("not debug enabled", l.isDebugEnabled());
		assertTrue("not info enabled", l.isInfoEnabled());
		assertTrue("not warning enabled", l.isWarningEnabled());
		assertTrue("not error enabled", l.isErrorEnabled());
		assertTrue("not fatal enabled", l.isFatalEnabled());
	}
	
	public function testSetNameViaGetName(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		l.setName("org.as2lib.env.test.MyTest");
		assertSame(l.getName(), "org.as2lib.env.test.MyTest");
	}
	
	public function testSetLevelViaGetLevel(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		assertSame("level should by default be ALL", l.getLevel(), SimpleLogger.ALL);
		l.setLevel(SimpleLogger.INFO);
		assertSame("level should be INFO", l.getLevel(), SimpleLogger.INFO);
		l.setLevel(null);
		assertSame("level of value null should result in level ALL", l.getLevel(), SimpleLogger.ALL);
	}
	
	public function testAddHandlerWithNullArgument(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		assertSame("there are default handlers", l.getAllHandlers().length, 0);
		l.addHandler(null);
		assertSame("null handlers are not ignored", l.getAllHandlers().length, 0);
	}
	
	public function testAddHandlerWithRealArgument(Void):Void {
		var hc:MockControl = new MockControl(LogHandler);
		var h:LogHandler = hc.getMock();
		hc.replay();
		
		var h1c:MockControl = new MockControl(LogHandler);
		var h1:LogHandler = h1c.getMock();
		h1c.replay();
		
		var h2c:MockControl = new MockControl(LogHandler);
		var h2:LogHandler = h2c.getMock();
		h2c.replay();
		
		var l:SimpleLogger = new SimpleLogger();
		assertSame("there are default handlers", l.getAllHandlers().length, 0);
		l.addHandler(h);
		l.addHandler(h1);
		l.addHandler(h2);
		assertSame("handler one is wrong", l.getAllHandlers()[0], h);
		assertSame("handler two is wrong", l.getAllHandlers()[1], h1);
		assertSame("handler three is wrong", l.getAllHandlers()[2], h2);
		
		hc.verify();
		h1c.verify();
		h2c.verify();
	}
	
	public function testRemoveHandlerWithNullArgument(Void):Void {
		var hc:MockControl = new MockControl(LogHandler);
		var h:LogHandler = hc.getMock();
		hc.replay();
		
		var l:SimpleLogger = new SimpleLogger();
		assertSame("there are default handlers", l.getAllHandlers().length, 0);
		l.addHandler(h);
		assertSame("handler was not added", l.getAllHandlers()[0], h);
		l.removeHandler(null);
		assertSame("remove handler with null argument results in unexpected behavior", l.getAllHandlers()[0], h);
		
		hc.verify();
	}
	
	public function testRemoveHandlerWithRealArgument(Void):Void {
		var hc:MockControl = new MockControl(LogHandler);
		var h:LogHandler = hc.getMock();
		hc.replay();
		
		var h1c:MockControl = new MockControl(LogHandler);
		var h1:LogHandler = h1c.getMock();
		h1c.replay();
		
		var h2c:MockControl = new MockControl(LogHandler);
		var h2:LogHandler = h2c.getMock();
		h2c.replay();
		
		var l:SimpleLogger = new SimpleLogger();
		assertSame("there are default handlers", l.getAllHandlers().length, 0);
		l.addHandler(h);
		l.addHandler(h1);
		l.addHandler(h2);
		assertSame("handler one is wrong", l.getAllHandlers()[0], h);
		assertSame("handler two is wrong", l.getAllHandlers()[1], h1);
		assertSame("handler three is wrong", l.getAllHandlers()[2], h2);
		l.removeHandler(h);
		assertSame("handler h was not removed correctly", l.getAllHandlers()[0], h1);
		assertSame("handler h was not removed correctly", l.getAllHandlers()[1], h2);
		l.removeHandler(h1);
		assertSame("handler h1 was not removed correctly", l.getAllHandlers()[0], h2);
		l.removeHandler(h2);
		assertSame("there should be no more handlers", l.getAllHandlers().length, 0);
		
		hc.verify();
		h1c.verify();
		h2c.verify();
	}
	
	public function testRemoveAllHandlers(Void):Void {
		var hc:MockControl = new MockControl(LogHandler);
		var h:LogHandler = hc.getMock();
		hc.replay();
		
		var h1c:MockControl = new MockControl(LogHandler);
		var h1:LogHandler = h1c.getMock();
		h1c.replay();
		
		var h2c:MockControl = new MockControl(LogHandler);
		var h2:LogHandler = h2c.getMock();
		h2c.replay();
		
		var l:SimpleLogger = new SimpleLogger();
		assertSame("there are default handlers", l.getAllHandlers().length, 0);
		l.addHandler(h);
		l.addHandler(h1);
		l.addHandler(h2);
		assertSame("handler one is wrong", l.getAllHandlers()[0], h);
		assertSame("handler two is wrong", l.getAllHandlers()[1], h1);
		assertSame("handler three is wrong", l.getAllHandlers()[2], h2);
		l.removeAllHandlers();
		assertSame(l.getAllHandlers().length, 0);
		
		hc.verify();
		h1c.verify();
		h2c.verify();
	}
	
	public function testIsEnabledWithNullLevel(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		assertFalse(l.isEnabled(null));
	}
	
	public function testIsEnabledWithAllLevelAndTestDifferentLevels(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		l.setLevel(SimpleLogger.ALL);
		assertTrue("not all enabled", l.isEnabled(SimpleLogger.ALL));
		assertTrue("not debug enabled", l.isEnabled(SimpleLogger.DEBUG));
		assertTrue("not info enabled", l.isEnabled(SimpleLogger.INFO));
		assertTrue("not warning enabled", l.isEnabled(SimpleLogger.WARNING));
		assertTrue("not error enabled", l.isEnabled(SimpleLogger.ERROR));
		assertTrue("not fatal enabled", l.isEnabled(SimpleLogger.FATAL));
		assertTrue("not none enabled", l.isEnabled(SimpleLogger.NONE));
	}
	
	public function testIsEnabledWithInfoLevelAndTestDifferentLevels(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		l.setLevel(SimpleLogger.INFO);
		assertFalse("all enabled", l.isEnabled(SimpleLogger.ALL));
		assertFalse("debug enabled", l.isEnabled(SimpleLogger.DEBUG));
		assertTrue("not info enabled", l.isEnabled(SimpleLogger.INFO));
		assertTrue("not warning enabled", l.isEnabled(SimpleLogger.WARNING));
		assertTrue("not error enabled", l.isEnabled(SimpleLogger.ERROR));
		assertTrue("not fatal enabled", l.isEnabled(SimpleLogger.FATAL));
		assertTrue("not none enabled", l.isEnabled(SimpleLogger.NONE));
	}
	
	public function testIsEnabledWithNoneLevelAndTestDifferentLevels(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		l.setLevel(SimpleLogger.NONE);
		assertFalse("all enabled", l.isEnabled(SimpleLogger.ALL));
		assertFalse("debug enabled", l.isEnabled(SimpleLogger.DEBUG));
		assertFalse("info enabled", l.isEnabled(SimpleLogger.INFO));
		assertFalse("warning enabled", l.isEnabled(SimpleLogger.WARNING));
		assertFalse("error enabled", l.isEnabled(SimpleLogger.ERROR));
		assertFalse("fatal enabled", l.isEnabled(SimpleLogger.FATAL));
		assertTrue("not none enabled", l.isEnabled(SimpleLogger.NONE));
	}
	
	public function testIsDebugEnabled(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		l.setLevel(SimpleLogger.ALL);
		assertTrue("level all does not enable debug", l.isDebugEnabled());
		l.setLevel(SimpleLogger.DEBUG);
		assertTrue("level debug does not enable debug", l.isDebugEnabled());
		l.setLevel(SimpleLogger.INFO);
		assertFalse("level info enables debug", l.isDebugEnabled());
		l.setLevel(SimpleLogger.NONE);
		assertFalse("level none enables debug", l.isDebugEnabled());
	}
	
	public function testIsInfoEnabled(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		l.setLevel(SimpleLogger.ALL);
		assertTrue("level all does not enable info", l.isInfoEnabled());
		l.setLevel(SimpleLogger.INFO);
		assertTrue("level info does not enable info", l.isInfoEnabled());
		l.setLevel(SimpleLogger.WARNING);
		assertFalse("level warning enables info", l.isInfoEnabled());
		l.setLevel(SimpleLogger.NONE);
		assertFalse("level none enables info", l.isInfoEnabled());
	}
	
	public function testIsWarningEnabled(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		l.setLevel(SimpleLogger.ALL);
		assertTrue("level all does not enable warning", l.isWarningEnabled());
		l.setLevel(SimpleLogger.WARNING);
		assertTrue("level warning does not enable warning", l.isWarningEnabled());
		l.setLevel(SimpleLogger.ERROR);
		assertFalse("level error enables warning", l.isWarningEnabled());
		l.setLevel(SimpleLogger.NONE);
		assertFalse("level none enables warning", l.isWarningEnabled());
	}
	
	public function testIsErrorEnabled(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		l.setLevel(SimpleLogger.ALL);
		assertTrue("level all does not enable error", l.isErrorEnabled());
		l.setLevel(SimpleLogger.ERROR);
		assertTrue("level error does not enable error", l.isErrorEnabled());
		l.setLevel(SimpleLogger.FATAL);
		assertFalse("level fatal enables error", l.isErrorEnabled());
		l.setLevel(SimpleLogger.NONE);
		assertFalse("level none enables error", l.isErrorEnabled());
	}
	
	public function testIsFatalEnabled(Void):Void {
		var l:SimpleLogger = new SimpleLogger();
		l.setLevel(SimpleLogger.ALL);
		assertTrue("level all does not enable fatal", l.isFatalEnabled());
		l.setLevel(SimpleLogger.FATAL);
		assertTrue("level error does not enable fatal", l.isFatalEnabled());
		l.setLevel(SimpleLogger.NONE);
		assertFalse("level none enables fatal", l.isFatalEnabled());
	}
	
	public function testLogWithAllLevel(Void):Void {
		var hc:MockControl = new MockControl(LogHandler);
		var h:LogHandler = hc.getMock();
		h.write(null);
		hc.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([LogMessage]));
		hc.replay();
		
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
		
		var l:SimpleLogger = new SimpleLogger();
		l.setLevel(SimpleLogger.ALL);
		l.addHandler(h);
		l.addHandler(h1);
		l.addHandler(h2);
		l.log("test message", SimpleLogger.ALL);
		
		hc.verify();
		h1c.verify();
		h2c.verify();
	}
	
	// TODO: Add test methods for missing log methods
	
}