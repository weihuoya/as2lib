import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ClassInfo;

class org.as2lib.env.except.ThrowableStringifier extends BasicClass implements Stringifier {
	public function execute(target):String {
		var info:ClassInfo = ReflectUtil.getClassInfo(target);
		var throwable:Throwable = Throwable(target);
		var thrower = throwable.getThrower();
		return "Name: " + info.getName() + "\n"
			   + "Thrower: " + ReflectUtil.getClassInfo(thrower).getName();
	}
}