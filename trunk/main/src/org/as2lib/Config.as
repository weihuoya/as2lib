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

import org.as2lib.env.out.Out;
import org.as2lib.env.out.OutAccess;
import org.as2lib.env.out.handler.TraceHandler;
import org.as2lib.env.event.EventBroadcasterFactory;
import org.as2lib.env.event.SimpleEventBroadcasterFactory;

/**
 * Basic configuration class for all classes.
 * The configurations out of this file will be used if subconfigurations wont overwrite it.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.Config {
	/** The OutAccess instance basically used by all classes to do their output. */
	private static var out:OutAccess;
	
	/** Internal holder for the EventBroadcasterFactory */
	private static var eventBroadcasterFactory:EventBroadcasterFactory;
	
	/**
	 * Sets a new OutAccess instance.
	 *
	 * @param out the new OutAcces instance
	 */
	public static function setOut(to:OutAccess):Void {
		out = to;
	}
	
	/**
	 * Returns the OutAccess instance currently used.
	 * If out wasn't set before or was set to null it will initialize a new Out instance and
	 * adds a TraceOutputHandler.
	 *
	 * @see TraceOutputHandler
	 * @see Out
	 * @return the OutAccess instance used
	 */
	public static function getOut(Void):OutAccess {
		if(!out) {
			out = new Out();
			Out(out).addHandler(new TraceHandler());
		}
		return out;
	}
	
	/**
	 * Sets a EventBroadcasterFactory for this path.
	 * If out wasn't set before or was set to null it will initialize a new Out instance.
	 * 
	 * @param to EventBroadcastorFactory that should be used.
	 */
	public static function setEventBroadcasterFactory(to:EventBroadcasterFactory):Void {
		eventBroadcasterFactory = to;
	}
	
	/**
	 * Returns the config value for the EventBroadcasterFactory.
	 * 
	 * @return The config value for the EventBroadcasterFactory
	 */
	public static function getEventBroadcasterFactory(Void):EventBroadcasterFactory {
		if(!eventBroadcasterFactory) {
			eventBroadcasterFactory = new SimpleEventBroadcasterFactory();
		}
		return eventBroadcasterFactory;
	}
}