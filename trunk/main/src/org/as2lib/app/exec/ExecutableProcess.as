import org.as2lib.env.event.broadcaster.EventBroadcaster;
import org.as2lib.env.event.broadcaster.SpeedEventBroadcaster;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessInfo;
import org.as2lib.app.exec.ProcessListener;
import org.as2lib.util.Executable;
import org.as2lib.core.BasicClass;

/**
 *
 *
 *
 *
 */
class org.as2lib.app.exec.ExecutableProcess extends BasicClass implements Process {
	/** Arguments of the Executable */
	private var argx:Array;
	
	/** Flag if execution was started */
	private var started:Boolean;
	
	/** Flag if execution was finished */
	private var finished:Boolean;
	
	/** Executable holder */
	private var executable:Executable;
	
	/** EventBroadcaster holder */
	private var eventB:EventBroadcaster;
	
	public function ExecutableProcess(executable:Executable, args:Array) {
		eventB = new SpeedEventBroadcaster();
		this.executable = executable;
		this.argx = args;
		started = false;
		finished = false;
	}
	
    public function start(Void):Void {
		started = false;
		finished = false;
		eventB.dispatch(new ProcessInfo("onStartProcess", this));
		started = true;
		executable.execute(argx);
		finished = true;
		eventB.dispatch(new ProcessInfo("onStopProcess", this));
	}
	
    public function addProcessListener(listener:ProcessListener):Void {
		eventB.addListener(listener);
	}
	
	public function removeProcessListener(listener:ProcessListener):Void {
		eventB.removeListener(listener);
	}
	
	public function removeAllProcessListener(Void):Void {
		eventB.removeAllListener();
	}
	
	public function addAllProcessListener(list:Array):Void {
		eventB.addAllListener(list);
	}
	
	public function getAllProcessListener(Void):Array {
		return eventB.getAllListener();
	}
    public function getPercent(Void):Number {
		return null;
	}
    public function hasFinished(Void):Boolean {
		return finished;
	}
    public function hasStarted(Void):Boolean {
		return started;
	}
}