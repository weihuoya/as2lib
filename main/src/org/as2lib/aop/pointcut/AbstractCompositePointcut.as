import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.SimpleStack;
import org.as2lib.aop.Pointcut;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.AbstractCompositePointcut extends BasicClass {
	private var pointcutStack:Stack;
	
	private function AbstractCompositePointcut(Void) {
		pointcutStack = new SimpleStack();
	}
	
	public function addPointcut(pointcut:Pointcut):Void {
		pointcutStack.push(pointcut);
	}
}