import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.env.out.OutLevel;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.except.ExceptConfig;

/**
 * ErrorStringifier is the default Stringifier used by the OutUtil#stringifyErrorInfo()
 * operation.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.out.string.ErrorStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.core.string.Stringifier
	 */
	public function execute(target):String {
		var info:OutErrorInfo = OutErrorInfo(target);
		return ("** " + getLevelName(info.getLevel()) + " ** \n" 
				+ getThrowableString(info.getThrowable()));
	}
	
	private function getLevelName(level:OutLevel):String {
		return ReflectUtil.getClassInfo(level).getName();
	}
	
	private function getThrowableString(throwable:Throwable):String {
		return ExceptConfig.getThrowableStringifier().execute(throwable);
	}
}