import org.as2lib.basic.BasicClass;
import org.as2lib.basic.string.Stringifier;
import org.as2lib.basic.exept.Throwable;
import org.as2lib.util.ReflectUtil;
import org.as2lib.basic.reflect.ClassInfo;

class org.as2lib.basic.except.ThrowableStringifier extends BasicClass implements Stringifier {
	public function execute(target:Object):String {
		var info:ClassInfo = ReflectUtil.getClassInfo(target);
		var throwable:Throwable = Throwable(target);
		var thrower:Object = throwable.getThrower();
		return "Name: " + info.getName() + "\n"
			   + "Thrower: " + ReflectUtil.getClassInfo(thrower).getName();
	}
}