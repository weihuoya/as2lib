import org.as2lib.test.unit.Test;
import org.as2lib.basic.BasicClass;
import org.as2lib.reflect.ClassInfo;
import org.as2lib.reflect.PackageInfo;
import org.as2lib.reflect.MethodInfo;
import org.as2lib.reflect.PropertyInfo;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.reflect.ReflectInfo;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.ReflectUtil;
import test.org.as2lib.reflect.*;
import org.as2lib.basic.Out;
import org.as2lib.Config;
import test.org.as2lib.basic.reflect.DummieClass;
import test.org.as2lib.basic.reflect.AnotherDummie

/**
 * Testcase for Reflections.
 * @author Martin Heidegger
 */
 
class test.org.as2lib.basic.TReflections extends Test {
	private var clazz:BasicClass;
	
	public function TReflections(Void) {
		DummieClass;
		AnotherDummie;
		clazz = new BasicClass();
	}
	
	public function testGetClass(Void):Void {
		var info:ClassInfo = clazz.getClass();
		assertEqualsWithMessage("The name of the basic class changed", info.getName(), "BasicClass");
		assertEqualsWithMessage("Problems evaluating the full name", info.getFullName(), "org.as2lib.basic.BasicClass");
		assertEqualsWithMessage("getClass() does not return the correct class", info.getClass(), BasicClass);
		assertEqualsWithMessage("The Root Package is not at the correct place", PackageInfo(info.getParent().getParent().getParent().getParent()).getPackage(), _global);		assertEqualsWithMessage("For a Strange reason the parent package isn't basic.", info.getParent().getName(), "basic");
		trace ("----------------------------------------------");
	}
	
	public function testGetPackage(Void):Void {
		var info:PackageInfo = ReflectUtil.getPackageInfo(_global.org.as2lib);
		assertEqualsWithMessage("The name of the package isn't correct!", info.getName(), "as2lib");
		assertEqualsWithMessage("The full name of the package isn't correct!", info.getFullName(), "org.as2lib");
		assertEqualsWithMessage("getPackage() doesn't return the correct package.", info.getPackage(), org.as2lib);
		assertFalseWithMessage("isRoot() returns root but it is not the root package!", info.isRoot());
		assertEqualsWithMessage("The Parent doesn't match the it's real parent", info.getParent().getPackage(), org);
		trace ("----------------------------------------------");
	}
	
	public function testGetChildren(Void):Void {
		var info = ReflectUtil.getPackageInfo(_global.test.org.as2lib.reflect);
		var children:HashMap = info.getChildren();
		var iterator:Iterator = children.iterator();
		while (iterator.hasNext()) {
			var child:ReflectInfo = ReflectInfo(iterator.next());
			trace (child.getName());
		}
		assertTrueWithMessage("getChildren() does not return a HashMap", ObjectUtil.isInstanceOf(children, HashMap));
		trace ("----------------------------------------------");
	}
	
	public function testGetMethods(Void):Void {
		var info:ClassInfo = clazz.getClass();
		var methods:HashMap = info.getMethods();
		var iterator:Iterator = methods.iterator()
		while(iterator.hasNext()) {
			var method:MethodInfo = MethodInfo(iterator.next());
			trace (method.getName() + " :method");
		}
		trace ("----------------------------------------------");
	}
	
	public function testGetProperties(Void):Void {
		var info:ClassInfo = (new DummieClass()).getClass();
		var properties:HashMap = HashMap(info.getProperties());
		var prop:PropertyInfo;
		var iterator:Iterator = properties.iterator();
		while (iterator.hasNext()) {
			prop = PropertyInfo(iterator.next());
			trace (prop.getName());
			trace (prop.isWriteable() + " write");
			trace (prop.isReadable() + " read");
			trace (prop.isStatic() +  " static");
			trace ("****");
		}
		trace ("----------------------------------------------");
	}
}