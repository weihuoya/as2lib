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

import org.as2lib.core.BasicInterface;

/**
 * Executable is used to execute multiple operations in one call and let the
 * executed functionality look like an atomic operation.
 * There may exist implementations that vary from this definition.
 *
 * @author Simon Wacker
 */
interface org.as2lib.util.Executable extends BasicInterface {
	/**
	 * Executes the wrapped functionality and let's it look like an atomic
	 * operation.
	 *
	 * @return the result of the execution
	 */
	public function execute(Void);
}