import org.as2lib.core.BasicClass;
import org.as2lib.env.except.UnsupportedOperationException;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.TypeMemberInfo;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.PropertyJoinPoint extends BasicClass implements JoinPoint {
	private var info:PropertyInfo;
	private var thiz;
	
	public function PropertyJoinPoint(info:PropertyInfo, thiz) {
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
		throw new UnsupportedOperationException("The execute operation is not supported by PropertyJoinPoints [" + this + "].",
												this,
												arguments);
	}
	
	public function clone(Void):JoinPoint {
		var getter:Function;
		var setter:Function;
		if (info.isStatic()) {
			getter = info.getDeclaringType().getType()[info.getGetter().getName()];
			setter = info.getDeclaringType().getType()[info.getSetter().getName()];
		} else {
			getter = info.getDeclaringType().getType().prototype[info.getGetter().getName()];
			setter = info.getDeclaringType().getType().prototype[info.getSetter().getName()];
		}
		var newInfo:PropertyInfo = new PropertyInfo(info.getName(),
													setter,
													getter,
													info.getDeclaringType(),
													info.isStatic());
		return (new PropertyJoinPoint(newInfo, getThis()));
	}
}