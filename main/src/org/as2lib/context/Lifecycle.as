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
interface org.as2lib.context.Lifecycle extends BasicInterface {
	
	/**
	 * Starts this component.
	 * 
	 * <p>Should not throw an exception if the component is already running.
	 * 
	 * <p>In the case of a container, this will propagate the start signal to all
	 * components that apply.
	 */
	public function start(Void):Void;

	/**
	 * Stops this component.
	 * 
	 * <p>Should not throw an exception if the component isn't started yet.
	 * 
	 * <p>In the case of a container, this will propagate the stop signal to all
	 * components that apply.
	 */
	public function stop(Void):Void;

	/**
	 * Returns whether this component is running.
	 * 
	 * <p>In the case of a container, this will return {@code true} only if <i>all</i>
	 * components that apply are running.
	 * 
	 * @return {@code true} if this component is running, else {@code false}
	 */
	public function isRunning(Void):Boolean;
	
}