import org.as2lib.aop.Pointcut;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.pointcut.CompositePointcut extends Pointcut {
	public function addPointcut(pointcut:Pointcut):Void;
}