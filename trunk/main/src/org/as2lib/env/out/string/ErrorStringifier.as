import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.env.util.ExceptUtil;

/**
 * ErrorStringifier is the default Stringifier used by the OutUtil#stringifyErrorInfo()
 * operation.
 * 
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 * @see org.as2lib.core.string.Stringifier
 */
class org.as2lib.env.out.string.ErrorStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.core.string.Stringifier
	 */
	public function execute(target):String {
		return "** "+ReflectUtil.getClassInfo(OutErrorInfo(target).getLevel()).getName()+" ** \n" + ExceptUtil.stringify(OutErrorInfo(target).getThrowable());
	}
}