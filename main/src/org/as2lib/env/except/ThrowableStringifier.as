import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.except.ExceptConfig;

/**
 * ThrowableStringifier is used to stringify a Throwable.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 * @see org.as2lib.core.string.Stringifier
 */
class org.as2lib.env.except.ThrowableStringifier extends BasicClass implements Stringifier {
	/**
	 * TODO: Good documentation when the working on the stringify process has 
	 * been finished.
	 *
	 * @see org.as2lib.core.string.Stringifier#execute()
	 */
	public function execute(target):String {
		var throwable:Throwable = Throwable(target);
		var info:ClassInfo = ReflectUtil.getClassInfo(throwable);
		return (info.getFullName() + ": " + throwable.getMessage() + "\n"
				+ ExceptConfig.getStackTraceStringifier().execute(throwable.getStackTrace()));
	}
}