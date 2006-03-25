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
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.BatchStartListener;
import org.as2lib.app.exec.BatchFinishListener;
import org.as2lib.app.exec.BatchErrorListener;
import org.as2lib.app.exec.BatchUpdateListener;
import org.as2lib.app.exec.ProcessErrorListener;
import org.as2lib.app.exec.ProcessPauseListener;
import org.as2lib.app.exec.ProcessFinishListener;
import org.as2lib.app.exec.ProcessResumeListener;
import org.as2lib.app.exec.ProcessUpdateListener;
import org.as2lib.app.exec.ProcessStartListener;
import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.app.exec.Batch;

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
 * <p>It supports beneath all listeners of {@link Process} seperate events for
 * {@code Batch} processing:
 *   {@link BatchStartListener}, {@link BatchFinishListener},
 *   {@link BatchUpdateListener} and {@link BatchErrorListener}
 *
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.app.exec.BatchProcess extends AbstractProcess implements Batch, ProcessUpdateListener,
		ProcessPauseListener, ProcessResumeListener, ProcessStartListener, ProcessFinishListener,
		ProcessErrorListener, BatchFinishListener, BatchUpdateListener, BatchErrorListener {
	
	/** List that contains all processes */
	private var list:Array;
	
	/** Holder for the percents already executed */
	private var percent:Number;
	
	/** Current running process */
	private var current:Number;
	
	/** Does this batch act like a simple process? */
	private var actAsProcess:Boolean;
	
	/**
	 * Constructs a new {@code BatchProcess}
	 */
	public function BatchProcess(actAsProcess:Boolean) {
		this.actAsProcess = actAsProcess;
		acceptListenerType(BatchStartListener);
		acceptListenerType(BatchFinishListener);
		acceptListenerType(BatchErrorListener);
		acceptListenerType(BatchUpdateListener);
		list = new Array();
		percent = 0;
		started = false;
		finished = false;
	}
	
	public function getName(Void):String {
		var result:String = super.getName();
		if (result == null) {
			result = getCurrentProcess().getName();
		}
		return result;
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
			if (p == this) {
				throw new IllegalArgumentException("You can not start a process with itself as super process.", this, arguments);
			}
		}
		while (p = p.getParentProcess());
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
	 * @param process Finished Process.
	 */
	public function onProcessFinish(process:Process):Void {
		if (!actAsProcess) {
			super.sendFinishEvent(process);
		}
		// TODO: Comparing given process with current process is not correct in all cases, because sometimes the current process just delegates everything to another process instance, that passes itself. In this case the check returns false although everything is correct!
		//if (info == getCurrentProcess()) {
		if (getCurrentProcess().hasFinished()) {
			process.removeListener(this);
			nextProcess();
		}
		/*} else {
			var error:IllegalArgumentException = new IllegalArgumentException("Unexpected onFinishProcess occured from "+info+".", this, arguments);
			publishError(error);
			finish();
		}*/
	}
	
	public function onBatchFinish(batch:Batch):Void {
		batch.removeListener(this);
		nextProcess();
	}
	
	/**
	 * Internal helper to start the next process.
	 */
	private function nextProcess(Void):Void {
		if (current < list.length - 1) {
			updatePercent(100);
			current ++;
			var c:Process = list[current];
			c.setParentProcess(this);
			c.addListener(this);
			c.start();
			//if (useCurrentProcess) {
				// A batch process distributes an update event when it gets started.
				// A separate update must thus not be distributed.
				//if (!(c instanceof Batch)) {
					sendUpdateEvent();
				//}
			//}
		}
		else {
			finish();
		}
	}
	
	/**
	 * Void implementation of {@link ProcessStartListener#onProcessStart}
	 * 
	 * @param process to the process that has been started.
	 */
	public function onProcessStart(process:Process):Void {
		if (!actAsProcess) {
			super.sendStartEvent(process);
		}
	}
	
	/**
	 * Implementation of {@link ProcessPauseListener#onProcessPause} that redirects
	 * to internal eventbroadcasting.
	 * 
	 * @param process to the process that has been paused.
	 */
	public function onProcessPause(process:Process):Void {
		if (!actAsProcess) {
			super.sendPauseEvent(process);
		}
		//if (process == getCurrentProcess()) {
			//sendPauseEvent();
		/*} else {
			publishError(new IllegalArgumentException("Unexpected onPauseProcess occured from " + process + ". Expected was " + getCurrentProcess(), this, arguments));
		}*/
	}
	
	/**
	 * Implementation of {@link ProcessResumeListener#onProcessResume} that redirects
	 * to internal eventbroadcasting.
	 * 
	 * @param process to the process that has been resumed.
	 */
	public function onProcessResume(process:Process):Void {
		if (!actAsProcess) {
			super.sendResumeEvent(process);
		}
		//if (process == getCurrentProcess()) {
			//sendResumeEvent();
		/*} else {
			publishError(new IllegalArgumentException("Unexpected onResumeProcess occured from " + process + ".", this, arguments));
		}*/
	}
	
	/**
	 * Implementation of {@link ProcessErrorListener#onProcessError} that redirects
	 * to internal eventbroadcasting.
	 * 
	 * @param process to the process that has thrown the error.
	 */
	public function onProcessError(process:Process, error):Boolean {
		var result:Boolean = false;
		if (!actAsProcess) {
			result = super.sendErrorEvent(error, process);
		}
		/*if (process != getCurrentProcess()) {
			error = new IllegalArgumentException("Unexpected onProcessError occured from " + process + ".", this, arguments);
		}*/
		if (getParentProcess() == null || actAsProcess) {
			if (!result) {
				publishError(error);
			}
			else {
				result = publishError(error);
			}
		}
		if (!result && !hasFinished()) {
			finish();
		}
		return result;
	}
	
	public function onBatchError(batch:Batch, error):Boolean {
		return sendErrorEvent(error);
	}
	
	/**
	 * Implementation of {@link ProcessUpdateListener#onProcessUpdate} that redirects
	 * to internal eventbroadcasting.
	 * 
	 * @param info to the process that got updated.
	 */
	public function onProcessUpdate(process:Process):Void {
		if (!actAsProcess) {
			super.sendUpdateEvent(process);
		}
		var p:Number = getCurrentProcess().getPercentage();//process.getPercentage();
		if (p != null) {
			updatePercent(p);
		}
		if (getParentProcess() == null || actAsProcess) {
			sendUpdateEvent();
		}
	}
	
	public function onBatchUpdate(batch:Batch):Void {
		sendUpdateEvent();
	}
	
	/**
	 * Starts the execution of the Batch.
	 */
    public function start() {
    	if (!started) {
			current = -1;
			started = false;
			finished = false;
			working = true;
			percent = 0;
			delete endTime;
			startTime = getTimer();
			started = true;
			sendStartEvent();
			nextProcess();
    	}
	}
	
	/**
	 * Adds a {@link Process} to the list of processes to execute.
	 * 
	 * <p>Its possible to at the same process more than one times. It will be
	 * executed as often as you add it.
	 * 
	 * @param p {@code Process} to be added
	 * @return internal identifier of the process
	 */
	public function addProcess(p:Process):Number {
		if (p != null && p != this) {
			list.push(p);
			updatePercent(100);
			return list.length - 1;
		}
	}
	
	/**
	 * Removes all instances of a process that were added to the {@code Batch}.
	 * 
	 * <p>If a process has been added more than one times, it removes all
	 * executions.
	 * 
	 * @param process {@link Process} to be removed
	 * @see removeProcessById
	 */
	public function removeProcess(p:Process):Void {
		if (p != null) {
			var i:Number = list.length;
			while(--i-(-1)) {
				if (list[i] == p) {
					list.slice(i, i);
					return;
				}
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
	 * Getter for the current percentage of execution.
	 * 
	 * @return Amount of solved execution in percent.
	 */
    public function getPercentage(Void):Number {
		return percent;
	}
	
	/**
	 * Internal Update of percentage
	 * 
	 * @param cP Percentage of the current process.
	 */
	private function updatePercent(cP:Number):Void {
		//percent = 100 / list.length * (current + (1 / 100 * cP));
		percent = 100 / getProcessCount() * (current + (1 / 100 * cP));
	}
	
	public function getProcessCount(Void):Number {
		var result:Number = 0;
		for (var i:Number = 0; i < list.length; i++) {
			var batch:Batch = Batch(list[i]);
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
	 * Internal method to send error events.
	 * 
	 * @param error error to be provided
	 * @return {@code true} to consume the event
	 */
	private function sendErrorEvent(error):Boolean {
		var result:Boolean = false;
		if (actAsProcess) {
			result = super.sendErrorEvent(error);
		}
		else {
			var errorDistributor:BatchErrorListener = dC.getDistributor(BatchErrorListener);
			result = errorDistributor.onBatchError(this, error);
		}
		if (!result && !hasFinished()) {
			finish();
		}
		return result;
	}
	
	/**
	 * Internal method to send finish events.
	 */
	private function sendFinishEvent(Void):Void {
		try {
			if (actAsProcess) {
				super.sendFinishEvent();
			}
			else {
				var finishDistributor:BatchFinishListener =
						dC.getDistributor(BatchFinishListener);
				finishDistributor.onBatchFinish(this);
			}
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			sendErrorEvent(exception.getCause());
		}
	}
	
	/**
	 * Internal method to send pause events.
	 */
	private function sendPauseEvent(Void):Void {
		sendUpdateEvent();
	}
	
	/**
	 * Internal method to send resume events.
	 */
	private function sendResumeEvent(Void):Void {
		sendUpdateEvent();
	}
	
	/**
	 * Internal method to send update events.
	 */
	private function sendUpdateEvent(Void):Void {
		try {
			if (actAsProcess) {
				super.sendUpdateEvent();
			}
			else {
				var updateDistributor:BatchUpdateListener =
						dC.getDistributor(BatchUpdateListener);
				updateDistributor.onBatchUpdate(this);
			}
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			sendErrorEvent(exception.getCause());
		}
	}
	
	/**
	 * Internal method to send start events.
	 */
	private function sendStartEvent(Void):Void {
		try {
			if (actAsProcess) {
				super.sendStartEvent();
			}
			else {
				var startDistributor:BatchStartListener =
						dC.getDistributor(BatchStartListener);
				startDistributor.onBatchStart(this);
			}
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			sendErrorEvent(exception.getCause());
		}
	}
	
}