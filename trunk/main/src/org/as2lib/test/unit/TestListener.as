/**
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

import org.as2lib.env.event.EventListener;
import org.as2lib.test.unit.StartInfo;
import org.as2lib.test.unit.ProgressInfo;
import org.as2lib.test.unit.FinishInfo;
import org.as2lib.test.unit.PauseInfo;
import org.as2lib.test.unit.ResumeInfo;

/**
 * Listener definition for all Events available within @see org.as2lib.test.unit.TestRunner.
 * A Implementation of this interface can be added to a TestRunner instance.
 * 
 * @author Martin Heidegger
 */
interface org.as2lib.test.unit.TestListener extends EventListener {
	
	/**
	 * Start event, fired by start of a TestRunner.
	 * 
	 * @param startInfo Informations about the TestRunner that started.
	 */
	public function onStart(startInfo:StartInfo):Void;
	
	/**
	 * Progress event, fired after each executed method within a TestRunner.
	 * 
	 * @param progressInfo Extended informations the current progress.
	 */
	public function onProgress(progressInfo:ProgressInfo):Void;
	
	/**
	 * Finish event, fired after the execution of a TestRunner.
	 * 
	 * @param finishInfo Informations about the TestRunner that finished.
	 */
	public function onFinish(finishInfo:FinishInfo):Void;
	
	/**
	 * Pause event, fired after by pausing the execution of a TestRunner.
	 * 
	 * @param pauseInfo Informations about the TestRunner that paused.
	 */
	public function onPause(pauseInfo:PauseInfo):Void;
	
	/**
	 * Pause event, fired after by resuming the execution of a TestRunner.
	 * 
	 * @param resumeInfo Informations about the TestRunner that resumed working.
	 */
	public function onResume(resumeInfo:ResumeInfo):Void;
}