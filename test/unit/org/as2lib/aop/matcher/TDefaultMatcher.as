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
import org.as2lib.aop.matcher.DefaultMatcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.matcher.TDefaultMatcher extends TestCase {
	
	public function testMatchWithNullJoinPoint(Void):Void {
		var m:DefaultMatcher = new DefaultMatcher();
		assertFalse(m.match(null, "*"));
	}
	
	public function testMatchWithBlankStringJoinPoint(Void):Void {
		var m:DefaultMatcher = new DefaultMatcher();
		assertFalse(m.match("", "*"));
	}
	
	public function testMatchWithNullPattern(Void):Void {
		var m:DefaultMatcher = new DefaultMatcher();
		assertTrue(m.match("MyClass", null));
	}
	
	public function testMatchWithBlankStringPattern(Void):Void {
		var m:DefaultMatcher = new DefaultMatcher();
		assertTrue(m.match("MyClass", ""));
	}
	
	public function testMatchWithNullJoinPointAndPattern(Void):Void {
		var m:DefaultMatcher = new DefaultMatcher();
		assertFalse(m.match("", null));
	}
	
	public function testMatchWithoutWildcards(Void):Void {
		var m:DefaultMatcher = new DefaultMatcher();
		assertTrue(m.match("org.as2lib.core.BasicClass.myMethod", "org.as2lib.core.BasicClass.myMethod"));
		assertFalse(m.match("org.as2lib.core.BasicClass.myMethod", "org.as2lib.BasicClass.myMethod"));
	}
	
	public function testMatchWithAsteriskReplacingCompleteNode(Void):Void {
		var m:DefaultMatcher = new DefaultMatcher();
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
		var m:DefaultMatcher = new DefaultMatcher();
		assertTrue("1", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean"));
		assertTrue("2", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "org.as2lib.env.bean.factory.support.DefaultBeanFactory.get*"));
		assertTrue("3", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.as2lib.env.bean.factory.*port.DefaultBeanFactory.*Bean"));
		assertTrue("4", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.as2lib.env.bean.factory.support.Default*Factory.getBean"));
		assertTrue("5", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.a*l*.env.bean.*cto*.support.Default*Factory.getBean"));
		assertTrue("6", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.a*l*.env.bean.*cto*.support.D*ault*Fa*o*.getBean"));
		assertFalse("7", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.a*l*.env.unexpectedpackage.bean.*cto*.support.D*ault*Fa*o*.getBean"));
		assertFalse("8", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*rg.a*l*.env.*.bean.*cto*.support.unexpected*.D*ault*Fa*o*.getBean"));
		assertFalse("9", m.match("org.as2lib.env.bean.factory.support.DefaultBeanFactory.getBean", "*.*rg.a*l*.env.*.bean.*cto*.support.D*ault*Fa*o*.getBean"));
	}
	
	public function testMatchWithDoublePeriod(Void):Void {
		var m:DefaultMatcher = new DefaultMatcher();
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
	
}