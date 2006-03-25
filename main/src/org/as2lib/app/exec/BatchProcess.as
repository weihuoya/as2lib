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
class org.as2lib.app.exec.BatchProcess extends AbstractBatch implements ProcessUpdateListener, ProcessErrorListener {
	
	/**
	 * Constructs a new {@code BatchProcess} instance.
	 */
	public function BatchProcess(Void) {
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
		// TODO: 'result' is always 'null' because distributers do not return values!
		var result:Boolean = super.distributeErrorEvent(error);
		if (!result && !hasFinished()) {
			finish();
		}
		return result;
	}
	
}