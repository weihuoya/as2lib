﻿/*
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
import org.as2lib.env.reflect.PackageMemberInfo;
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
	
	public function testExecuteWithCachedClassInfo(Void):Void {
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
	}
	
	public function testExecuteWihtUnkownClass(Void):Void {
		var Clazz:Function = function() {};
		var o = new Clazz();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClass(o);
		cc.setReturnValue(null);
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
		// What's wrong with this? --> c.addPackage() must always return the correct package because it is needed
		/*var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClass(TClassAlgorithm);
		cc.setReturnValue(null);
		c.getRoot();
		cc.setReturnValue(ReflectConfig.getRootPackage());
		cc.replay();*/
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		//a.setCache(c);
		
		var info:PackageMemberInfo = a.execute(TClassAlgorithm);
		assertNotNull("Class for object could not be found.", info);
		var objectInfo:ClassInfo = ClassInfo(info);
		assertNotNull("Returned instance is not of type ClassInfo.", objectInfo);
		assertSame("Type of class is not TClassAlgorithm.", objectInfo.getType(), TClassAlgorithm);
		assertSame("Name of class is not 'TClassAlgorithm'.", objectInfo.getName(), "TClassAlgorithm");
		
		var package:PackageInfo = objectInfo.getPackage();
		assertNotNull("Parent package is null.", package);
		assertSame("Parent package is wrong.", package.getPackage(), _global.org.as2lib.env.reflect.algorithm);
		assertSame("Parent package name is not algorithm.", package.getName(), "algorithm");
		
		//cc.verify();
	}
	
	public function testExecuteByInterface(Void):Void {
		// What's wrong with this? --> c.addPackage() must always return the correct package because it is needed
		/*var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClass(BasicInterface);
		cc.setReturnValue(null);
		c.getRoot();
		cc.setReturnValue(ReflectConfig.getRootPackage());
		cc.replay();*/
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		//a.setCache(c);
		
		var info:PackageMemberInfo = a.execute(BasicInterface);
		assertNotNull("Class for object could not be found.", info);
		var objectInfo:ClassInfo = ClassInfo(info);
		assertNotNull("Returned instance is not of type ClassInfo.", objectInfo);
		assertSame("Type of class is not BasicInterface.", objectInfo.getType(), BasicInterface);
		assertSame("Name of class is not 'BasicInterface'.", objectInfo.getName(), "BasicInterface");
		
		var package:PackageInfo = objectInfo.getPackage();
		assertNotNull("Parent package is null.", package);
		assertSame("Parent package is wrong.", package.getPackage(), _global.org.as2lib.core);
		assertSame("Parent package name is not core.", package.getName(), "core");
		
		//cc.verify();
	}
	
	public function testExecuteByObject(Void):Void {
		var o:BasicClass = new BasicClass();
		
		// What's wrong with this? --> c.addPackage() must always return the correct package because it is needed
		/*var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClass(o);
		cc.setReturnValue(null);
		c.getRoot();
		cc.setReturnValue(ReflectConfig.getRootPackage());
		cc.replay();*/
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		//a.setCache(c);
		
		var info:PackageMemberInfo = a.execute(o);
		assertNotNull("Class for object could not be found.", info);
		var objectInfo:ClassInfo = ClassInfo(info);
		assertNotNull("Returned instance is not of type ClassInfo.", objectInfo);
		assertSame("Type of class is not BasicClass.", objectInfo.getType(), BasicClass);
		assertSame("Name of class is not 'BasicClass'.", objectInfo.getName(), "BasicClass");
		
		var package:PackageInfo = objectInfo.getPackage();
		assertNotNull("Parent package is null.", package);
		assertSame("Parent package is wrong.", package.getPackage(), _global.org.as2lib.core);
		assertSame("Parent package name is not core.", package.getName(), "core");
		
		//cc.verify();
	}
	
	public function testExecuteByString(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClass("a");
		cc.setReturnValue(null);
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		c.addClass(null);
		cc.setReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([ClassInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);

		var info:PackageMemberInfo = a.execute("a");
		assertNotNull("Class for string could not be found.", info);
		var stringInfo:ClassInfo = ClassInfo(info);
		assertNotNull("Returned instance is not of type ClassInfo.", stringInfo);
		assertSame("Type of class is not string.", stringInfo.getType(), String);
		assertSame("Containing package is not root package.", stringInfo.getPackage(), PackageInfo.getRootPackage());
		assertSame("Name of class is not 'String'.", stringInfo.getName(), "String");
		
		cc.verify();
	}
	
	public function testExecuteByNumber(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClass(32);
		cc.setReturnValue(null);
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		c.addClass(null);
		cc.setReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([ClassInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);

		var info:PackageMemberInfo = a.execute(32);
		assertNotNull("Class for number could not be found.", info);
		var numberInfo:ClassInfo = ClassInfo(info);
		assertNotNull("Returned instance is not of type ClassInfo.", numberInfo);
		assertSame("Type of class is not Number.", numberInfo.getType(), Number);
		assertSame("Containing package is not root package.", numberInfo.getPackage(), PackageInfo.getRootPackage());
		assertSame("Name of class is not 'Number'.", numberInfo.getName(), "Number");
		
		cc.verify();
	}
	
	public function testExecuteByBoolean(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClass(false);
		cc.setReturnValue(null);
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		c.addClass(null);
		cc.setReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([ClassInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);

		var info:PackageMemberInfo = a.execute(false);
		assertNotNull("Class for boolean could not be found.", info);
		var booleanInfo:ClassInfo = ClassInfo(info);
		assertNotNull("Returned instance is not of type ClassInfo.", booleanInfo);
		assertSame("Type of class is not Boolean.", booleanInfo.getType(), Boolean);
		assertSame("Containing package is not root package.", booleanInfo.getPackage(), PackageInfo.getRootPackage());
		assertSame("Name of class is not 'Boolean'.", booleanInfo.getName(), "Boolean");
		
		cc.verify();
	}
	
	public function testExecuteByFunction(Void):Void {
		var f:Function = function() {};
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClass(f);
		cc.setReturnValue(null);
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		c.addClass(null);
		cc.setReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([ClassInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);

		var info:PackageMemberInfo = a.execute(f);
		assertNotNull("Class for function could not be found.", info);
		var functionInfo:ClassInfo = ClassInfo(info);
		assertNotNull("Returned instance is not of type ClassInfo.", functionInfo);
		assertSame("Type of class is not Function.", functionInfo.getType(), Function);
		assertSame("Containing package is not root package.", functionInfo.getPackage(), PackageInfo.getRootPackage());
		assertSame("Name of class is not 'Function'.", functionInfo.getName(), "Function");
		
		cc.verify();
	}
	
	public function testExecuteByMovieClip(Void):Void {
		_root.createEmptyMovieClip("testExecuteByMovieClip_mc", _root.getNextHighestDepth());
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClass(_root.testExecuteByMovieClip_mc);
		cc.setReturnValue(null);
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		c.addClass(null);
		cc.setReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([ClassInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);

		var info:PackageMemberInfo = a.execute(_root.testExecuteByMovieClip_mc);
		assertNotNull("Class for movieclip could not be found.", info);
		var movieClipInfo:ClassInfo = ClassInfo(info);
		assertNotNull("Returned instance is not of type ClassInfo.", movieClipInfo);
		assertSame("Type of class is not MovieClip.", movieClipInfo.getType(), MovieClip);
		assertSame("Containing package is not root package.", movieClipInfo.getPackage(), PackageInfo.getRootPackage());
		assertSame("Name of class is not 'MovieClip'.", movieClipInfo.getName(), "MovieClip");
		
		cc.verify();
		_root.testExecuteByMovieClip_mc.removeMovieClip();
	}
	
	public function testExecuteByTextField(Void):Void {
		_root.createTextField("testExecuteByTextField_txt", _root.getNextHighestDepth(), 100, 100, 100, 100);
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClass(_root.testExecuteByTextField_txt);
		cc.setReturnValue(null);
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.getPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		c.addPackage(null);
		cc.setDefaultReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		c.addClass(null);
		cc.setReturnValue(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([ClassInfo]));
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);

		var info:PackageMemberInfo = a.execute(_root.testExecuteByTextField_txt);
		assertNotNull("Class for textfield could not be found.", info);
		var movieClipInfo:ClassInfo = ClassInfo(info);
		assertNotNull("Returned instance is not of type ClassInfo.", movieClipInfo);
		assertSame("Type of class is not TextField.", movieClipInfo.getType(), TextField);
		assertSame("Containing package is not root package.", movieClipInfo.getPackage(), PackageInfo.getRootPackage());
		assertSame("Name of class is not 'TextField'.", movieClipInfo.getName(), "TextField");
		
		cc.verify();
		_root.testExecuteByTextField_txt.removeTextField();
	}
	
	public function testExecuteByNameWithNullName(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		assertNull(a.executeByName(null));
		assertNull(a.executeByName(undefined));
		assertNull(a.executeByName());
		
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
		c.getClass(org.as2lib.core.BasicClass);
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
		assertNull(a.executeByName("org.as2lib.core.UnknownClass"));
		
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
		c.getClass(_global.org.as2lib.core);
		cc.setReturnValue(null);
		cc.replay();
		
		var a:ClassAlgorithm = new ClassAlgorithm();
		a.setCache(c);
		assertNull(a.executeByName("org.as2lib.core"));
		
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
		assertSame("wrong root package", i.getPackage().getPackage().getPackage().getPackage(), r);
		
		rc.verify();
	}
	
}