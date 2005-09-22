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
import org.as2lib.io.file.ResourceLoader;

/**
 * {@code ResourceListener} is the definition for all events that may occur during a
 * {@code ResourceLoader} process.
 * 
 * <p>Every {@code ResourceLoader} has to provide events to handle the different
 * states of the execution. All events will be broadcasted to {@code ResourceListener}
 * implementations.
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.io.file.ResourceListener extends BasicInterface {
	
	/**
	 * Event to be published if the {@code ResourceLoader} started a request.
	 * 
	 * @param resourceLoader {@code ResourceLoader} that was started
	 */
	public function onResourceStartLoading(resourceLoader:ResourceLoader):Void;
	
	/**
	 * Event to be published if the resource was not found.
	 * 
	 * @param uri location of the resource that was requested 
	 */
	public function onResourceNotFound(uri:String):Void;
	
	/**
	 * Event to be published if the percentage of the loaded process changes.
	 * 
	 * @param resourceLoader {@code ResourceLoader} that executes the request
	 */
	public function onResourceProgress(resourceLoader:ResourceLoader):Void;
	
	/**
	 * Event to be published if the resource finished loading.
	 * 
	 * <p>This event will only occur after the {@code ResourceLoader} was started.
	 * 
	 * <p>This event will not occur if the resource was not available.
	 * 
	 * @param resourceLoader {@code ResourceLoader} that contains the requested resource
	 */
	public function onResourceLoad(resourceLoader:ResourceLoader):Void;
}