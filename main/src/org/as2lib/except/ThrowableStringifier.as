import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.except.Throwable;
import org.as2lib.util.ReflectUtil;
import org.as2lib.reflect.ClassInfo;

class org.as2lib.except.ThrowableStringifier extends BasicClass implements Stringifier {
	public function execute(target:Object):String {
		var info:ClassInfo = ReflectUtil.getClassInfo(target);
		var throwable:Throwable = Throwable(target);
		var thrower:Object = throwable.getThrower();
		return "Name: " + info.getName() + "\n"
			   + "Thrower: " + ReflectUtil.getClassInfo(thrower).getName();
	}
}