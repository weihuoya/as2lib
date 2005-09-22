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
import org.as2lib.io.file.File;
import org.as2lib.io.file.FileLoader;

/**
 * {@code FileListener} is the definition for all events that may occur during a
 * {@code FileLoader} process.
 * 
 * <p>Every {@code FileLoader} has to provide events to handle the different
 * states of the execution. All events will be broadcasted to {@code FileListener}
 * implementations.
 * 
 * @author Martin Heidegger
 * @version 2.0
 * @see FileLoader
 */
interface org.as2lib.io.file.FileListener extends BasicInterface {
	
	/**
	 * Event to be published if the {@code FileLoader} started a request.
	 * 
	 * @param fileLoader {@code FileLoader that was started
	 */
	public function onFileStartLoading(fileLoader:FileLoader):Void ;
	
	/**
	 * Event to be published if the file was not found.
	 * 
	 * @param uri location of the file that was requested 
	 */
	public function onFileNotFound(uri:String):Void;
	
	/**
	 * Event to be published if the percentage of the loaded process changes.
	 * 
	 * @param fileLoader {@code FileLoader} that executes the request
	 */
	public function onFileProgress(fileLoader:FileLoader):Void;
	
	/**
	 * Event to be published if the resource finished loading.
	 * 
	 * <p>This event will only occur after the {@code FileLoader} was started.
	 * 
	 * <p>This event will not occur if the resource was not available.
	 * 
	 * @param file {@code File} that represents the loaded resource
	 */
	public function onFileLoad(file:File):Void;
}