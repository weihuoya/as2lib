import org.as2lib.basic.BasicClass;
import org.as2lib.data.Hashtable;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.ReflectUtil;
import org.as2lib.basic.reflect.PackageInfo;
import org.as2lib.basic.reflect.ReflectInfo;
import org.as2lib.Config;

class org.as2lib.basic.reflect.ClassInfo extends BasicClass implements ReflectInfo {
	private var name:String;
	private var fullName:String;
	private var clazz:Function;
	private var superClass:ClassInfo;
	private var parent:PackageInfo;
	private var methods:Hashtable;
	private var properties:Hashtable;
	
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
	
	public function newInstance(Void):Object {
		return (new clazz());
	}
	
	public function getParent(Void):PackageInfo {
		return parent;
	}
	
	public function getMethods(Void):Hashtable {
		if (ObjectUtil.isEmpty(methods)) {
			methods = ReflectUtil.getMethods(this);
		}
		return methods;
	}
	
	public function getProperties(Void):Hashtable {
		if (ObjectUtil.isEmpty(properties)) {
			properties = ReflectUtil.getProperties(this);
		}
		return properties;
	}
	
	public function getChildren(Void):Hashtable {
		return null;
	}
}