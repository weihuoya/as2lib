import org.as2lib.core.BasicClass;
import org.as2lib.env.event.SpeedEventBroadcaster;
import org.as2lib.tool.console.ConsoleConnection;
import org.as2lib.tool.console.ConsoleView;

class org.as2lib.tool.console.ConsoleController extends BasicClass {
	private var view:ConsoleView;
	private var conn:ConsoleConnection;
	public function addView(view:ConsoleView) {
		this.view = view;
		this.view.changeConnection(conn);
	}
	public function setConnection(conn:ConsoleConnection) {
		this.conn = conn;
		this.view.changeConnection(conn);
	}
}