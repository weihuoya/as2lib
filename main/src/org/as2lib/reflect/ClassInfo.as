import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.HashMap;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.ReflectUtil;
import org.as2lib.reflect.PackageInfo;
import org.as2lib.reflect.ReflectInfo;
import org.as2lib.Config;

class org.as2lib.reflect.ClassInfo extends BasicClass implements ReflectInfo {
	private var name:String;
	private var fullName:String;
	private var clazz:Function;
	private var superClass:ClassInfo;
	private var parent:PackageInfo;
	private var methods:HashMap;
	private var properties:HashMap;
	
	public function ClassInfo(name:String, 
							  clazz:Function, 
							  parent:PackageInfo) {
		this.name = name;
		this.clazz = clazz;
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
	
	public function getClass(Void):Function {
		return clazz;
	}
	
	public function getSuperClass(Void):ClassInfo {
		if (ObjectUtil.isEmpty(superClass)) {
			superClass = ReflectUtil.getClassInfo(clazz.prototype);
		}
		return superClass;
	}
	
	public function newInstance(Void) {
		return (new clazz());
	}
	
	public function getParent(Void):PackageInfo {
		return parent;
	}
	
	public function getMethods(Void):HashMap {
		if (ObjectUtil.isEmpty(methods)) {
			methods = ReflectUtil.getMethods(this);
		}
		return methods;
	}
	
	public function getProperties(Void):HashMap {
		if (ObjectUtil.isEmpty(properties)) {
			properties = ReflectUtil.getProperties(this);
		}
		return properties;
	}
	
	public function getChildren(Void):HashMap {
		return null;
	}
}