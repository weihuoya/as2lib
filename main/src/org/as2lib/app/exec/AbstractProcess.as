import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.event.distributor.SimpleEventDistributorControl;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessListener;
import org.as2lib.util.ArrayUtil;

class org.as2lib.app.exec.AbstractProcess implements Process, ProcessListener {
	
	/** Flag if execution was paused */
	private var paused:Boolean;
	
	/** Flag if execution was started */
	private var started:Boolean;
	
	/** Flag if execution was finished */
	private var finished:Boolean;
	
	/** Distributor holder */
	private var distributor:EventDistributorControl;
	
	/** Event holder */
	private var event:ProcessListener;
	
	/** Processed that had been started during execution - means processes where its the listener */
	private var subProcesses:Array;
	
	public function AbstractProcess(Void) {
		distributor = new SimpleEventDistributorControl(ProcessListener);
		event = distributor.getDistributor();
		started = false;
		paused = false;
		finished = false;
	}
	
	public function startSubProcess(process:Process, args:Array):Void {
		if(!ArrayUtil.contains(subProcesses, process)) {
			subProcesses.push(process);
			process.addProcessListener(this);
			process["start"].apply(process, args);
		}
	}
	
	private function prepare(Void):Void {
		started = false;
		paused = false;
		finished = false;
		event.onStartProcess(this);
		started = true;
	}
	
    public function start() {
    	prepare();
		var result = run.apply(this, arguments);
		finish();
		return result;
	}
	
	private function run(Void):Void {
		throw new AbstractOperationException(".run has to be implemented.", this, arguments);
	}
	
	/**
	 * @return true if the process has finished. (false if the process hasn't started yet)
	 */
	public function hasFinished(Void):Boolean {
		return finished;
	}
	
	/**
	 * @return true if the process is paused.
	 */
	public function isPaused(Void):Boolean {
		return paused;
	}
	
	/**
	 * @return true if the process has started.
	 */
	public function hasStarted(Void):Boolean {
		return started;
	}
	
	/**
	 * @return true if the process is running.
	 */
	public function isRunning(Void):Boolean {
		return(!isPaused() && hasStarted());
	}
	
    public function addProcessListener(listener:ProcessListener):Void {
		distributor.addListener(listener);
	}
	
	public function removeProcessListener(listener:ProcessListener):Void {
		distributor.removeListener(listener);
	}
	
	public function removeAllProcessListeners(Void):Void {
		distributor.removeAllListeners();
	}
	
	public function addAllProcessListeners(list:Array):Void {
		distributor.addAllListeners(list);
	}
	
	public function getAllProcessListeners(Void):Array {
		return distributor.getAllListeners();
	}
    public function getPercentage(Void):Number {
		return null;
	}
	
	public function onUpdateProcess(process:Process):Void {
	}
	public function onStartProcess(process:Process):Void {
	}
	public function onFinishProcess(process:Process):Void {
	}
	public function onResumeProcess(process:Process):Void {
	}
	public function onPauseProcess(process:Process):Void {
	}
	
	/**
	 * Internal Method to finish the execution.
	 */
	private function finish(Void):Void {
		finished = true;
		started = false;
		paused = false;
		event.onFinishProcess(this);
	}
}