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
interface org.as2lib.bean.factory.InitializingBean extends BasicInterface {
	
	/**
	 * Invoked by a bean factory after it has set all bean properties supplied (and
	 * satisfied {@link BeanFactoryAware} and {@link ApplicationContextAware}).
	 * 
	 * <p>This method allows the bean instance to perform initialization only possible
	 * when all bean properties have been set and to throw an exception in the event of
	 * misconfiguration.
	 * 
	 * @throws Error in the event of misconfiguration (such as failure to set an
	 * essential property) or if initialization fails
	 */
	public function afterPropertiesSet(Void):Void;
	
}