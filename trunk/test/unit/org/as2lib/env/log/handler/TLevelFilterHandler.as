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
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.handler.LevelFilterHandler;

/**
 * @author Simon Wacker */
class org.as2lib.env.log.handler.TLevelFilterHandler extends TestCase {
	
	public function testNewWithNullArguments(Void):Void {
		try {
			var h:LevelFilterHandler = new LevelFilterHandler(null, null);
			fail("expected IllegalArgumentException");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithNullLevel(Void):Void {
		var wc:MockControl = new MockControl(LogHandler);
		var w:LogHandler = wc.getMock();
		wc.replay();
		
		var h:LevelFilterHandler = new LevelFilterHandler(w);
		assertSame(h.getLevel(), AbstractLogLevel.ALL);
		assertSame(h.getHandler(), w);
		
		wc.verify();
	}
	
	public function testNewWithBothArgumentsSpecified(Void):Void {
		var wc:MockControl = new MockControl(LogHandler);
		var w:LogHandler = wc.getMock();
		wc.replay();
		
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.toNumber();
		lc.setReturnValue(0);
		lc.replay();
		
		var h:LevelFilterHandler = new LevelFilterHandler(w, l);
		assertSame(h.getLevel(), l);
		assertSame(h.getHandler(), w);
		
		wc.verify();
		lc.verify();
	}
	
	public function testWriteWithHigherLevelMessage(Void):Void {
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.toNumber();
		lc.setReturnValue(10);
		lc.replay();
		
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(4);
		ac.replay();
		
		var mc:MockControl = new MockControl(LogMessage);
		var m:LogMessage = mc.getMock();
		m.getLevel();
		mc.setReturnValue(a);
		mc.replay();
		
		var wc:MockControl = new MockControl(LogHandler);
		var w:LogHandler = wc.getMock();
		w.write(m);
		wc.replay();
		
		var h:LevelFilterHandler = new LevelFilterHandler(w, l);
		assertSame(h.getLevel(), l);
		assertSame(h.getHandler(), w);
		h.write(m);
		
		wc.verify();
		lc.verify();
		mc.verify();
		ac.verify();
	}
	
	public function testWriteWithLowerLevelMessage(Void):Void {
		var lc:MockControl = new MockControl(LogLevel);
		var l:LogLevel = lc.getMock();
		l.toNumber();
		lc.setReturnValue(10);
		lc.replay();
		
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(20);
		ac.replay();
		
		var mc:MockControl = new MockControl(LogMessage);
		var m:LogMessage = mc.getMock();
		m.getLevel();
		mc.setReturnValue(a);
		mc.replay();
		
		var wc:MockControl = new MockControl(LogHandler);
		var w:LogHandler = wc.getMock();
		wc.replay();
		
		var h:LevelFilterHandler = new LevelFilterHandler(w, l);
		assertSame(h.getLevel(), l);
		assertSame(h.getHandler(), w);
		h.write(m);
		
		wc.verify();
		lc.verify();
		mc.verify();
		ac.verify();
	}
	
}