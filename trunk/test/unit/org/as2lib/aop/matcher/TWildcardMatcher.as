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
import org.as2lib.aop.matcher.WildcardMatcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.matcher.TWildcardMatcher extends TestCase {
	
	public function testMatchWithNullJoinPoint(Void):Void {
		var m:WildcardMatcher = new WildcardMatcher();
		assertFalse(m.match(null, "*"));
	}
	
	public function testMatchWithBlankStringJoinPoint(Void):Void {
		var m:WildcardMatcher = new WildcardMatcher();
		assertFalse(m.match("", "*"));
	}
	
	public function testMatchWithNullPattern(Void):Void {
		var m:WildcardMatcher = new WildcardMatcher();
		assertTrue(m.match("MyClass", null));
	}
	
	public function testMatchWithBlankStringPattern(Void):Void {
		var m:WildcardMatcher = new WildcardMatcher();
		assertTrue(m.match("MyClass", ""));
	}
	
	public function testMatchWithNullJoinPointAndPattern(Void):Void {
		var m:WildcardMatcher = new WildcardMatcher();
		assertFalse(m.match("", null));
	}
	
	public function testMatchWithoutWildcards(Void):Void {
		var m:WildcardMatcher = new WildcardMatcher();
		assertTrue(m.match("org.as2lib.core.BasicClass.myMethod", "org.as2lib.core.BasicClass.myMethod"));
		assertFalse(m.match("org.as2lib.core.BasicClass.myMethod", "org.as2lib.BasicClass.myMethod"));
	}
	
	public function testMatchWithAsteriskReplacingCompleteNode(Void):Void {
		var m:WildcardMatcher = new WildcardMatcher();
		assertTrue("1", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean"));
		assertTrue("2", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org.as2lib.env.bean.factory.support.DefaultBeanFactory.*"));
		assertTrue("3", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org.as2lib.env.bean.*.support.DefaultBeanFactory.getBean"));
		assertTrue("4", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*.as2lib.*.bean.factory.*.*.*"));
		assertFalse("5", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*.*.as2lib.*.bean.factory.*.*.*"));
		assertFalse("6", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*.as2lib.*.bean.factory.*.*.*.*"));
		assertFalse("7", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org.as2lib.env.bean.factory.support.DefaultBeanFactory.*.getBean"));
		assertFalse("8", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org.as2lib.*.bean.factory.*.*.DefaultBeanFactory.getBean"));
	}
	
	public function testMatchWithAsteriskReplacingOnlyNodeParts(Void):Void {
		var m:WildcardMatcher = new WildcardMatcher();
		assertTrue("1", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean"));
		assertTrue("2", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org.as2lib.env.bean.factory.support.DefaultBeanFactory.get*"));
		assertTrue("3", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.as2lib.env.bean.factory.*port.DefaultBeanFactory.*Bean"));
		assertTrue("4", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.as2lib.env.bean.factory.support.Default*Factory.getBean"));
		assertTrue("5", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.a*l*.env.bean.*cto*.support.Default*Factory.getBean"));
		assertTrue("6", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.a*l*.env.bean.*cto*.support.D*ault*Fa*o*.getBean"));
		assertFalse("7", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.a*l*.env.unexpectedpackage.bean.*cto*.support.D*ault*Fa*o*.getBean"));
		assertFalse("8", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.a*l*.env.*.bean.*cto*.support.unexpected*.D*ault*Fa*o*.getBean"));
		assertFalse("9", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*.*rg.a*l*.env.*.bean.*cto*.support.D*ault*Fa*o*.getBean"));
		assertFalse("10", m.match("ClassMy.myMethod", "*Class.myMethod"));
		assertFalse("11", m.match("MyClass.myMethod", "Class*.myMethod"));
		assertFalse("12", m.match("MyBeanClass.myMethod", "Another*Class.myMethod"));
	}
	
	public function testMatchWithDoublePeriod(Void):Void {
		var m:WildcardMatcher = new WildcardMatcher();
		assertTrue("1", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "..org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean"));
		assertTrue("2", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "..as2lib.env.bean.factory.support.DefaultBeanFactory.getBean"));
		assertTrue("3", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org..factory.support.DefaultBeanFactory.getBean"));
		assertTrue("4", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org..factory..DefaultBeanFactory.getBean"));
		assertTrue("5", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org..factory.support..DefaultBeanFactory.getBean"));
		assertTrue("6", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org.as2lib..DefaultBeanFactory.getBean"));
		assertTrue("7", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "..DefaultBeanFactory.getBean"));
		assertFalse("8", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org.as2lib.env.bean..unexpectedpackage.support.DefaultBeanFactory.getBean"));
		assertFalse("9", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org.as2lib..support.unexpectedpackage..DefaultBeanFactory.getBean"));
		assertFalse("10", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org.as2lib.env..support..unexpectedpackage.DefaultBeanFactory.getBean"));
		assertTrue("11", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org.as2lib..env.bean..factory..support.DefaultBeanFactory.getBean"));
	}
	
	public function testMatchWithDoublePeriodAndAsterisk(Void):Void {
		var m:WildcardMatcher = new WildcardMatcher();
		assertTrue(m.match("com.simonwacker.talk.fft05.FileBrowser.browse", "com.simonwacker.talk.fft05..*.*"));
		assertTrue(m.match("com.simonwacker.talk.fft05.view.file.FileView.show", "com.simonwacker.talk.fft05..*.*"));
		assertFalse(m.match("com.simonwacker.talk.FileBrowser.browse", "com.simonwacker.talk.fft05..*.*"));
		assertTrue(m.match("com.simonwacker.talk.fft05.FileBrowser.browse", "com..fft05.*.br*"));
		assertTrue(m.match("com.simonwacker.talk.fft05.FileBrowser.browse", "com.simonwacker..talk.fft05.*Browser.browse"));
		assertTrue(m.match("com.simonwacker.talk.fft05.FileBrowser.browse", "com.*..talk.fft05.*Browser.browse"));
		assertTrue(m.match("com.simonwacker.talk.fft05.FileBrowser.browse", "com.simonwacker..*.fft05.*Browser.browse"));
		trace("###############");
		assertTrue(m.match("com.simonwacker.talk.fft05.view.FileViewMap.showFile", "com.simonwacker.talk.fft05..*.showFile"));
		trace("###############");
		assertFalse(m.match("com.simonwacker.talk.FileViewMap.showFile", "com.simonwacker.talk.fft05..*.showFile"));
	}
	
}