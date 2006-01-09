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
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.DisposableBean extends BasicInterface {
	
	/**
	 * Destroys a singleton bean.
	 * 
	 * <p>Invoked by a bean factory on destruction of a singleton.
	 * 
	 * @throws Error in case of shutdown errors; exceptions will not get rethrown to
	 * allow other beans to release their resources too
	 */
	public function destroy(Void):Void;
	
}