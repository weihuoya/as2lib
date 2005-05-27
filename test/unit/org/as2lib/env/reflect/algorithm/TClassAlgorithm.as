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
import org.as2lib.env.reflect.algorithm.ClassAlgorithm;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.SimpleCache;
import org.as2lib.core.BasicClass;
import org.as2lib.core.BasicInterface;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.TClassAlgorithm extends TestCase {
	
	public function testExecuteByNullAndUndefined(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);
		
		assertNull(a.execute(null));
		assertNull(a.execute(undefined));
		cc.verify();
	}
	
	// this is not checked anymore
	/*public function testExecuteWithCachedClassInfo(Void):Void {
		var info = new Object();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClass(TClassAlgorithm);
		cc.setReturnValue(info);
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);
		
		assertSame(a.execute(TClassAlgorithm), info);
		cc.verify();
	}*/
	
	public function testExecuteWihtUnkownClass(Void):Void {
		var Clazz:Function = function() {};
		var o = new Clazz();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);
		
		assertNull(a.execute(o));
		
		cc.verify();
	}
	
	public function testExecuteByClass(Void):Void {
		var a:ClassAlgorithm = new ClassAlgorithm();
		var info:Object = a.execute(TClassAlgorithm);
		assertNotNull("class for object could not be found", info);
		assertSame(info.clazz, TClassAlgorithm);
		assertSame(info.name, "TClassAlgorithm");
		var p:PackageInfo = info.package;
		assertNotNull("parent package is null", p);
		assertSame(p.getName(), "algorithm");
		assertSame(p.getPackage(), _global.org.as2lib.env.reflect.algorithm);
		assertSame(p.getParent().getName(), "reflect");
	}
	
	public function testExecuteByInterface(Void):Void {
		var a:ClassAlgorithm = new ClassAlgorithm();
		var info:Object = a.execute(BasicInterface);
		assertNotNull("class for object could not be found", info);
		assertSame(info.clazz, BasicInterface);
		assertSame(info.name, "BasicInterface");
		var p:PackageInfo = info.package;
		assertNotNull("parent package is null", p);
		assertSame(p.getName(), "core");
		assertSame(p.getPackage(), _global.org.as2lib.core);
		assertSame(p.getParent().getName(), "as2lib");
	}
	
	public function testExecuteByObject(Void):Void {
		var o:BasicClass = new BasicClass();
		var a:ClassAlgorithm = new ClassAlgorithm();
		var info:Object = a.execute(o);
		assertNotNull("class for object could not be found", info);
		assertSame(info.clazz, BasicClass);
		assertSame(info.name, "BasicClass");
		var p:PackageInfo = info.package;
		assertNotNull("parent package is null", p);
		assertSame(p.getName(), "core");
		assertSame(p.getPackage(), _global.org.as2lib.core);
		assertSame(p.getParent().getName(), "as2lib");
	}
	
	public function testExecuteByString(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);
		
		var info:Object = a.execute("a");
		assertNotNull("Class for string could not be found.", info);
		assertSame("Type of class is not string.", info.clazz, String);
		assertSame("Containing package is not root package.", info.package, PackageInfo.getRootPackage());
		assertSame("Name of class is not 'String'.", info.name, "String");
		
		cc.verify();
	}
	
	public function testExecuteByNumber(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);

		var info:Object = a.execute(32);
		assertNotNull("Class for number could not be found.", info);
		assertSame("Type of class is not Number.", info.clazz, Number);
		assertSame("Containing package is not root package.", info.package, PackageInfo.getRootPackage());
		assertSame("Name of class is not 'Number'.", info.name, "Number");
		
		cc.verify();
	}
	
	public function testExecuteByBoolean(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);

		var info:Object = a.execute(false);
		assertNotNull("Class for boolean could not be found.", info);
		assertSame("Type of class is not Boolean.", info.clazz, Boolean);
		assertSame("Containing package is not root package.", info.package, PackageInfo.getRootPackage());
		assertSame("Name of class is not 'Boolean'.", info.name, "Boolean");
		
		cc.verify();
	}
	
	public function testExecuteByInstanceWithFunction(Void):Void {
		var f:Function = function() {};
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);

		var info:Object = a.executeByInstance(f);
		assertNotNull("Class for function could not be found.", info);
		assertSame("Type of class is not Function.", info.clazz, Function);
		assertSame("Containing package is not root package.", info.package, PackageInfo.getRootPackage());
		assertSame("Name of class is not 'Function'.", info.name, "Function");
		
		cc.verify();
	}
	
	public function testExecuteByMovieClip(Void):Void {
		_root.createEmptyMovieClip("testExecuteByMovieClip_mc", _root.getNextHighestDepth());
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);

		var info:Object = a.execute(_root.testExecuteByMovieClip_mc);
		assertNotNull("Class for movieclip could not be found.", info);
		assertSame("Type of class is not MovieClip.", info.clazz, MovieClip);
		assertSame("Containing package is not root package.", info.package, PackageInfo.getRootPackage());
		assertSame("Name of class is not 'MovieClip'.", info.name, "MovieClip");
		
		cc.verify();
		_root.testExecuteByMovieClip_mc.removeMovieClip();
	}
	
	public function testExecuteByTextField(Void):Void {
		_root.createTextField("testExecuteByTextField_txt", _root.getNextHighestDepth(), 100, 100, 100, 100);
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);

		var info:Object = a.execute(_root.testExecuteByTextField_txt);
		assertNotNull("Class for textfield could not be found.", info);
		assertSame("Type of class is not TextField.", info.clazz, TextField);
		assertSame("Containing package is not root package.", info.package, PackageInfo.getRootPackage());
		assertSame("Name of class is not 'TextField'.", info.name, "TextField");
		
		cc.verify();
		_root.testExecuteByTextField_txt.removeTextField();
	}
	
	public function testExecuteByNameWithNullName(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		try {
			assertNull(a.executeByName(null));
			fail("expected IllegalArgumentException for null name");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		try {
			assertNull(a.executeByName(undefined));
			fail("expected IllegalArgumentException for undefined name");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		try {
			assertNull(a.executeByName());
			fail("expected IllegalArgumentException for no name");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		cc.verify();
	}
	
	public function testExecuteByNameWithCachedClassInfo(Void):Void {
		var rc:MockControl = new MockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.getFullName();
		rc.setReturnValue("_global");
		rc.replay();
		
		var ic:MockControl = new MockControl(ClassInfo);
		var i:ClassInfo = ic.getMock();
		ic.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(r);
		c.getClassByClass(org.as2lib.core.BasicClass);
		cc.setReturnValue(i);
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);
		assertSame(a.executeByName("org.as2lib.core.BasicClass"), i);
		
		cc.verify();
		ic.verify();
		rc.verify();
	}
	
	public function testExecuteByNameWithIllegalName(Void):Void {
		var rc:MockControl = new MockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.getFullName();
		rc.setReturnValue("_global");
		rc.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(r);
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);
		try {
			assertNull(a.executeByName("org.as2lib.core.UnknownClass"));
			fail("expected ClassNotFoundException for illegal class name");
		} catch (e:org.as2lib.env.reflect.ClassNotFoundException) {
		}
		
		cc.verify();
		rc.verify();
	}
	
	public function testExecuteByNameWithIllegalType(Void):Void {
		var rc:MockControl = new MockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.getFullName();
		rc.setReturnValue("_global");
		rc.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(r);
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);
		try {
			assertNull(a.executeByName("org.as2lib.core"));
			fail("expected IllegalArgumentException for illegal type");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		cc.verify();
		rc.verify();
	}
	
	public function testExecuteByName(Void):Void {
		_global.org.as2lib.core.TClassAlgorithmTestExecute = function() {};
		
		var rc:MockControl = new MockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.getFullName();
		rc.setReturnValue("_global");
		r.getPackage();
		rc.setReturnValue(_global, 2);
		r.isRoot();
		rc.setDefaultReturnValue(true);
		rc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(new SimpleCache(r));
		var i:ClassInfo = a.executeByName("org.as2lib.core.TClassAlgorithmTestExecute");
		assertSame(i.getName(), "TClassAlgorithmTestExecute");
		assertSame(i.getFullName(), "org.as2lib.core.TClassAlgorithmTestExecute");
		assertSame("wrong type ", i.getType(), _global.org.as2lib.core.TClassAlgorithmTestExecute);
		assertSame(i.getPackage().getFullName(), "org.as2lib.core");
		assertSame("wrong package", i.getPackage().getPackage(), _global.org.as2lib.core);
		assertSame("wrong root package", i.getPackage().getParent().getParent().getParent(), r);
		
		rc.verify();
	}
	
}