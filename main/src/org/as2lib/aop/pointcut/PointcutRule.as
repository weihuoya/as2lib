import org.as2lib.core.BasicInterface;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.pointcut.PointcutRule extends BasicInterface {
	public function execute(pattern:String):Boolean;
}