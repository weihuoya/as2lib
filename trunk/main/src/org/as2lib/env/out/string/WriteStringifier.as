import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.info.OutWriteInfo;

/**
 * WriteStringifier is the default Stringifier used by the OutUtil.stringifyWriteInfo()
 * operation.
 * 
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 * @see org.as2lib.core.string.Stringifier
 */
class org.as2lib.env.out.string.WriteStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.core.string.Stringifier
	 */
	public function execute(target):String {
		return "** "+ReflectUtil.getClassInfo(OutWriteInfo(target).getLevel()).getName()+" ** \n" + OutWriteInfo(target).getMessage();
	}
}