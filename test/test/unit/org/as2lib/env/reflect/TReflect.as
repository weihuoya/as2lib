import org.as2lib.test.unit.Test;
import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.CacheInfo;
import test.org.as2lib.env.reflect.treflect.SubClass;
import test.org.as2lib.env.reflect.treflect.SuperClass;
import test.org.as2lib.env.reflect.treflect.package0.Package0Class;
import test.org.as2lib.env.reflect.treflect.package1.Package1Class;

class test.org.as2lib.env.reflect.TReflect extends Test {
	private var subClass:SubClass;
	private var superClass:SuperClass;
	
	private var subInfo:ClassInfo;
	private var superInfo:ClassInfo;
	
	private var package;
	private var subPackageInfo:PackageInfo;
	private var superPackageInfo:PackageInfo;
	
	private var children:Map;
	private var methods:Map;
	private var properties:Map;
	
	public function TReflect(Void) {
		subClass = new SubClass();
		superClass = new SuperClass();
		
		subInfo = subClass.getClass();
		superInfo = superClass.getClass();
		
		package = _global.test.org.as2lib.env.reflect.treflect;
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
		
		var childrenArray:Array = new Array();
		var iterator:Iterator = children.iterator();
		while (iterator.hasNext()) {
			childrenArray.push(iterator.next());
		}
		
		var amount:Number = childrenArray.length;
		assertEquals("The amount of children found [" + amount + "] does not match the actual amount [4] of children.", childrenArray.length, 4);
	}
	
	public function testGetMethods(Void):Void {
		assertNotUndefined("Could not obtain methods from ClassInfo [" + subInfo + "].", methods);
		
		var methdosArray:Array = new Array();
		var iterator:Iterator = methods.iterator();
		while (iterator.hasNext()) {
			methdosArray.push(iterator.next());
		}
		
		var amount:Number = methdosArray.length;
		assertEquals("The amount of methods found [" + amount + "] does not match the actual amount [4] of methods.", methdosArray.length, 4);
	}
	
	public function testGetProperties(Void):Void {
		assertNotUndefined("Could not obtain methods from ClassInfo [" + subInfo + "].", properties);
		
		var propertiesArray:Array = new Array();
		var iterator:Iterator = properties.iterator();
		while (iterator.hasNext()) {
			propertiesArray.push(iterator.next());
		}
		
		var amount:Number = propertiesArray.length;
		assertEquals("The amount of properties found [" + amount + "] does not match the actual amount [3] of properties.", propertiesArray.length, 3);
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
		
		assertEquals("The obtained full name [" + subName + "] is not correct. It should be [test.org.as2lib.env.reflect.treflect.SubClass].", subName, "test.org.as2lib.env.reflect.treflect.SubClass");
		assertEquals("The obtained full name [" + superName + "] is not correct. It should be [test.org.as2lib.env.reflect.treflect.SuperClass].", superName, "test.org.as2lib.env.reflect.treflect.SuperClass");
		assertEquals("The obtained full name [" + packageName + "] is not correct. It should be [test.org.as2lib.env.reflect.treflect].", packageName, "test.org.as2lib.env.reflect.treflect");
	}
	
	public function testNewInstance(Void):Void {
		var instance:SubClass = SubClass(subInfo.newInstance());
		
		assertNotUndefined("Could not obtain a new instance from the ClassInfo [" + subInfo + "].", instance);
		
		var tempSubInfo:ClassInfo = instance.getClass();
		assertEquals("The two ClassInfos [" + subInfo + " and " + tempSubInfo + "] obtained from different instances of the same class are not equal.", subInfo, tempSubInfo);
	}
}