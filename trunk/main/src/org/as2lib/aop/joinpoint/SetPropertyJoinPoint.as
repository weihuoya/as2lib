import org.as2lib.aop.joinpoint.PropertyJoinPoint;
import org.as2lib.env.reflect.PropertyInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.SetPropertyJoinPoint extends PropertyJoinPoint {
	public function PropertyJoinPoint(info:PropertyInfo, thiz) {
		super(info, thiz);
	}
	
	public function execute(args:Array) {
		return PropertyInfo(getInfo()).getSetter().getMethod().apply(getThis(), args);
	}
	
	public function getType(Void):Number {
		return TYPE_PROPERTY_SET;
	}
}