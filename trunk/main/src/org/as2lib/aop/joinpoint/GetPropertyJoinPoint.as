import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.aop.joinpoint.PropertyJoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.GetPropertyJoinPoint extends PropertyJoinPoint {
	public function PropertyJoinPoint(info:PropertyInfo, thiz) {
		super(info, thiz);
	}
	
	public function proceed(args:Array) {
		return PropertyInfo(getInfo()).getGetter().getMethod().apply(getThis(), args);
	}
	
	public function getType(Void):Number {
		return TYPE_GET_PROPERTY;
	}
}