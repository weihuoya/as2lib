import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.out.OutLevel;

/**
 * WriteStringifier is the default Stringifier used by the OutUtil.stringifyWriteInfo()
 * operation.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.out.string.WriteStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.core.string.Stringifier
	 */
	public function execute(target):String {
		var info:OutWriteInfo = OutWriteInfo(target);
		return ("** " + getLevelName(info.getLevel()) + " ** \n" 
				+ info.getMessage());
	}
	
	private function getLevelName(level:OutLevel):String {
		return ReflectUtil.getClassInfo(level).getName();
	}
}