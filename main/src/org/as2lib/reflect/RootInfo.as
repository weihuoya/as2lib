import org.as2lib.reflect.ReflectInfo;
import org.as2lib.reflect.PackageInfo;
import org.as2lib.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;

class org.as2lib.reflect.RootInfo extends PackageInfo implements ReflectInfo {
	public function RootInfo(name:String, 
							 package:Object) {
		super(name, package, undefined);
	}
	
	public function getFullName(Void):String {
		return name;
	}
	
	public function isRoot(Void):Boolean {
		return true;
	}
}