import org.as2lib.tool.console.ConsoleView;
import org.as2lib.tool.console.ConsoleConnection;
import org.as2lib.core.BasicClass;
import org.as2lib.env.out.OutHandler;
import org.as2lib.env.out.OutInfo;
import org.as2lib.env.out.Out;

class org.as2lib.tool.console.out.OutView extends BasicClass implements ConsoleView, OutHandler {
	private var out:Out;
	public function show(Void):Void {
	}
	public function hide(Void):Void {
	}
	public function changeConnection(conn:ConsoleConnection):Void {
		out = Out(conn.getOut());
		out.addHandler(this);
	}
	public function write(info:OutInfo):Void {
		trace(info.toString());
	}
	public function getName(Void):String {
		return "OutView";
	}
}