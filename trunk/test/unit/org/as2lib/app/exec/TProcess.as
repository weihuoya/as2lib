import org.as2lib.test.unit.TestCase;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.TProcessListener;
import org.as2lib.app.exec.Call;

class org.as2lib.app.exec.TProcess extends TestCase {
	
	public function createProcess(Void):Process {
		return null;
	}
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	public function testStart(Void):Void {
		var process:Process = createProcess();
		var processListener:TProcessListener = new TProcessListener(process, this);
		
		process.addListener(processListener);
		startProcess(process, [], new Call(processListener, processListener.verify));
	}
}