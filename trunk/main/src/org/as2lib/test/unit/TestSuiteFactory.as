import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestSuite;
import org.as2lib.util.ClassUtil;
import org.as2lib.util.ObjectUtil;

class org.as2lib.test.unit.TestSuiteFactory extends BasicClass {
	
	public function TestSuiteFactory(Void) {}
	
	public static function collectAllTestCases(Void):TestSuite {
		return collectTestCases(_global, true);
	}
	
	public static function collectTestCases(rootObject, recursive:Boolean):TestSuite {
		var result:TestSuite = new TestSuite("<Generated TestSuite>");
		ObjectUtil.setAccessPermission(rootObject, null, ObjectUtil.ACCESS_ALL_ALLOWED);
		collectAgent(rootObject, result, recursive);
		return result;
	}

	private static function collectAgent(package, result:TestSuite, recursive:Boolean):Void {
		var i:String;
		for(i in package) {
			var child = package[i];
			if(typeof child == "function" && ClassUtil.isSubClassOf(child, TestCase)) {
				result.addTest(new child());
			}
			if(typeof child == "object" && recursive) {
				collectAgent(child, result, recursive);
			}
		}
	}
}