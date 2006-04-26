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

import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.BatchErrorListener;
import org.as2lib.app.exec.BatchFinishListener;
import org.as2lib.app.exec.BatchUpdateListener;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessErrorListener;
import org.as2lib.app.exec.ProcessFinishListener;
import org.as2lib.app.exec.ProcessUpdateListener;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * {@code BatchProcess} is a batch that acts to the outside like a process. Use this
 * batch if you want to treat multiple process executions like one execution, otherwise
 * use {@link SimpleBatch}.
 * 
 * <p>This batch executes its child-processes after each other. This means that the
 * first child-process will be executed at the beginning, the second after the first
 * finished execution and so on.
 * 
 * <p>You can seamlessly add this batch to other {@code BatchProcess} instances or
 * to {@code SimpleBatch} instances. But do never add {@code SimpleBatch} instances
 * as child-processes to this batch.
 * 
 * <p>Because this batch acts like a process it does not distribute batch events but
 * only process events.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.app.exec.BatchProcess extends AbstractProcess implements Batch,
		BatchFinishListener, BatchUpdateListener, BatchErrorListener, ProcessFinishListener,
		ProcessUpdateListener, ProcessErrorListener {
	
	/** All added processes. */
	private var processes:Array;
	
	/** The process that is currently running. */
	private var currentProcess:Number;
	
	/** Loading progress in percent. */
	private var percentage:Number;
	
	/**
	 * Constructs a new {@code BatchProcess} instance.
	 */
	public function BatchProcess(Void) {
		processes = new Array();
		percentage = 0;
		started = false;
		finished = false;
	}
	
	/**
	 * Distributes a process error event with the given error.
	 * 
	 * @param process the process that raised the error
	 * @param error the raised error
	 */
	public function onProcessError(process:Process, error):Boolean {
		return distributeErrorEvent(error);
	}
	
	/**
	 * Distributes a process update event.
	 * 
	 * @param process the process that was updated
	 */
	public function onProcessUpdate(process:Process):Void {
		var percentage:Number = getCurrentProcess().getPercentage();
		if (percentage != null) {
			updatePercentage(percentage);
		}
		distributeUpdateEvent();
	}
	
	/**
	 * Distributes a process error event with the given error.
	 * 
	 * @param error the error to distribute
	 */
	private function distributeErrorEvent(error):Boolean {
		var result:Boolean = super.distributeErrorEvent(error);
		if (!result && !hasFinished()) {
			finish();
		}
		return result;
	}
	
	// TODO: There is a class initialization order error when working with the testing framework I could not track down. Thus all methods from AbstractBatch are copied to this class.
	
	/**
	 * Starts the execution of this batch.
	 */
    public function start() {
    	if (!started) {
			currentProcess = -1;
			finished = false;
			working = true;
			percentage = 0;
			delete endTime;
			startTime = getTimer();
			started = true;
			distributeStartEvent();
			nextProcess();
    	}
	}
	
	public function getName(Void):String {
		var result:String = super.getName();
		if (result == null) {
			result = getCurrentProcess().getName();
		}
		return result;
	}
	
	public function getPercentage(Void):Number {
		return percentage;
	}
	
	/**
	 * Updates the loading progress percentage.
	 * 
	 * @param percentage the progress percentage of the current process
	 */
	private function updatePercentage(percentage:Number):Void {
		this.percentage = 100 / getProcessCount() * (currentProcess + (1 / 100 * percentage));
	}
	
	public function getProcessCount(Void):Number {
		var result:Number = 0;
		for (var i:Number = 0; i < processes.length; i++) {
			var batch:Batch = Batch(processes[i]);
			if (batch != null) {
				result += batch.getProcessCount();
			}
			else {
				result++;
			}
		}
		return result;
	}
	
	public function getParentProcess(Void):Process {
		return parent;
	}
	
	/**
	 * Sets the parent of this process.
	 * 
	 * @throws IllegalArgumentException if this process is a itself a parent of the
	 * given process (to prevent infinite recursion)
	 * @param parentProcess the new parent process of this process
	 */
	public function setParentProcess(parentProcess:Process):Void {
		this.parent = parentProcess;
		do {
			if (parentProcess == this) {
				throw new IllegalArgumentException("A process may not be the parent of its parent process.", this, arguments);
			}
			parentProcess = parentProcess.getParentProcess();
		}
		while (parentProcess != null);
	}
	
	/**
	 * Adds the given process to execute to this batch.
	 * 
	 * <p>It is possible to add the same process more than once. It will be executed
	 * as often as you add it.
	 * 
	 * @param process the process to add
	 */
	public function addProcess(process:Process):Void {
		if (process != null && process != this) {
			processes.push(process);
			updatePercentage(100);
		}
	}
	
	/**
	 * Removes all occurrences of the given process.
	 * 
	 * @param process the process to remove
	 */
	public function removeProcess(process:Process):Void {
		if (process != null) {
			var i:Number = processes.length;
			while(--i-(-1)) {
				if (processes[i] == process) {
					if (i == currentProcess) {
						throw new IllegalArgumentException("Process [" + process + "] is currently running and can thus not be removed.", this, arguments);
					}
					if (i < currentProcess) {
						currentProcess--;
					}
					processes.slice(i, i);
				}
			}
		}
	}
	
	/**
	 * Gives the given process highest priority: the given process will be started
	 * as soon as the currently running process finishes.
	 * 
	 * @param process the process to run next
	 */
	public function moveProcess(process:Process):Void {
		if (process != null) {
			var i:Number = processes.length;
			while(--i-(-1)) {
				if (processes[i] == process) {
					if (i != currentProcess) {
						if (i < currentProcess) {
							currentProcess--;
						}
						processes.slice(i, i);
						processes.splice(currentProcess + 1, 0, process);
					}
				}
			}
		}
	}
	
	public function getCurrentProcess(Void):Process {
		return processes[currentProcess];
	}
	
	public function getAllProcesses(Void):Array {
		return processes.concat();
	}
	
	/**
	 * Executes the next process if the current process has finished.
	 * 
	 * @param process the finished process
	 * @see #nextProcess
	 */
	public function onProcessFinish(process:Process):Void {
		if (getCurrentProcess().hasFinished()) {
			nextProcess();
		}
	}
	
	/**
	 * Executes the next process.
	 * 
	 * @param batch the finished batch
	 * @see #nextProcess
	 */
	public function onBatchFinish(batch:Batch):Void {
		batch.removeListener(this);
		nextProcess();
	}
	
	/**
	 * Starts the next process and distributes an update event, or finishes this
	 * batch and distributes a finished event if there is no next process.
	 * 
	 * @see #distributeUpdateEvent
	 * @see #finish
	 */
	private function nextProcess(Void):Void {
		getCurrentProcess().removeListener(this);
		if (currentProcess < processes.length - 1) {
			updatePercentage(100);
			currentProcess++;
			var process:Process = processes[currentProcess];
			process.setParentProcess(this);
			process.addListener(this);
			process.start();
			distributeUpdateEvent();
		}
		else {
			finish();
		}
	}
	
	/**
	 * Distributes an update event.
	 * 
	 * @param batch the batch that was updated
	 */
	public function onBatchUpdate(batch:Batch):Void {
		distributeUpdateEvent();
	}
	
	/**
	 * Distributes an error event with the given error.
	 * 
	 * @param batch the batch that raised the error
	 * @param error the raised error
	 */
	public function onBatchError(batch:Batch, error):Boolean {
		return distributeErrorEvent(error);
	}
	
}