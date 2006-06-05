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

import org.as2lib.app.exec.Batch;
import org.as2lib.core.BasicInterface;

/**
 * {@code NextProcessListener} can be added to batches to get informed when the next
 * process was started.
 *
 * @author Simon Wacker
 */
interface org.as2lib.app.exec.NextProcessListener extends BasicInterface {

	/**
	 * Is executed when the next process was started.
	 *
	 * @param batch the batch which started the next process
	 * @see Batch#getCurrentProcess
	 */
	public function onNextProcess(batch:Batch):Void;

}