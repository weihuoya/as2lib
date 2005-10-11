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

import org.as2lib.app.exec.Process;

/**
 * {@code ProcessStartListener} is a defintion for a Observer of the start of a
 * {@link Process}.
 * 
 * <p>To observe the start of a process you can implement this interface and add your
 * implementation with {@link Process#addListener} to a observe a certain
 * process.
 * 
 * @author Martin Heidegger
 * @version 1.0
 * @see Process
 */
interface org.as2lib.app.exec.ProcessStartListener {
	/**
	 * Method to be executed if a process starts execution.
	 * 
	 * @param process {@link Process} that started execution
	 */
	public function onStartProcess(process:Process):Void;
}