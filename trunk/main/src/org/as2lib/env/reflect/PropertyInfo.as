import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.util.ObjectUtil;

class org.as2lib.env.reflect.PropertyInfo extends BasicClass {
	private var name:String;
	private var setter:Function;
	private var getter:Function;
	private var declaringClass:ClassInfo;
	private var staticFlag:Boolean;
	
	public function PropertyInfo(name:String,
								 setter:Function,
								 getter:Function,
								 declaringClass:ClassInfo,
								 staticFlag:Boolean) {
		this.name = name;
		this.setter = setter;
		this.getter = getter;
		this.declaringClass = declaringClass;
		this.staticFlag = staticFlag;
	}
	
	public function getName(Void):String {
		return name;
	}
	
	public function getSetter(Void):Function {
		return setter;
	}
	
	public function getGetter(Void):Function {
		return getter;
	}
	
	public function getDeclaringClass(Void):ClassInfo {
		return declaringClass;
	}
	
	public function isWriteable(Void):Boolean {
		return ObjectUtil.isAvailable(setter);
	}
	
	public function isReadable(Void):Boolean {
		return ObjectUtil.isAvailable(getter);
	}
	
	public function isStatic(Void):Boolean {
		return staticFlag;
	}
}