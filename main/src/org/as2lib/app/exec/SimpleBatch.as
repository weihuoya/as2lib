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
import org.as2lib.app.exec.AbstractBatch;
import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.BatchErrorListener;
import org.as2lib.app.exec.BatchFinishListener;
import org.as2lib.app.exec.BatchStartListener;
import org.as2lib.app.exec.BatchUpdateListener;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessErrorListener;
import org.as2lib.app.exec.ProcessFinishListener;
import org.as2lib.app.exec.ProcessPauseListener;
import org.as2lib.app.exec.ProcessResumeListener;
import org.as2lib.app.exec.ProcessStartListener;
import org.as2lib.app.exec.ProcessUpdateListener;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * {@code SimpleBatch} is a simple implementation of the {@link Batch} interface.
 * 
 * <p>This batch executes its child-processes after each other. This means that the
 * first child-process will be executed at the beginning, the second after the first
 * finished execution and so on.
 * 
 * <p>This batch distributes process as well as batch events.
 * 
 * <p>Process events are distributed if added child-processes distribute themselves process
 * events; the events distributed by the child-processes are so to speak just passed on.
 * This is done for all types of process events published by child-processes.
 * 
 * <p>Batch events are on the other hand distributed if this batch's state changes or an
 * error occurred, for example if the next child-process gets started.
 * 
 * <p>Note that error and update events are an exception to the above rule: If a
 * child-process distributes an error event, this batch will distribute a process error
 * event and a batch error event. The same is true if the child-process distributes an
 * update event because an update of a child-process means an update of this batch.
 * 
 * <p>You can seamlessly add batch processes as child-processes to this batch. If the
 * added child-batch acts like a simple process (as does {@link BatchProcess}} this
 * batch will treat the child-batch like a simple process. If the added child-batch
 * acts like a real batch (as does this batch) it is treated as if it were not there,
 * this means as if the child-processes of the child-batch were directly added to this
 * batch.
 * 
 * <p>If you want multiple processes to be treated as one process, use the
 * {@link BatchProcess}. If you want to group multiple processes, but still want them
 * to be independent and have their own events use this {@code Batch} implementation.
 * 
 * <p>For example if you add a {@link ProcessStartListener} to this batch you will be
 * notified when a child-process is started, if you add a {@link BatchStartListener}
 * you will only be notified when this batch is started. If you add a
 * {@link ProcessUpdateListener} you will be notified when a child-process has been
 * updated (that means that the progress percentage of the given process begins with
 * 0 for every new process), if you add a {@ink BatchUpdateListener} you will be notified
 * when this batch is updated (that means that the progress percentage of the given batch
 * will be the average of the total progress of all child-processes).
 * 
 * @author Simon Wacker
 */
class org.as2lib.app.exec.SimpleBatch extends AbstractBatch implements ProcessStartListener, ProcessUpdateListener,
		ProcessPauseListener, ProcessResumeListener, ProcessErrorListener {
	
	/**
	 * Constructs a new {@code SimpleBatch} instance.
	 */
	public function SimpleBatch(Void) {
		acceptListenerType(BatchStartListener);
		acceptListenerType(BatchFinishListener);
		acceptListenerType(BatchErrorListener);
		acceptListenerType(BatchUpdateListener);
	}
	
	/**
	 * Distributes a process finish event for the given process and executes the next
	 * process if the current process has also finished (the given finished process
	 * may be a sub-process of the current process).
	 * 
	 * @param process the finished process
	 * @see #nextProcess
	 */
	public function onProcessFinish(process:Process):Void {
		super.distributeFinishEvent(process);
		super.onProcessFinish(process);
	}
	
	/**
	 * Distributes a process finish event for the given process.
	 * 
	 * @param process the process that has started its execution
	 */
	public function onProcessStart(process:Process):Void {
		super.distributeStartEvent(process);
	}
	
	/**
	 * Distributes a process pause event for the given process.
	 * 
	 * @param process the process that has paused its execution
	 */
	public function onProcessPause(process:Process):Void {
		super.distributePauseEvent(process);
	}
	
	/**
	 * Distributes a process resume event for the given process.
	 * 
	 * @param process the process that has resumed its execution
	 */
	public function onProcessResume(process:Process):Void {
		super.distributeResumeEvent(process);
	}
	
	/**
	 * Distributes a process error event for the given process and a batch error event
	 * if this batch has no parent process.
	 * 
	 * @param process the process that raised the error
	 */
	public function onProcessError(process:Process, error):Boolean {
		// TODO: 'result' is always 'null' because distributers do not return values!
		var result:Boolean = super.distributeErrorEvent(error, process);
		if (getParentProcess() == null) {
			distributeErrorEvent(error);
		}
		else {
			addError(error);
		}
		if (!result && !hasFinished()) {
			finish();
		}
		return result;
	}
	
	/**
	 * Distributes a process update event for the given process and a batch update
	 * event if this batch has no parent.
	 * 
	 * @param process the process that was updated
	 */
	public function onProcessUpdate(process:Process):Void {
		var percentage:Number = getCurrentProcess().getPercentage();
		if (percentage != null) {
			updatePercentage(percentage);
		}
		super.distributeUpdateEvent(process);
		if (getParentProcess() == null) {
			distributeUpdateEvent();
		}
	}
	
	/**
	 * Distributes a batch start event and a batch error event if a listener threw an
	 * exception.
	 */
	private function distributeStartEvent(Void):Void {
		try {
			var startDistributor:BatchStartListener = distributorControl.getDistributor(BatchStartListener);
			startDistributor.onBatchStart(this);
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			distributeErrorEvent(exception.getCause());
		}
	}
	
	/**
	 * Distributes a batch update event and a batch error event if a listener threw an
	 * exception.
	 */
	private function distributeUpdateEvent(Void):Void {
		try {
			var updateDistributor:BatchUpdateListener = distributorControl.getDistributor(BatchUpdateListener);
			updateDistributor.onBatchUpdate(this);
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			distributeErrorEvent(exception.getCause());
		}
	}
	
	/**
	 * Distributes a batch update event.
	 * 
	 * @see #distributeUpdateEvent
	 */
	private function distributePauseEvent(Void):Void {
		distributeUpdateEvent();
	}
	
	/**
	 * Distributes a batch update event.
	 * 
	 * @see #distributeUpdateEvent
	 */
	private function distributeResumeEvent(Void):Void {
		distributeUpdateEvent();
	}
	
	/**
	 * Distributes a batch error event with the given error.
	 * 
	 * @param error the error that occurred
	 * @return {@code true} to consume the event
	 */
	private function distributeErrorEvent(error):Boolean {
		addError(error);
		// TODO: 'result' does not work as expected!
		var result:Boolean = false;
		var errorDistributor:BatchErrorListener = distributorControl.getDistributor(BatchErrorListener);
		result = errorDistributor.onBatchError(this, error);
		if (!result && !hasFinished()) {
			finish();
		}
		return result;
	}
	
	/**
	 * Distributes a batch finish event and a batch error event if a listener threw an
	 * exception.
	 */
	private function distributeFinishEvent(Void):Void {
		try {
			var finishDistributor:BatchFinishListener = distributorControl.getDistributor(BatchFinishListener);
			finishDistributor.onBatchFinish(this);
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			distributeErrorEvent(exception.getCause());
		}
	}
	
}