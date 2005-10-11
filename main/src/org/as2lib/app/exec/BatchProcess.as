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
import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.BatchListener;
import org.as2lib.data.type.Time;
import org.as2lib.app.exec.ProcessErrorListener;
import org.as2lib.app.exec.ProcessPauseListener;
import org.as2lib.app.exec.ProcessFinishListener;
import org.as2lib.app.exec.ProcessResumeListener;
import org.as2lib.app.exec.ProcessUpdateListener;
import org.as2lib.app.exec.ProcessStartListener;
import org.as2lib.app.exec.AbstractProcess;

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
 * <p>It supports beneath the {@link ProcessListener} the events for
 * {@link BatchListener}.
 *
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.app.exec.BatchProcess extends AbstractProcess
	implements Batch,
	    ProcessUpdateListener,
		ProcessPauseListener,
	    ProcessResumeListener,
	    ProcessStartListener,
		ProcessFinishListener,
		ProcessErrorListener
	 {
	
	/** List that contains all processes */
	private var list:Array;
	
	/** Holder for the percents already executed */
	private var percent:Number;
	
	/** Current running process */
	private var current:Number;
	
	/**
	 * Constructs a new {@code BatchProcess}
	 */
	public function BatchProcess(Void) {
		dC.acceptListenerType(BatchListener);
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
			info.removeListener(this);
			nextProcess();
		} else {
			var error:IllegalArgumentException = new IllegalArgumentException("Unexpected onFinishProcess occured from "+info+".", this, arguments);
			publishError(error);
			finish();
		}
	}
	
	private function nextProcess(Void):Void {
		if (current < list.length-1) {
			updatePercent(100);
			sendUpdateEvent();
			current ++;
			var c:Process = list[current];
			c.setParentProcess(this);
			c.addListener(this);
			c.start();
		} else {
			finish();
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
		if (info == getCurrentProcess()) {
			sendPauseEvent();
		} else {
			publishError(new IllegalArgumentException("Unexpected onPauseProcess occured from "+info+". Expected was "+getCurrentProcess(), this, arguments));
		}
	}
	
	/**
	 * Implementation of {@link ProcessListener#onResumeProcess} that redirects
	 * to internal eventbroadcasting.
	 * 
	 * @param info to the process that has been resumed.
	 */
	public function onResumeProcess(info:Process):Void {
		if (info == getCurrentProcess()) {
			sendResumeEvent();
		} else {
			publishError(new IllegalArgumentException("Unexpected onResumeProcess occured from "+info+".", this, arguments));
		}
	}
	
	/**
	 * Implementation of {@link ProcessListener#onProcessError} that redirects
	 * to internal eventbroadcasting.
	 * 
	 * @param info to the process that has thrown the error.
	 */
	public function onProcessError(info:Process, error):Boolean {
		if (info != getCurrentProcess()) {
			error = new IllegalArgumentException("Unexpected onProcessError occured from "+info+".", this, arguments);
		}
		
		var result:Boolean = publishError(error);
		if (!result) {
			finish();
		}
		return result;
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
		sendUpdateEvent();
	}
	
	/**
	 * Starts the execution of the Batch.
	 */
    public function start() {
    	if(!started) {
			current = -1;
			started = false;
			finished = false;
			working = true;
			percent = 0;
			
			delete endTime;
			startTime = getTimer();
			sendStartEvent();
			started = true;
			nextProcess();
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
	 * Getter for the current percentage of execution.
	 * 
	 * @returns Amount of solved execution in percent.
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
		percent = 100/list.length*(current+(1/100*cP));
	}

	public function getEstimatedRestTime(Void) : Time {
		return null;
	}

}