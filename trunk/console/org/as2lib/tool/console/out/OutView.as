import org.as2lib.tool.console.ConsoleView;
import org.as2lib.tool.console.ConsoleConnection;
import org.as2lib.core.BasicClass;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.ConfigurableLogger;

class org.as2lib.tool.console.out.OutView extends BasicClass implements ConsoleView, LogHandler {
	
	private var logger:ConfigurableLogger;
	
	public function show(Void):Void {
	}
	
	public function hide(Void):Void {
	}
	
	public function changeConnection(conn:ConsoleConnection):Void {
		logger = conn.getLogger();
		logger.addHandler(this);
	}
	
	public function write(info:LogMessage):Void {
		trace(info.toString());
	}
	
	public function getName(Void):String {
		return "OutView";
	}
	
}