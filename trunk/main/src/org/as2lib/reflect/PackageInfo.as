import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.HashMap;
import org.as2lib.reflect.ReflectInfo;
import org.as2lib.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;

class org.as2lib.reflect.PackageInfo extends BasicClass implements ReflectInfo {
	private var name:String;
	private var fullName:String;
	private var package:Object;
	private var parent:PackageInfo;
	private var children:HashMap;
	
	public function PackageInfo(name:String, 
							  	package, 
							  	parent:PackageInfo) {
		this.name = name;
		this.package = package;
		this.parent = parent;
	}
	
	public function getName(Void):String {
		return name;
	}
	
	public function getFullName(Void):String {
		if (ObjectUtil.isEmpty(fullName)) {
			if (getParent().isRoot()) {
				return (fullName = getName());
			}
			fullName = getParent().getFullName() + "." + getName();
		}
		return fullName;
	}
	
	public function getPackage(Void):Object {
		return package;
	}
	
	public function getParent(Void):PackageInfo {
		return parent;
	}
	
	public function getChildren(Void):HashMap {
		if (children == undefined) {
			children = ReflectUtil.getChildren(this);
		}
		return children;
	}
	
	public function isRoot(Void):Boolean {
		return false;
	}
}