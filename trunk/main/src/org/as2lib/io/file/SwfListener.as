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

import org.as2lib.io.file.SwfLoader;
import MovieClip;
import org.as2lib.core.BasicInterface;

/**
 * {@code SwfListener} is the definition for all events that may occur during a
 * {@code SwfLoader} process.
 * 
 * <p>{@code SwfLoader} provides events to handle the different states of the
 * execution. All events will be broadcasted to {@code SwfListener} implementations.
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.io.file.SwfListener extends BasicInterface {
	
	/**
	 * Event to be published if the {@code SwfLoader} started a request.
	 * 
	 * @param swfLoader {@code SwfLoader} that was started
	 */
	public function onSwfStartLoading(swfLoader:SwfLoader):Void;
	
	/**
	 * Event to be published if the swf was not found.
	 * 
	 * @param uri location of the swf that was requested 
	 */
	public function onSwfNotFound(url:String):Void;
	
	/**
	 * Event to be published if the percentage of the loaded process changes.
	 * 
	 * @param swfLoader {@code SwfLoader} that executes the request
	 */
	public function onSwfProgress(swfLoader:SwfLoader):Void;
	
	/**
	 * Event to be published if the swf finished loading.
	 * 
	 * <p>This event will only occur after the {@code SwfLoader} was started.
	 * 
	 * <p>This event will not occur if the swf was not available.
	 * 
	 * @param movieClip {@code MovieClip} instance that was loaded
	 */
	public function onSwfLoad(movieClip:MovieClip):Void;
}