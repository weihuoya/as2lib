import org.as2lib.basic.BasicClass;
import org.as2lib.basic.reflect.ClassInfo;

class org.as2lib.basic.reflect.MethodInfo extends BasicClass {
	private var name:String;
	private var method:Function;
	private var declaringClass:ClassInfo;
	private var staticFlag:Boolean;
	
	public function MethodInfo(name:String,
							   method:Function,
							   declaringClass:ClassInfo,
							   staticFlag:Boolean) {
		this.name = name;
		this.method = method;
		this.declaringClass = declaringClass;
		this.staticFlag = staticFlag;
	}
	
	public function getName(Void):String {
		return name;
	}
	
	public function getMethod(Void):Function {
		return method;
	}
	
	public function getDeclaringClass(Void):ClassInfo {
		return declaringClass;
	}
	
	public function isStatic(Void):Boolean {
		return staticFlag;
	}
}