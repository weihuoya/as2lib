import org.as2lib.basic.BasicClass;
import org.as2lib.basic.reflect.ReflectInfo;
import org.as2lib.basic.reflect.PackageInfo;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.basic.reflect.Cache;
import org.as2lib.basic.reflect.algorythm.ContentAlgorythm;
import org.as2lib.data.Hashtable;
import org.as2lib.util.ObjectUtil;

class org.as2lib.basic.reflect.algorythm.ChildrenAlgorythm extends BasicClass implements ContentAlgorythm {
	private var cache:Cache;
	
	public function ChildrenAlgorythm(cache:Cache) {
		this.cache = cache;
	}
	
	public function execute(info:ReflectInfo):Hashtable {
		var result:Hashtable = new Hashtable();
		var object:Object = PackageInfo(info).getPackage();
		var package:PackageInfo;
		var clazz:ClassInfo;
		var i:String;
		for (i in object) {
			if (ObjectUtil.isTypeOf(object[i], "function")) {
				clazz = cache.getClass(object[i]);
				if (ObjectUtil.isEmpty(clazz)) {
					clazz = new ClassInfo(i, object[i], PackageInfo(info));
					cache.addClass(clazz);
				}
				result.set(i, clazz);
			} else if (ObjectUtil.isTypeOf(object[i], "object")) {
				package = cache.getPackage(object[i]);
				if (ObjectUtil.isEmpty(package)) {
					package = new PackageInfo(i, object[i], PackageInfo(info));
					cache.addPackage(package);
				}
				result.set(i, package);
			}
		}
		return result;
	}
}