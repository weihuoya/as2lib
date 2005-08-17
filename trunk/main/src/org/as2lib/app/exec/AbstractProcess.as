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
import org.as2lib.env.except.IllegalArgumentException;
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
 * <p>Most of the functionalities of {@link Process} are served well within 
 * {@code AbstractProcess}. Because of the situation that most processes are 
 * simple executions {@code AbstractProcess} allows easy implementations of 
 * {@link Process}.
 * 
 * <p>To use the advantage of {@code AbstractProcess} simple extend it and
 * implement the {@link #run} method.
 * 
 * <p>It executes {@link #run} at {@link #start} and handles the exeuction of
 * events and the correct states. If you wan't to stop your process
 * {@link #pause} and {@link #resume} offer direct support.
 * 
 * @author Martin Heidegger
 * @version 1.0
 * @see Process
 * @see ProcessListener
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
	
	/** Holder for a possible set parent */
	private var parent:Process;
	
	/**
	 * Constructs a new {@code AbstractProcess}
	 */
	private function AbstractProcess(Void) {
		this.distributor = new SimpleEventDistributorControl(ProcessListener);
		this.event = distributor.getDistributor();
		this.subProcesses = new Array();
		this.callBacks = new HashMap();
		this.started = false;
		this.paused = false;
		this.finished = false;
	}
	
	/**
	 * Setter for a possible parent process.
	 * 
	 * @param p Process to act as parentprocess.
	 * @throws IllegalArgumentException if the applied process has the current 
	 *         instance in its parents-hierarchy.
	 */
	public function setParentProcess(p:Process):Void {
		do {
			if(p == this) {
				throw new IllegalArgumentException("You can not start a process with itself as super process.", this, arguments);
			}
		} while (p = p.getParentProcess());
		this.parent = p;
	}
	
	/**
	 * Getter for the parent process.
	 * 
	 * @returns Parent process if set, else null.
	 */
	public function getParentProcess(Void):Process {
		return this.parent;
	}
	
	/**
	 * Starts a sub process.
	 * <p>Your Process will not be finished until all the subprocesses are
	 * finished.
	 * 
	 * <p>If you start more processes after each other, all will get started
	 * immediately. It is no batch system where one starts strictly after another.
	 * 
	 * <p>You can start one specific process only if this process wasn't started
	 * before
	 * 
     * @param process Process to be started.
     * @param args Arguments for the process start.
     * @param callBack Callback to be executed if the process finishes.
	 */
	public function startSubProcess(process:Process, args:Array, callBack:Executable):Void {
		if(!process.hasStarted()) {
			if (!ArrayUtil.contains(subProcesses, process)) {
				process.addProcessListener(this);
				this.subProcesses.push(process);
				this.callBacks.put(process, callBack);
				process.setParentProcess(this);
				process["start"].apply(process, args);
				this.pause();
			}
		}
	}
	
	/**
	 * Pauses the process.
	 */
	public function pause(Void):Void {
		this.paused = true;
		this.event.onPauseProcess(this);
	}
	
	/**
	 * Resumes the process
	 */
	public function resume(Void):Void {
		this.paused = false;
		this.event.onResumeProcess(this);
	}
	
	/**
	 * Prepares the start of the process
	 */
	private function prepare(Void):Void {
		this.started = false;
		this.paused = false;
		this.finished = false;
		this.event.onStartProcess(this);
		this.started = true;
	}
	
	/**
	 * Starts the process.
	 */
    public function start() {
    	prepare();
    	var result;
    	try {
			result = run.apply(this, arguments);
    	} catch(e) {
    		event.onProcessError(this, e);
    	}
		if(!isPaused()) {
			finish();
		}
		return result;
	}
	
	/**
	 * Template method for running the process.
	 * 
	 * @throws AbstractOperationException if the method was not extended
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
	 * Adds a {@link ProcessListener} as Observer to the process.
	 * 
	 * @param listener {@link ProcessListener} to be added. 
	 */
    public function addProcessListener(listener:ProcessListener):Void {
		distributor.addListener(listener);
	}
	
    /**
     * Removes a {@link ProcessListener} as Observer from the process.
     * 
     * @param listener {@link ProcessListener} to be added.
     */
	public function removeProcessListener(listener:ProcessListener):Void {
		distributor.removeListener(listener);
	}
	
	/**
	 * Removes all added Observers.
	 */
	public function removeAllProcessListeners(Void):Void {
		distributor.removeAllListeners();
	}
	
	/**
	 * Adds a {@code list} of {@link ProcessListener} as Observer to the process.
	 * 
	 * @param list List of listeners to be added.
	 */
	public function addAllProcessListeners(list:Array):Void {
		distributor.addAllListeners(list);
	}
	
	/**
	 * Flag if the process has been started.
	 * 
	 * @return true if the process has been started and isn't finish yet else false.
	 */
	public function getAllProcessListeners(Void):Array {
		return distributor.getAllListeners();
	}
	
    /**
     * Getter for the currently executed percentage of the process.
     * 
     * @return Percentage of execution. Null if percentage was not evaluateable.
     */
    public function getPercentage(Void):Number {
		return null;
	}
	
	/**
	 * Method to be executed if a process property changes.
	 * 
	 * @param process {@link Process} that changed some properties
	 */
	public function onUpdateProcess(process:Process):Void {}
	
	/**
	 * Method to be executed if a process starts execution.
	 * 
	 * @param process {@link Process} that started execution
	 */
	public function onStartProcess(process:Process):Void {}
	
	/**
	 * Method to be executed if a process finishes its execution.
	 * 
	 * @param process {@link Process} that finished with execution
	 */
	public function onFinishProcess(process:Process):Void {
		process.removeProcessListener(this);
		ArrayUtil.removeElement(subProcesses, process);
		callBacks.get(process).execute();
		finish();
	}
	
    /**
     * Method to be executed if a exception was thrown during the execution.
     * 
     * @param process {@link Process} where a error occured
     * @param error Error that was catched with try & catch
     */
	public function onProcessError(process:Process, error):Void {
		event.onProcessError(this, error);
	}
	
	/**
	 * Method to be executed if a process awakes from pause.
	 * 
	 * @param process {@link Process} that resumes from pause
	 */
	public function onResumeProcess(process:Process):Void {}
	
	/**
	 * Method to be executed if a process pauses.
	 * 
	 * @param process {@link Process} that paused execution
	 */
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