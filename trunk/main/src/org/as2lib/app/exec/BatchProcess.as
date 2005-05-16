
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.event.distributor.SimpleEventDistributorControl;
import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessListener;
import org.as2lib.app.exec.BatchListener;
import org.as2lib.core.BasicClass;

/**
 *
 *
 *
 *
 */
class org.as2lib.app.exec.BatchProcess extends BasicClass implements Batch, ProcessListener {
	
	/** Flag if execution was started */
	private var started:Boolean;
	
	/** Flag if execution was finished */
	private var finished:Boolean;
	
	/** Holder for the batch */
	private var batchEventControl:EventDistributorControl;
	
	/** */
	private var batchEvent:BatchListener;
	
	/** Holder for the batch */
	private var processEventControl:SimpleEventDistributorControl;
	
	/** */
	private var processEvent:ProcessListener;
	
	/** List that contains all processes **/
	private var list:Array;
	
	/** Holder for the percents already executed */
	private var percent:Number;
	
	/** Current running process */
	private var current:Number;
	
	private var parent:Process;
	
	public function BatchProcess(Void) {
		processEventControl = new SimpleEventDistributorControl(ProcessListener);
		processEvent = processEventControl.getDistributor();
		batchEventControl = new SimpleEventDistributorControl(BatchListener);
		batchEvent = batchEventControl.getDistributor();
		current = -1;
		list = new Array();
		
		percent = 0;
		started = false;
		finished = false;
	}
	
	public function setParentProcess(p:Process):Void {
		do {
			if(p == this) {
				throw new IllegalArgumentException("You can not start a process with itself as super process.", this, arguments);
			}
		} while (p = p.getParentProcess());
		
		parent = p;
	}
	
	public function getParentProcess(Void):Process {
		return parent;
	}
	
    public function getCurrentProcess(Void):Process {
		return list[current];
	}
	
	public function getAllAddedProcesses(Void):Array {
		return list.concat();
	}
	
	public function onFinishProcess(info:Process):Void {
		list[current].removeProcessListener(this);
		if(current < list.length) {
			updatePercent(100);
			var c:Process = list[current++];
			c.setParentProcess(this);
			c.addProcessListener(this);
			c.start();
		} else {
			finished = true;
			batchEvent.onStopBatch(this);
			processEvent.onFinishProcess(this);
			percent = -1;
		}
	}
	
	public function onStartProcess(info:Process):Void {}
	
	public function onPauseProcess(info:Process):Void {
		
	}
	
	public function onResumeProcess(info:Process):Void {
	}
	
	public function onUpdateProcess(info:Process):Void {
		var p:Number = info.getPercentage();
		if(p != null) {
			updatePercent(p);
		}
		batchEvent.onUpdateBatch(this);
		processEvent.onUpdateProcess(this);
	}
	
    public function start(Void):Void {
		current = 0;
		started = false;
		finished = false;
		percent = 0;
		
		batchEvent.onStartBatch(this);
		processEvent.onStartProcess(this);
		started = true;
		onFinishProcess();
	}
	
	public function addProcess(p:Process):Number {
		if(p != this) {
			list.push(p);
			updatePercent(100);
			return list.length-1;
		}
	}
	
	private function updatePercent(cP:Number):Void {
		percent = 100/list.length*(current+(1/100*cP));
	}
	
	public function removeProcess(p:Process):Void {
		var i:Number = list.length;
		while(--i-(-1)) {
			if(list[i] == p) {
				list.slice(i, i);
				return;
			}
		}
	}
	
	public function removeProcessById(id:Number):Void {
		list.splice(id, 1);
	}
	
    public function addProcessListener(listener:ProcessListener):Void {
		processEventControl.addListener(listener);
	}
	
	public function removeProcessListener(listener:ProcessListener):Void {
		processEventControl.removeListener(listener);
	}
	
	public function removeAllProcessListeners(Void):Void {
		processEventControl.removeAllListeners();
	}
	
	public function addAllProcessListeners(list:Array):Void {
		processEventControl.addAllListeners(list);
	}
	
	public function getAllProcessListeners(Void):Array {
		return processEventControl.getAllListeners();
	}
	
    public function addBatchListener(listener:BatchListener):Void {
		batchEventControl.addListener(listener);
	}
	
	public function removeBatchListener(listener:BatchListener):Void {
		batchEventControl.removeListener(listener);
	}
	
	public function removeAllBatchListeners(Void):Void {
		batchEventControl.removeAllListeners();
	}
	
	public function addAllBatchListeners(list:Array):Void {
		batchEventControl.addAllListeners(list);
	}
	
	public function getAllBatchListeners(Void):Array {
		return batchEventControl.getAllListeners();
	}
    public function getPercentage(Void):Number {
		return percent;
	}
    public function hasFinished(Void):Boolean {
		return finished;
	}
    public function hasStarted(Void):Boolean {
		return started;
	}
	public function isRunning(Void):Boolean {
		return true;
	}
	public function isPaused(Void):Boolean {
		return false;
	}
}