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

import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.event.distributor.SimpleEventDistributorControl;
import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessListener;
import org.as2lib.app.exec.BatchListener;
import org.as2lib.core.BasicClass;

/**
 * {@code BatchProcess} is a implementation of {@link Batch} for a list of
 * Processes.
 * 
 * <p>A {@code BatchProcess} acts like a row execution of {@link Process}
 * instances. All listed processes will be executed after each other.
 * 
 * <p>As {@code BatchProcess} itself acts like a Process you can use it as a 
 * composite to execute a {@code BatchProcess} within another
 * {@code BatchProcess}.
 *
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.app.exec.BatchProcess extends BasicClass implements Batch, ProcessListener {
	
	/** Flag if execution was started */
	private var started:Boolean;
	
	/** Flag if execution was finished */
	private var finished:Boolean;
	
	/** Holder for the control to the batch related event */
	private var batchEventControl:EventDistributorControl;
	
	/** Holder for the event to be executed for batchlistener */
	private var batchEvent:BatchListener;
	
	/** Holder for the control to the process related event */
	private var processEventControl:SimpleEventDistributorControl;
	
	/** Holder for the events to be executed for processlistener*/
	private var processEvent:ProcessListener;
	
	/** List that contains all processes **/
	private var list:Array;
	
	/** Holder for the percents already executed */
	private var percent:Number;
	
	/** Current running process */
	private var current:Number;
	
	/** Holder for a possible parent process, might be null */
	private var parent:Process;
	
	/**
	 * Creates a new {@code BatchProcess}
	 */
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
	
	/**
	 * Setter for the parent process
	 * 
	 * @throws IllegalArgumentException if the passed process has the current
	 *         instance as a parent process (recursion safe).
	 * @param p Process to be set as parent
	 */
	public function setParentProcess(p:Process):Void {
		parent = p;
		do {
			if(p == this) {
				throw new IllegalArgumentException("You can not start a process with itself as super process.", this, arguments);
			}
		} while (p = p.getParentProcess());
	}
	
	/**
	 * Getter for the applied parent process.
	 * 
	 * @return Parent process or null if no parent process has been set.
	 */
	public function getParentProcess(Void):Process {
		return parent;
	}
	
	/**
	 * Getter for the currently execution process.
	 * 
	 * @return Currently processing Process.
	 */
    public function getCurrentProcess(Void):Process {
		return list[current];
	}
	
	/**
	 * Getter for a list of all added processes with {@link #addProcess} in
	 * form of a array.
	 * 
	 * @return Array that contains all processes that has been added.
	 */
	public function getAllAddedProcesses(Void):Array {
		return list.concat();
	}
	
	/**
	 * To be executed if one child process has been finished.
	 * 
	 * @param info Finished Process.
	 */
	public function onFinishProcess(info:Process):Void {
		if (info == getCurrentProcess()) {
			info.removeProcessListener(this);
			if (current < list.length) {
				updatePercent(100);
				batchEvent.onUpdateBatch(this);
				processEvent.onUpdateProcess(this);
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
		} else {
			var error:IllegalArgumentException = new IllegalArgumentException("Unexpected onFinishProcess occured from "+info+".", this, arguments);
			batchEvent.onBatchError(this, error);
			processEvent.onProcessError(this, error);
		}
	}
	
	/**
	 * Void implementation of {@link ProcessListener#onStartProcess}
	 * 
	 * @param info to the process that has been started.
	 */
	public function onStartProcess(info:Process):Void {}
	
	/**
	 * Implementation of {@link ProcessListener#onPauseProcess} that redirects
	 * to internal eventbroadcasting.
	 * 
	 * @param info to the process that has been paused.
	 */
	public function onPauseProcess(info:Process):Void {
		if (info != getCurrentProcess()) {
			batchEvent.onUpdateBatch(this);
			processEvent.onUpdateProcess(this);
		} else {
			var error:IllegalArgumentException = new IllegalArgumentException("Unexpected onPauseProcess occured from "+info+".", this, arguments);
			batchEvent.onBatchError(this, error);
			processEvent.onProcessError(this, error);
		}
	}
	
	/**
	 * Implementation of {@link ProcessListener#onResumeProcess} that redirects
	 * to internal eventbroadcasting.
	 * 
	 * @param info to the process that has been resumed.
	 */
	public function onResumeProcess(info:Process):Void {
		if (info != getCurrentProcess()) {
			batchEvent.onUpdateBatch(this);
			processEvent.onUpdateProcess(this);
		} else {
			var error:IllegalArgumentException = new IllegalArgumentException("Unexpected onResumeProcess occured from "+info+".", this, arguments);
			batchEvent.onBatchError(this, error);
			processEvent.onProcessError(this, error);
		}
	}
	
	/**
	 * Implementation of {@link ProcessListener#onProcessError} that redirects
	 * to internal eventbroadcasting.
	 * 
	 * @param info to the process that has thrown the error.
	 */
	public function onProcessError(info:Process, error):Void {
		if (info != getCurrentProcess()) {
			batchEvent.onBatchError(this, error);
			processEvent.onProcessError(this, error);
		} else {
			var wrapper:IllegalArgumentException = new IllegalArgumentException("Unexpected onFinishProcess occured from "+info+".", this, arguments);
			batchEvent.onBatchError(this, wrapper);
			processEvent.onProcessError(this, wrapper);
		}
	}
	
	/**
	 * Implementation of {@link ProcessListener#onUpdateProcess} that redirects
	 * to internal eventbroadcasting.
	 * 
	 * @param info to the process that got updated.
	 */
	public function onUpdateProcess(info:Process):Void {
		var p:Number = info.getPercentage();
		if(p != null) {
			updatePercent(p);
		}
		batchEvent.onUpdateBatch(this);
		processEvent.onUpdateProcess(this);
	}
	
	/**
	 * Starts the execution of the Batch.
	 */
    public function start() {
    	if(!started) {
			current = 0;
			started = false;
			finished = false;
			percent = 0;
			
			batchEvent.onStartBatch(this);
			processEvent.onStartProcess(this);
			started = true;
			onFinishProcess();
    	}
	}
	
	/**
	 * Adds a process to the list of processes.
	 * 
	 * @param p Process to be added.
	 * @return Internal Id of the process.
	 */
	public function addProcess(p:Process):Number {
		if(p != this) {
			list.push(p);
			updatePercent(100);
			return list.length-1;
		}
	}
	
	/**
	 * Removes a process from the list of executed processes.
	 * 
	 * <p>If a process has been added more than one times, it removes all
	 * executions.
	 * 
	 * @param p Process to be removed.
	 * @see #removeProcessById
	 */
	public function removeProcess(p:Process):Void {
		var i:Number = list.length;
		while(--i-(-1)) {
			if(list[i] == p) {
				list.slice(i, i);
				return;
			}
		}
	}
	
	/**
	 * Removes a process by its internal id.
	 * 
	 * <p>{@link #addProcess} returns the internal id of a added process. This
	 * method helps to remove concrete reference to the process.
	 * 
	 * @param id Internal Id of the process.
	 * @see #removeProcess
	 */
	public function removeProcessById(id:Number):Void {
		list.splice(id, 1);
	}

	/**
	 * Adds a {@link ProcessListener} as Observer to the process.
	 * 
	 * @param listener {@link ProcessListener} to be added. 
	 */
    public function addProcessListener(listener:ProcessListener):Void {
		processEventControl.addListener(listener);
	}
	
    /**
     * Removes a {@link ProcessListener} as Observer from the process.
     * 
     * @param listener {@link ProcessListener} to be added.
     */
	public function removeProcessListener(listener:ProcessListener):Void {
		processEventControl.removeListener(listener);
	}
	
	/**
	 * Removes all added Observers.
	 */
	public function removeAllProcessListeners(Void):Void {
		processEventControl.removeAllListeners();
	}
	
	/**
	 * Adds a {@code list} of {@link ProcessListener}s as Observer to the process.
	 * 
	 * @param list List of listeners to be added.
	 */
	public function addAllProcessListeners(list:Array):Void {
		processEventControl.addAllListeners(list);
	}
	
	/**
	 * Getter for all added Observers.
	 * 
	 * @return List that contains all registered listeners
	 */
	public function getAllProcessListeners(Void):Array {
		return processEventControl.getAllListeners();
	}
	
    /**
     * Adds a {@link BatchListener} as Observer to the {@code Batch}.
     * 
     * @param listener {@link BatchListener} to be added.
     */
    public function addBatchListener(listener:BatchListener):Void {
		batchEventControl.addListener(listener);
	}
	
	/**
	 * Removes a certain {@link BatchListener} as Observer from the {@code Batch}.
	 * 
	 * @param listener {@link BatchListener} to be removed.
	 */
	public function removeBatchListener(listener:BatchListener):Void {
		batchEventControl.removeListener(listener);
	}
	
	/**
	 * Removes all added batchlisteners that were added with
	 * {@link #addBatchListener} or {@link #addAllBatchListeners}.
	 */
	public function removeAllBatchListeners(Void):Void {
		batchEventControl.removeAllListeners();
	}
	
    /**
     * Adds a {@link BatchListener} as Observer to the {@code Batch}.
     * 
     * @param listener {@link BatchListener} to be added.
     */
	public function addAllBatchListeners(list:Array):Void {
		batchEventControl.addAllListeners(list);
	}
	
	/**
	 * Getter for all added listeners in form of a {@code Array}.
	 * 
	 * @return Added listeners in form of a array.
	 */
	public function getAllBatchListeners(Void):Array {
		return batchEventControl.getAllListeners();
	}
	
	/**
	 * Getter for the current percentage of execution.
	 * 
	 * @returns Amount of solved execution in percent.
	 */
    public function getPercentage(Void):Number {
		return percent;
	}
	
	/**
	 * Returns false if the Batch finished execution.
	 * 
	 * @return false if the Batch finished execution.
	 */
    public function hasFinished(Void):Boolean {
		return finished;
	}
	
	/**
	 * Returns true if the Batch has been started and is not finished yet.
	 * 
	 * <p>Will return false if the batch has been finished
	 * 
	 * @return true if the Batch has been started with {@link #start}
	 */
    public function hasStarted(Void):Boolean {
		return started;
	}
	
	/**
	 * Returns true if the Batch has been started and is currently running.
	 * 
	 * @return true if the Batch is currently running.
	 */
	public function isRunning(Void):Boolean {
		return !isPaused()&&hasStarted();
	}
	
	/**
	 * Returns if the Batch is paused or not.
	 * 
	 * @return true if the batch has been started and the current subprocess is
	 *         not paused.
	 */
	public function isPaused(Void):Boolean {
		if (hasStarted()) {
			return getCurrentProcess().isPaused();
		}
		return false;
	}
	
	/**
	 * Internal Update of percentage
	 * 
	 * @param cP Percentage of the current process.
	 */
	private function updatePercent(cP:Number):Void {
		percent = 100/list.length*(current+(1/100*cP));
	}
}