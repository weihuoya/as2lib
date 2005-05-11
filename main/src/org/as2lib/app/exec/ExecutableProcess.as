
import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.app.exec.Executable;

/**
 *
 *
 *
 *
 */
class org.as2lib.app.exec.ExecutableProcess extends AbstractProcess {
	private var args:Array;
	private var executable:Executable;
	
	public function ExecutableProcess(executable:Executable, args:Array) {
		super();
		this.executable = executable;
		this.args = args;
	}
	
	private function run() {
		executable.execute(args);
	}
}