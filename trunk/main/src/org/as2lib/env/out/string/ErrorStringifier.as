import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.env.util.ExceptUtil;

/**
 * ErrorStringifier is the default Stringifier used by the
 * OutUtil.stringifyErrorInfo(OutErrorInfo) operation.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.out.string.ErrorStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.core.string.Stringifier
	 */
	public function execute(target):String {
		return "** "+OutErrorInfo(target).getLevel().getClass().getName()+" **" + ExceptUtil.stringify(OutErrorInfo(target).getThrowable());
	}
}