import org.as2lib.core.BasicClass;
import org.as2lib.env.out.OutAccess;
import org.as2lib.env.out.Out;

class org.as2lib.tool.console.ConsoleConnection extends BasicClass {
	private static var out:OutAccess;
	public function getOut(Void):OutAccess {
		if(!out) {
			out = new Out();
		}
		return out;
	}
}