import org.as2lib.test.unit.Test;
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
 
class test.org.as2lib.core.TReflections extends Test {
	private var clazz:BasicClass;
	
	public function TReflections(Void) {
		DummieClass;
		AnotherDummie;
		clazz = new BasicClass();
	}
	
	public function testGetClass(Void):Void {
		trace (":: testGetClass");
		var info:ClassInfo = clazz.getClass();
		assertEqualsWithMessage("The name of the basic class changed", info.getName(), "BasicClass");
		assertEqualsWithMessage("Problems evaluating the full name", info.getFullName(), "org.as2lib.core.BasicClass");
		assertEqualsWithMessage("getRepresentedType() does not return the correct class", info.getRepresentedType(), BasicClass);
		assertEqualsWithMessage("The Root Package is not at the correct place", PackageInfo(info.getParent().getParent().getParent().getParent()).getPackage(), _global);
		assertEqualsWithMessage("For a Strange reason the parent package isn't core.", info.getParent().getName(), "core");
		trace ("----------------------------------------------");
	}
	
	public function testGetPackage(Void):Void {
		trace (":: testGetPackage");
		var info:PackageInfo = ReflectUtil.getPackageInfo(_global.org.as2lib);
		assertEqualsWithMessage("The name of the package isn't correct!", info.getName(), "as2lib");
		assertEqualsWithMessage("The full name of the package isn't correct!", info.getFullName(), "org.as2lib");
		assertEqualsWithMessage("getPackage() doesn't return the correct package.", info.getPackage(), org.as2lib);
		assertFalseWithMessage("isRoot() returns root but it is not the root package!", info.isRoot());
		assertEqualsWithMessage("The Parent doesn't match the it's real parent", info.getParent().getPackage(), org);
		trace ("----------------------------------------------");
	}
	
	public function testGetChildren(Void):Void {
		trace (":: testGetChildren");
		var info = ReflectUtil.getPackageInfo(_global.org.as2lib);
		var children:Map = info.getChildren();
		var iterator:Iterator = children.iterator();
		while (iterator.hasNext()) {
			var child:CompositeMemberInfo = CompositeMemberInfo(iterator.next());
			trace (child.getName());
		}
		assertTrueWithMessage("getChildren() does not return a Map", ObjectUtil.isInstanceOf(children, Map));
		trace ("----------------------------------------------");
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