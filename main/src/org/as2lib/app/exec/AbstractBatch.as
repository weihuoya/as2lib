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
import org.as2lib.app.exec.ProcessFinishListener;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;

/**
 * @author Simon Wacker
 */
class org.as2lib.app.exec.AbstractBatch extends AbstractProcess implements Batch,
		ProcessFinishListener, BatchFinishListener, BatchUpdateListener, BatchErrorListener {
	
	/** All added processes. */
	private var processes:Array;
	
	/** The process that is currently running. */
	private var currentProcess:Number;
	
	/** Loading progress in percent. */
	private var percentage:Number;
	
	/**
	 * Constructs a new {@code AbstractBatch} instance.
	 */
	private function AbstractBatch(Void) {
		processes = new Array();
		percentage = 0;
		started = false;
		finished = false;
	}
	
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
			distributeUpdateEvent();
			process.start();
		}
		else {
			finish();
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
				throw new IllegalArgumentException("A process may not be the parent of its " +
						"parent process.", this, arguments);
			}
			parentProcess = parentProcess.getParentProcess();
		}
		while (parentProcess != null);
	}
	
	public function getCurrentProcess(Void):Process {
		return processes[currentProcess];
	}
	
	public function getAllProcesses(Void):Array {
		return processes.concat();
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
	 * Adds all given processes which implement the {@link Process} interface.
	 * 
	 * @param processes the processes to add
	 */
	public function addAllProcesses(processes:Array):Void {
		for (var i:Number = 0; i < processes.length; i++) {
			addProcess(Process(processes[i]));
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
			while (--i-(-1)) {
				if (processes[i] == process) {
					if (i == currentProcess) {
						throw new IllegalArgumentException("Process [" + process + "] is " +
								"currently running and can thus not be removed.", this, arguments);
					}
					if (i < currentProcess) {
						currentProcess--;
					}
					processes.slice(i, i);
				}
			}
		}
	}
	
	public function removeAllProcesses(Void):Void {
		if (started) {
			throw new IllegalStateException("All processes cannot be removed when batch is " +
					"running.", this, arguments);
		}
		processes = new Array();
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