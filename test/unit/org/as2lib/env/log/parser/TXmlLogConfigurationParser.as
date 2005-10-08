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

import org.as2lib.env.log.parser.XmlLogConfigurationParser;
import org.as2lib.test.mock.MockControl;
import org.as2lib.test.unit.TestCase;
import org.as2lib.env.reflect.NoSuchMethodException;
import org.as2lib.env.log.parser.LogManagerStub;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.TXmlLogConfigurationParser extends TestCase {
	
	public function testParseWithIllegalConfiguration(Void):Void {
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(Object);
		try {
			p.parse(null);
			fail("expected IllegalArgumentException for 'null' argument");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		try {
			p.parse();
			fail("expected IllegalArgumentException for undefined argument");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testParseWithSyntacticallyMalformedXml(Void):Void {
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(Object);
		try {
			p.parse("<logging><repository><repository></logging>");
			fail("expected LogConfigurationParseException for syntactically incorrect xml");
		} catch (e:org.as2lib.env.log.parser.LogConfigurationParseException) {
		}
		try {
			p.parse("<logging><repository></repositor></logging>");
			fail("expected LogConfigurationParseException for syntactically incorrect xml");
		} catch (e:org.as2lib.env.log.parser.LogConfigurationParseException) {
		}
		try {
			p.parse("<logging><repository attribute></repository></logging>");
			fail("expected LogConfigurationParseException for syntactically incorrect xml");
		} catch (e:org.as2lib.env.log.parser.LogConfigurationParseException) {
		}
		try {
			p.parse("<logging><repository attribute=></repository></logging>");
			fail("expected LogConfigurationParseException for syntactically incorrect xml");
		} catch (e:org.as2lib.env.log.parser.LogConfigurationParseException) {
		}
		try {
			p.parse("<logging></repository></logging>");
			fail("expected LogConfigurationParseException for syntactically incorrect xml");
		} catch (e:org.as2lib.env.log.parser.LogConfigurationParseException) {
		}
	}
	
	public function testParseWithWrongRootNode(Void):Void {
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(Object);
		try {
			p.parse("<log></log>");
			fail("expected LogConfigurationParseException for wrong root node");
		} catch (e:org.as2lib.env.log.parser.LogConfigurationParseException) {
		}
	}
	
	public function testParseWithUnknownMethodInLogManager(Void):Void {
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(Object);
		try {
			p.parse("<logging><repository></repository></logging>");
			fail("expected NoSuchMethodException for child node 'repository'");
		} catch (e:org.as2lib.env.reflect.NoSuchMethodException) {
		}
		try {
			p.parse("<logging><repository></repository></logging>");
			fail("expected NoSuchMethodException for child node 'logger'");
		} catch (e:org.as2lib.env.reflect.NoSuchMethodException) {
		}
	}
	
	public function testParseWithKnownSetMethodInLogManager(Void):Void {
		var c:MockControl = new MockControl(Object);
		var m = c.getMock();
		m.setRepository(null);
		c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([org.as2lib.env.log.LoggerRepository]));
		m.replay();
		
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(m);
		p.parse("<logging><repository class='org.as2lib.env.log.LoggerRepository'></repository></logging>");
		
		m.verify();
	}
	
	public function testParseWithKnownAddMethodInLogManager(Void):Void {
		var c:MockControl = new MockControl(Object);
		var m = c.getMock();
		m.addRepository(null);
		c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([org.as2lib.env.log.LoggerRepository]));
		m.replay();
		
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(m);
		p.parse("<logging><repository class='org.as2lib.env.log.LoggerRepository'></repository></logging>");
		
		m.verify();
	}
	
	public function testParseWithUnknownClass(Void):Void {
		var c:MockControl = new MockControl(Object);
		var m = c.getMock();
		m.replay();
		
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(m);
		try {
			p.parse("<logging><repository class='org.as2lib.env.log.repository.UnknownLoggerRepository'></repository></logging>");
			fail("expected ClassNotFoundException");
		} catch (e:org.as2lib.env.reflect.ClassNotFoundException) {
		}
		
		m.verify();
	}
	
	public function testParseWithUnspecifiedClassAttribute(Void):Void {
		var c:MockControl = new MockControl(Object);
		var m = c.getMock();
		m.replay();
		
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(m);
		try {
			p.parse("<logging><repository></repository></logging>");
			fail("expected LogConfigurationParseException");
		} catch (e:org.as2lib.env.log.parser.LogConfigurationParseException) {
		}
		
		m.verify();
	}
	
	public function testParseWithUnknownNodeMethods(Void):Void {
		var c:MockControl = new MockControl(Object);
		var m = c.getMock();
		m.addRepository(null);
		c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([Object]));
		m.replay();
		
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(m);
		try {
			p.parse("<logging><repository class='Object'><unknownNode></unknownNode></repository></logging>");
			fail("expected NoSuchMethodException");
		} catch (e:org.as2lib.env.reflect.NoSuchMethodException) {
		}
		
		m.verify();
	}
	
	public function testParseWithUnknownAddNodeMethod(Void):Void {
		_global.org.as2lib.env.log.parser.MyClass = function() {};
		_global.org.as2lib.env.log.parser.MyClass.prototype.setMyNode = function() {
		};
		
		var c:MockControl = new MockControl(Object);
		var m = c.getMock();
		m.addRepository(null);
		c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([Object]));
		m.replay();
		
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(m);
		p.parse("<logging><repository class='org.as2lib.env.log.parser.MyClass'><myNode class='Object'></myNode></repository></logging>");
				
		m.verify();
	}
	
	public function testParseWithUnknownSetNodeMethod(Void):Void {
		_global.org.as2lib.env.log.parser.MyClass = function() {};
		_global.org.as2lib.env.log.parser.MyClass.prototype.addMyNode = function() {
		};
		
		var c:MockControl = new MockControl(Object);
		var m = c.getMock();
		m.addRepository(null);
		c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([Object]));
		m.replay();
		
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(m);
		p.parse("<logging><repository class='org.as2lib.env.log.parser.MyClass'><myNode class='Object'></myNode></repository></logging>");
				
		m.verify();
	}
	
	public function testParseWithUnknownAttributeMethod(Void):Void {
		var c:MockControl = new MockControl(Object);
		var m = c.getMock();
		m.addRepository(null);
		c.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([Object]));
		m.replay();
		
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(m);
		try {
			p.parse("<logging><repository class='Object' unknownAttribute='blubber'></repository></logging>");
			fail("expected NoSuchMethodException");
		} catch (e:org.as2lib.env.reflect.NoSuchMethodException) {
		}
		
		m.verify();
	}
	
	public function testParseComplexLogConfiguration(Void):Void {
		org.as2lib.env.log.parser.LoggerStub.testCase = this;
		org.as2lib.env.log.parser.HandlerStub.testCase = this;
		org.as2lib.env.log.parser.RepositoryStub.testCase = this;
		org.as2lib.env.log.parser.SpecialLoggerStub.testCase = this;
		org.as2lib.env.log.parser.LevelStub.testCase = this;
		
		var c:String = "<logging>";
		c += "  <register name='logger' class='org.as2lib.env.log.parser.LoggerStub'/>";
		c += "  <register name='handler' class='org.as2lib.env.log.parser.HandlerStub'/>";
		c += "  <repository class='org.as2lib.env.log.parser.RepositoryStub'>";
		c += "    <logger level='FATAL' class='org.as2lib.env.log.parser.SpecialLoggerStub'>";
		c += "      <name>com.simonwacker.test</name>";
		c += "      <handler level='ERROR'/>";
		c += "      <handler level='UNKNOWN' class='org.as2lib.env.log.parser.HandlerStub'/>";
		c += "      <handler level='WARNING'>";
		c += "        <constructor-arg>Constructor Argument 1!</constructor-arg>";
		c += "        <constructor-arg>Constructor Argument 2!</constructor-arg>";
		c += "      </handler>";
		c += "    </logger>";
		c += "    <logger name='com.simonwacker.test.package.MyClass'>";
		c += "      <constructor-arg class='org.as2lib.env.log.parser.LevelStub'>";
		c += "        <constructor-arg>32</constructor-arg>";
		c += "        <constructor-arg>CustomLevel</constructor-arg>";
		c += "        <constructor-arg>true</constructor-arg>";
		c += "      </constructor-arg>";
		c += "    </logger>";
		c += "  </repository>";
		c += "  <logger name='useless' number='3' boolean='false' string='test'>";
		c += "    <handler class='org.as2lib.env.log.parser.HandlerStub'/>";
		c += "  </logger>";
		c += "</logging>";
		
		var m:LogManagerStub = new LogManagerStub(this);
		var p:XmlLogConfigurationParser = new XmlLogConfigurationParser(m);
		try {
			p.parse(c);
		} catch (e) {
			trace(e);
		}
		
		m.verify();
		org.as2lib.env.log.parser.LoggerStub.verify();
		org.as2lib.env.log.parser.HandlerStub.verify();
		org.as2lib.env.log.parser.RepositoryStub.verify();
		org.as2lib.env.log.parser.SpecialLoggerStub.verify();
		org.as2lib.env.log.parser.LevelStub.verify();
	}
	
}