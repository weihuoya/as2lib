import org.as2lib.env.event.SimpleEventInfo;
import org.as2lib.app.exec.Process;

class org.as2lib.app.exec.ProcessInfo extends SimpleEventInfo {
	
	private var process:Process;
	
	public function ProcessInfo(name:String, process:Process) {
		super(name);
		this.process = process;
	}
	
	public function getProcess(Void):Process {
		return process;
	}
}