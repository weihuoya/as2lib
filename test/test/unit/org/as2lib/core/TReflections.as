import org.as2lib.test.unit.TestCase;
import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.env.reflect.CompositeMemberInfo;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.util.ReflectUtil;
import test.org.as2lib.env.reflect.*;
import org.as2lib.env.EnvConfig;
import test.org.as2lib.core.reflect.DummieClass;
import test.org.as2lib.core.reflect.AnotherDummie

/**
 * Testcase for Reflections.
 * @author Martin Heidegger
 */
 
class test.org.as2lib.core.TReflections extends TestCase {
	private var clazz:BasicClass;
	
	public function TReflections(Void) {
		DummieClass;
		AnotherDummie;
	}
	
	public function setUp(Void):Void {
		clazz = new BasicClass();
	}
	
	public function testGetClass(Void):Void {
		var info:ClassInfo = clazz.getClass();
		assertEquals("The name of the basic class changed", info.getName(), "BasicClass");
		assertEquals("Problems evaluating the full name", info.getFullName(), "org.as2lib.core.BasicClass");
		assertEquals("getType() does not return the correct class", info.getType(), BasicClass);
		assertEquals("The Root Package is not at the correct place", PackageInfo(info.getParent().getParent().getParent().getParent()).getPackage(), _global);
		assertEquals("For a Strange reason the parent package isn't core.", info.getParent().getName(), "core");
	}
	
	public function testGetPackage(Void):Void {
		var info:PackageInfo = ReflectUtil.getPackageInfo(_global.org.as2lib);
		assertEquals("The name of the package isn't correct!", info.getName(), "as2lib");
		assertEquals("The full name of the package isn't correct!", info.getFullName(), "org.as2lib");
		assertEquals("getPackage() doesn't return the correct package.", info.getPackage(), org.as2lib);
		assertFalse("isRoot() returns root but it is not the root package!", info.isRoot());
		assertEquals("The Parent doesn't match the it's real parent", info.getParent().getPackage(), org);
	}
	
	public function testGetChildren(Void):Void {
		var info = ReflectUtil.getPackageInfo(_global.org.as2lib);
		var children:Map = info.getChildren();
		var iterator:Iterator = children.iterator();
		while (iterator.hasNext()) {
			var child:CompositeMemberInfo = CompositeMemberInfo(iterator.next());
			//trace (child.getName());
		}
		assertTrue("getChildren() does not return a Map", ObjectUtil.isInstanceOf(children, Map));
	}
	
	public function testGetMethods(Void):Void {
		trace (":: testGetMethods");
		var info:ClassInfo = clazz.getClass();
		var methods:Map = info.getMethods();
		var iterator:Iterator = methods.iterator()
		while(iterator.hasNext()) {
			var method:MethodInfo = MethodInfo(iterator.next());
			trace (method.getName() + " :method");
		}
		trace ("----------------------------------------------");
	}
	
	public function testGetProperties(Void):Void {
		trace (":: testGetProperties");
		var info:ClassInfo = (new DummieClass()).getClass();
		var properties:Map = Map(info.getProperties());
		var prop:PropertyInfo;
		var iterator:Iterator = properties.iterator();
		while (iterator.hasNext()) {
			prop = PropertyInfo(iterator.next());
			trace (prop.getName());
			trace (prop.isWritable() + " write");
			trace (prop.isReadable() + " read");
			trace (prop.isStatic() +  " static");
			trace ("****");
		}
		trace ("----------------------------------------------");
	}
}