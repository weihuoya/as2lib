import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;

class org.as2lib.env.reflect.RootInfo extends PackageInfo implements CacheInfo {
	public function RootInfo(name:String, 
							 package) {
		super(name, package, undefined);
	}
	
	public function getFullName(Void):String {
		return name;
	}
	
	public function isRoot(Void):Boolean {
		return true;
	}
}