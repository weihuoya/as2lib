import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.data.holder.HashMap;

interface org.as2lib.env.reflect.ReflectInfo {
	public function getName(Void):String;
	public function getFullName(Void):String;
	public function getParent(Void):PackageInfo;
	public function getChildren(Void):HashMap;
}