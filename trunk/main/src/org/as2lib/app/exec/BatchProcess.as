import org.as2lib.env.event.broadcaster.EventBroadcaster;
import org.as2lib.env.event.broadcaster.SpeedEventBroadcaster;
import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessInfo;
import org.as2lib.app.exec.BatchInfo;
import org.as2lib.app.exec.ProcessListener;
import org.as2lib.app.exec.BatchListener;
import org.as2lib.util.Executable;
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
	
	/** ProcessBroadcaster holder */
	private var pB:EventBroadcaster;
	
	/** BatchBroadcaster holder */
	private var bB:EventBroadcaster;
	
	/** Process info for updates */
	private var processUpdateInfo:ProcessInfo;
	
	/** Batch info for updates */
	private var batchUpdateInfo:BatchInfo;
	
	/** List that contains all processes **/
	private var list:Array;
	
	/** Holder for the percents already executed */
	private var percent:Number;
	
	/** Current running process */
	private var current:Number;
	
	public function BatchProcess(Void) {
		pB = new SpeedEventBroadcaster();
		bB = new SpeedEventBroadcaster();
		current = -1;
		list = new Array();
		processUpdateInfo = new ProcessInfo("onUpdateProcess", this);
		batchUpdateInfo = new BatchInfo("onUpdateBatch", this);
		
		percent = 0;
		started = false;
		finished = false;
	}
	
    public function getCurrentProcess(Void):Process {
		return list[current];
	}
	
	public function onStopProcess(info:ProcessInfo):Void {
		list[current].removeProcessListener(this);
		if(current < list.length) {
			updatePercent(100);
			var c:Process = list[current++];
			c.addProcessListener(this);
			c.start();
		} else {
			finished = true;
			bB.dispatch(new BatchInfo("onStopBatch", this));
			pB.dispatch(new ProcessInfo("onStopProcess", this));
			percent = -1;
		}
	}
	
	public function onStartProcess(info:ProcessInfo):Void {}
	
	public function onUpdateProcess(info:ProcessInfo):Void {
		var p:Number = info.getProcess().getPercent();
		if(p != null) {
			updatePercent(p);
		}
		bB.dispatch(batchUpdateInfo);
		pB.dispatch(processUpdateInfo);
	}
	
    public function start(Void):Void {
		current = 0;
		started = false;
		finished = false;
		percent = 0;
		
		bB.dispatch(new BatchInfo("onStartBatch", this));
		pB.dispatch(new ProcessInfo("onStartProcess", this));
		started = true;
		onStopProcess();
	}
	
	public function addProcess(p:Process):Void {
		list.push(p);
		updatePercent(100);
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
	
    public function addProcessListener(listener:ProcessListener):Void {
		pB.addListener(listener);
	}
	
	public function removeProcessListener(listener:ProcessListener):Void {
		pB.removeListener(listener);
	}
	
	public function removeAllProcessListener(Void):Void {
		pB.removeAllListener();
	}
	
	public function addAllProcessListener(list:Array):Void {
		pB.addAllListener(list);
	}
	
	public function getAllProcessListener(Void):Array {
		return pB.getAllListener();
	}
	
    public function addBatchListener(listener:BatchListener):Void {
		bB.addListener(listener);
	}
	
	public function removeBatchListener(listener:BatchListener):Void {
		bB.removeListener(listener);
	}
	
	public function removeAllBatchListener(Void):Void {
		bB.removeAllListener();
	}
	
	public function addAllBatchListener(list:Array):Void {
		bB.addAllListener(list);
	}
	
	public function getAllBatchListener(Void):Array {
		return bB.getAllListener();
	}
    public function getPercent(Void):Number {
		return percent;
	}
    public function isFinished(Void):Boolean {
		return finished;
	}
    public function isStarted(Void):Boolean {
		return started;
	}
}