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

import org.as2lib.env.out.OutHandler;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicInterface;

/**
 * OutLevel is the basic interface for all OutLevels. OutLevels in a descending
 * order are: AllLevel, DebugLevel, InfoLevel, WarningLevel, ErrorLevel, FatalLevel.
 * OutLevels are used to determine if a specific output will be made or not. If you
 * for example set the OutLevel to AllLevel all output will be made. If you set the
 * OutLevel to InfoLevel then info, warning, error and fatal output will be made.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
interface org.as2lib.env.out.OutLevel extends BasicInterface {
	/**
	 * Outputs a message.
	 *
	 * @param message the message to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function log(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Outputs a message.
	 *
	 * @param message the message to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function debug(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Outputs a message.
	 *
	 * @param message the message to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function info(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Outputs a message.
	 *
	 * @param message the message to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function warning(message:String, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Outputs a Throwable.
	 *
	 * @param throwable the Throwable to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function error(exception:Throwable, broadcaster:EventBroadcaster):Void;
	
	/**
	 * Outputs a Throwable.
	 *
	 * @param throwable the Throwable to be written out
	 * @param broadcaster the EventBroadcaster used to dispatch to all handlers
	 */
	public function fatal(exception:Throwable, broadcaster:EventBroadcaster):Void;
}