import org.as2lib.core.BasicInterface;
import org.as2lib.data.holder.Stack;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.aspect.TypeFactory extends BasicInterface {
	public function getTypes(types:String):Stack;
}