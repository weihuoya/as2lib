import org.as2lib.test.unit.TestCase;
import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.CompositeMemberInfo;
import test.unit.org.as2lib.env.reflect.treflect.SubClass;
import test.unit.org.as2lib.env.reflect.treflect.SuperClass;
import test.unit.org.as2lib.env.reflect.treflect.package0.Package0Class;
import test.unit.org.as2lib.env.reflect.treflect.package1.Package1Class;

import org.as2lib.core.BasicClass;

class test.unit.org.as2lib.env.reflect.TReflect extends TestCase {
	private var subClass:SubClass;
	private var superClass:SuperClass;
	
	private var subInfo:ClassInfo;
	private var superInfo:ClassInfo;
	
	private var package;
	private var subPackageInfo:PackageInfo;
	private var superPackageInfo:PackageInfo;
	
	private var children:Array;
	private var methods:Array;
	private var properties:Array;
	
	public function TReflect(Void) {}
	
	public function setUp(Void):Void {
		subClass = new SubClass();
		superClass = new SuperClass();
		
		subInfo = subClass.getClass();
		superInfo = superClass.getClass();
		
		package = _global.test.unit.org.as2lib.env.reflect.treflect;
		subPackageInfo = subInfo.getParent();
		superPackageInfo = superInfo.getParent();
		
		children = subPackageInfo.getChildren();
		methods = subInfo.getMethods();
		properties = subInfo.getProperties();
		
		Package0Class;
		Package1Class;
	}
	
	public function testGetClassInfo(Void):Void {
		assertNotUndefined("Could not obtain ClassInfo from instance [" + subClass + "].", subInfo);
		assertNotUndefined("Could not obtain ClassInfo from instance [" + superClass + "].", superInfo);
		
		var tempSubInfo:ClassInfo = subClass.getClass();
		assertEquals("The two ClassInfos [" + subInfo + " and " + tempSubInfo + "] obtained from the same instance are not equal.", subInfo, tempSubInfo);
		
		var tempSuperInfo:ClassInfo = superClass.getClass();
		assertEquals("The two ClassInfos [" + superInfo + " and " + tempSuperInfo + "] obtained from the same instance are not equal.", superInfo, tempSuperInfo);
	}
	
	public function testGetPackageInfo(Void):Void {
		assertNotUndefined("Could not obtain PackageInfo from package [" + package + "].", subPackageInfo);
		assertNotUndefined("Could not obtain PackageInfo from package [" + package + "].", superPackageInfo);
		
		assertEquals("The two PackageInfos [" + subPackageInfo + " and " + superPackageInfo + "] obtained from the getParent() methods of the ClassInfos from two classes in the same package are not equal.", subPackageInfo, superPackageInfo);
		
		var tempSubPackageInfo:PackageInfo = subInfo.getParent();
		assertEquals("The two PackageInfos [" + subPackageInfo + " and " + tempSubPackageInfo + "] obtained from the getParent() method of the same ClassInfo are not equal.", subPackageInfo, tempSubPackageInfo);
		
		var tempSuperPackageInfo:PackageInfo = superInfo.getParent();
		assertEquals("The two PackageInfos [" + superPackageInfo + " and " + tempSuperPackageInfo + "] obtained from the getParent() method of the same ClassInfo are not equal.", superPackageInfo, tempSuperPackageInfo);
	}
	
	public function testGetChildren(Void):Void {
		assertNotUndefined("Could not obtain children from PackageInfo [" + subPackageInfo + "].", children);
		assertEquals("The amount of children found [" + children.length + "] does not match the actual amount [4] of children.", children.length, 4);
	}
	
	public function testGetMethods(Void):Void {
		assertNotUndefined("Could not obtain methods from ClassInfo [" + subInfo + "].", methods);
		assertEquals("The amount of methods found [" + methods.length + "] does not match the actual amount [16] of methods.", methods.length, 16);
	}
	
	public function testGetProperties(Void):Void {
		assertNotUndefined("Could not obtain methods from ClassInfo [" + subInfo + "].", properties);
		assertEquals("The amount of properties found [" + properties.length + "] does not match the actual amount [3] of properties.", properties.length, 3);
	}
	
	public function testGetName(Void):Void {
		var subName:String = subInfo.getName();
		var superName:String = superInfo.getName();
		var packageName:String = subPackageInfo.getName();
		
		assertNotUndefined("The name of the ClassInfo [" + subInfo + "] could not be obtained.", subName);
		assertNotUndefined("The name of the ClassInfo [" + superInfo + "] could not be obtained.", superName);
		assertNotUndefined("The name of the PackageInfo [" + subPackageInfo + "] could not be obtained.", packageName);
		
		assertEquals("The obtained name [" + subName + "] is not correct. It should be [SubClass].", subName, "SubClass");
		assertEquals("The obtained name [" + superName + "] is not correct. It should be [SuperClass].", superName, "SuperClass");
		assertEquals("The obtained name [" + packageName + "] is not correct. It should be [treflect].", packageName, "treflect");
	}
	
	public function testGetFullName(Void):Void {
		var subName:String = subInfo.getFullName();
		var superName:String = superInfo.getFullName();
		var packageName:String = subPackageInfo.getFullName();
		
		assertNotUndefined("The full name of the ClassInfo [" + subInfo + "] could not be obtained.", subName);
		assertNotUndefined("The full name of the ClassInfo [" + superInfo + "] could not be obtained.", superName);
		assertNotUndefined("The full name of the PackageInfo [" + subPackageInfo + "] could not be obtained.", packageName);
		
		assertEquals("The obtained full name [" + subName + "] is not correct. It should be [test.unit.org.as2lib.env.reflect.treflect.SubClass].", subName, "test.unit.org.as2lib.env.reflect.treflect.SubClass");
		assertEquals("The obtained full name [" + superName + "] is not correct. It should be [test.unit.org.as2lib.env.reflect.treflect.SuperClass].", superName, "test.unit.org.as2lib.env.reflect.treflect.SuperClass");
		assertEquals("The obtained full name [" + packageName + "] is not correct. It should be [test.unit.org.as2lib.env.reflect.treflect].", packageName, "test.unit.org.as2lib.env.reflect.treflect");
	}
	
	public function testNewInstance(Void):Void {
		var instance:SubClass = SubClass(subInfo.newInstance());
		
		assertNotUndefined("Could not obtain a new instance from the ClassInfo [" + subInfo + "].", instance);
		
		var tempSubInfo:ClassInfo = instance.getClass();
		assertEquals("The two ClassInfos [" + subInfo + " and " + tempSubInfo + "] obtained from different instances of the same class are not equal.", subInfo, tempSubInfo);
	}
}