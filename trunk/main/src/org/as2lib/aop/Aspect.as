import org.as2lib.core.BasicInterface;
import org.as2lib.aop.Advice;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.Aspect extends BasicInterface {
	public function weave(Void):Void;
	public function addAffectedTypes(type:String):Void;
}