import org.as2lib.aop.joinpoint.AbstractJoinPoint;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.TypeMemberInfo;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.MethodJoinPoint extends AbstractJoinPoint implements JoinPoint {
	private var info:MethodInfo;
	private var thiz;
	
	public function MethodJoinPoint(info:MethodInfo, thiz) {
		this.info = info;
		this.thiz = thiz;
	}
	
	public function getInfo(Void):TypeMemberInfo {
		return info;
	}
	
	public function getThis(Void) {
		return thiz;
	}
	
	public function proceed(args:Array) {
		return MethodInfo(getInfo()).getMethod().apply(getThis(), args);
	}
	
	public function clone(Void):JoinPoint {
		var method:Function;
		if (info.isStatic()) {
			method = info.getDeclaringType().getType()[info.getName()];
		} else {
			method = info.getDeclaringType().getType().prototype[info.getName()];
		}
		var newInfo:MethodInfo = new MethodInfo(info.getName(),
												method,
												info.getDeclaringType(),
												info.isStatic());
		return (new MethodJoinPoint(newInfo, getThis()));
	}
	
	public function getType(Void):Number {
		return TYPE_METHOD;
	}
}