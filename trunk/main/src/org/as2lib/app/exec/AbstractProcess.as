/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.event.distributor.SimpleEventDistributorControl;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessListener;
import org.as2lib.app.exec.Executable;
import org.as2lib.util.ArrayUtil;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;

/**
 * {@code AbstractProcess} is a abstract helper class to implement processes.
 * 
 * <p>Most of the functionalities of {@link Process} are served well within {@code AbstractProcess}.
 * because the usual implementation of process means to run something.
 * 
 * <p>To use the advantage of {@code AbstractProcess} simple extend it and implement the
 * {@link #run} method.
 * 
 * @author Martin Heidegger
 * @version 1.0
 * @see Process;
 */
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
	
	/** Processed that had been started during execution */
	private var subProcesses:Array;
	
	/** Callbacks set to the processes to be called after execution */
	private var callBacks:Map;
	
	/**
	 * Constructs a new {@code AbstractProcess}
	 */
	private function AbstractProcess(Void) {
		distributor = new SimpleEventDistributorControl(ProcessListener);
		event = distributor.getDistributor();
		subProcesses = new Array();
		callBacks = new HashMap();
		started = false;
		paused = false;
		finished = false;
	}
	
	/**
	 * Starts a subprocess.
	 * <p>Your Process will not be finished until all the subprocesses are finished.
	 * <p>If you start more processes after each other, all will get started immediately.
	 * It is no batch system where one starts strictly after another.
	 * 
     * @param process Process to be started.
     * @param args Arguments for the process start.
     * @param callBack Callback to be executed if the process finishes.
	 */
	public function startSubProcess(process:Process, args:Array, callBack:Executable):Void {
		if (!ArrayUtil.contains(subProcesses, process)) {
			subProcesses.push(process);
			process.addProcessListener(this);
			callBacks.put(process, callBack);
			process["start"].apply(process, args);
			pause();
		}
	}
	
	/**
	 * Pauses the process.
	 */
	public function pause(Void):Void {
		paused = true;
		event.onPauseProcess(this);
	}
	
	/**
	 * Resumes the process
	 */
	public function resume(Void):Void {
		paused = false;
		event.onResumeProcess(this);
	}
	
	/**
	 * Prepares the start of the process
	 */
	private function prepare(Void):Void {
		started = false;
		paused = false;
		finished = false;
		event.onStartProcess(this);
		started = true;
	}
	
	/**
	 * Starts the process.
	 */
    public function start() {
    	prepare();
		var result = run.apply(this, arguments);
		if(!isPaused()) {
			finish();
		}
		return result;
	}
	
	/**
	 * Template method for running the process.
	 */
	private function run(Void):Void {
		throw new AbstractOperationException(".run is abstract and has to be implemented.", this, arguments);
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
	
	/**
	 * 
	 */
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
	
	public function onUpdateProcess(process:Process):Void {}
	
	public function onStartProcess(process:Process):Void {}
	
	public function onFinishProcess(process:Process):Void {
		process.removeProcessListener(this);
		ArrayUtil.removeElement(subProcesses, process);
		callBacks.get(process).execute();
		finish();
	}
	
	public function onResumeProcess(process:Process):Void {}
	
	public function onPauseProcess(process:Process):Void {}
	
	/**
	 * Internal Method to finish the execution.
	 */
	private function finish(Void):Void {
		if (subProcesses.length == 0 && isRunning()) {
			finished = true;
			started = false;
			event.onFinishProcess(this);
		}
	}
}