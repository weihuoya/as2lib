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

import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.stringifier.PatternLogMessageStringifier;
import org.as2lib.test.unit.TestCase;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.stringifier.TPatternLogMessageStringifier extends TestCase {
	
	public function TPatternLogMessageStringifier(Void) {
	}
	
	public function testNewWithoutPattern(Void):Void {
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier();
		assertSame(s.getPattern(), PatternLogMessageStringifier.DEFAULT_PATTERN);
	}
	
	public function testNewWithPattern(Void):Void {
		var pattern:String = "%d %m %n a custom string";
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier(pattern);
		assertSame(s.getPattern(), pattern);
	}
	
	public function testNoConversionCharacters(Void):Void {
		var m:LogMessage = new LogMessage();
		var p:String = "no +conv#ersio-n ch.ara?ct'e'r_s () {}";
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier(p);
		assertSame(s.execute(m), p);
	}
	
	public function testPercentageCharacter(Void):Void {
		var m:LogMessage = new LogMessage();
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%%");
		assertSame(s.execute(m), "%");
	}
	
	public function testMinimum(Void):Void {
		var m:LogMessage = new LogMessage(null, AbstractLogLevel.ERROR);
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%10l");
		assertSame("%10l", s.execute(m), "     " + AbstractLogLevel.ERROR.toString());
		s = new PatternLogMessageStringifier("%-10l");
		assertSame("%-10l", s.execute(m), AbstractLogLevel.ERROR.toString() + "     ");
	}
	
	public function testMaximum(Void):Void {
		var m:LogMessage = new LogMessage(null, AbstractLogLevel.WARNING);
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%.4l");
		assertSame("%.4l", s.execute(m), "WARN");
		s = new PatternLogMessageStringifier("%-.4l");
		assertSame("%-.4l", s.execute(m), "WARN");
	}
	
	public function testMessageConversionCharacter(Void):Void {
		var m:LogMessage = new LogMessage("this is my message");
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%m");
		assertSame("%m", s.execute(m), "this is my message");
	}
	
	public function testLevelConversionCharacter(Void):Void {
		var m:LogMessage = new LogMessage(null, AbstractLogLevel.WARNING);
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%l");
		assertSame("%l", s.execute(m), AbstractLogLevel.WARNING.toString());
	}
	
	public function testNameConversionCharacter(Void):Void {
		var m:LogMessage = new LogMessage(null, null, "org.as2lib.env.log.test.MyLoggingClass");
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%n");
		assertSame("%n", s.execute(m), "org.as2lib.env.log.test.MyLoggingClass");
	}
	
	public function testNameConversionCharacterWithPrecisionSpecifier(Void):Void {
		var m:LogMessage = new LogMessage(null, null, "org.as2lib.env.log.test.MyLoggingClass");
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%n{1}");
		assertSame("%n{1}", s.execute(m), "MyLoggingClass");
		s = new PatternLogMessageStringifier("%n{4}");
		assertSame("%n{4}", s.execute(m), "env.log.test.MyLoggingClass");
		s = new PatternLogMessageStringifier("%n{10}");
		assertSame("%n{10}", s.execute(m), "org.as2lib.env.log.test.MyLoggingClass");
	}
	
	public function testDateConversionCharacter(Void):Void {
		var date:Date = new Date(2005, 11, 4, 13, 47, 38, 758);
		var m:LogMessage = new LogMessage(null, null, null, date.getTime());
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%d{yyyy.mm.dd HH:nn:ss.SSS}");
		assertSame("%d", s.execute(m), "2005.12.04 13:47:38.758");
	}
	
	public function testBigMethodNameConversionCharacter(Void):Void {
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%O");
		var m:LogMessage = new LogMessage(null, null, null, null, arguments.callee, this);
		assertSame("0", s.execute(m), "testBigMethodNameConversionCharacter");
		m = new LogMessage(null, null, "org.as2lib.env.log.stringifier.TPatternLogMessageStringifier", null, arguments.callee);
		assertSame("1", s.execute(m), "testBigMethodNameConversionCharacter");
		m.setSourceMethodName("mySourceMethodName");
		assertSame("2", s.execute(m), "mySourceMethodName");
	}
	
	public function testSmallMethodNameConversionCharacter(Void):Void {
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%o");
		var m:LogMessage = new LogMessage(null, null, null, null, arguments.callee, this);
		//assertSame("0", s.execute(m), "[unknown]");
		m = new LogMessage(null, null, "org.as2lib.env.log.stringifier.TPatternLogMessageStringifier", null, arguments.callee);
		//assertSame("1", s.execute(m), "[unknown]");
		m.setSourceMethodName("anotherSourceMethodName");
		assertSame("2", s.execute(m), "anotherSourceMethodName");
	}
	
	public function testClassNameConversionCharacter(Void):Void {
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%c");
		var m:LogMessage = new LogMessage(null, null, null, null, null, this);
		assertSame(s.execute(m), "org.as2lib.env.log.stringifier.TPatternLogMessageStringifier");
	}
	
	public function testClassNameConversionCharacterWithPrecisionSpecifier(Void):Void {
		var m:LogMessage = new LogMessage(null, null, null, null, null, this);
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%c{1}");
		assertSame("{1}", s.execute(m), "TPatternLogMessageStringifier");
		s = new PatternLogMessageStringifier("%c{3}");
		assertSame("{3}", s.execute(m), "log.stringifier.TPatternLogMessageStringifier");
		s = new PatternLogMessageStringifier("%c{20}");
		assertSame("{20}", s.execute(m), "org.as2lib.env.log.stringifier.TPatternLogMessageStringifier");
	}
	
	public function testClassNameAndMethodNameConversionCharacters(Void):Void {
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("%c.%O");
		var m:LogMessage = new LogMessage(null, null, null, null, arguments.callee, this);
		assertSame(s.execute(m), "org.as2lib.env.log.stringifier.TPatternLogMessageStringifier.testClassNameAndMethodNameConversionCharacters");
	}
	
	public function testComplexPattern(Void):Void {
		var date:Date = new Date(2005, 11, 4, 13, 47, 38, 758);
		var m:LogMessage = new LogMessage("This is a message, isn't it?", AbstractLogLevel.INFO, "com.simonwacker.test.Test", date.getTime());
		var s:PatternLogMessageStringifier = new PatternLogMessageStringifier("some text %d{HH:nn:ss.SSS} %-6.6l %n  -  %.34m");
		assertSame("1.", s.execute(m), "some text 13:47:38.758 INFO   com.simonwacker.test.Test  -  This is a message, isn't it?");
		
		date = new Date(2002, 4, 24, 11, 53, 23, 44);
		m = new LogMessage("This is another message. That's for sure.", AbstractLogLevel.WARNING, "com.simonwacker.myproject.mymodule.MyTest", date.getTime());
		assertSame("2.", s.execute(m), "some text 11:53:23.044 WARNIN com.simonwacker.myproject.mymodule.MyTest  -  This is another message. That's fo");
		
		date = new Date(2000, 5, 23, 19, 10, 32, 1);
		m = new LogMessage("Blubber.", AbstractLogLevel.FATAL, "org.as2lib.env.bean.StillToCome", date.getTime());
		assertSame("3.", s.execute(m), "some text 19:10:32.001 FATAL  org.as2lib.env.bean.StillToCome  -  Blubber.");
	}
	
}