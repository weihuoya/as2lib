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

import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.ConsumableEventInfo;

/**
 * Allows to consume a broadcasted event.
 * This allows to stop a Eventbroadcaster during the execution by the implementation
 * of a element. Therefore it is possible to 
 * 
 * <p>Example:
 * 
 * Useage:
 * <code>
 *   import org.as2lib.env.event.ConsumableEventBroadcaster;
 *   import org.as2lib.env.event.SimpleEventBroadcaster;
 *   import org.as2lib.env.event.ConsumableEventInfo;
 *   import org.as2lib.env.event.SimpleConsumableEventInfo;
 *   
 *   // Should usualy be a implementation detail of a class.
 *   var eb:ConsumableEventBroadcaster = new SimpleEventBroadcaster();
 *   eb.addListener(new MainListener());
 *   eb.addListener(new SubListener());
 * 
 *   // 
 *   var info:ConsumableEventInfo = new SimpleConsumableEventInfo("onLoad");
 *   eb.dispatch(info);
 *   eb.dispatch(info);
 * </code>
 *
 * MainListener:
 * <code>
 *   import org.as2lib.env.event.SimpleConsumableEventListener;
 *   import org.as2lib.env.event.SimpleConsumableEventInfo;
 *
 *   class MainListener extends SimpleConsumableEventListener { 
 *      private var times:Number;
 *      public function MainListener() {
 *          times = 0;
 *      }
 *      public function onLoad(info:ConsumableEventInfo) {
 *          if(times > 0) {
 *             // breaks executing after the first call
 *             info.consume();
 *          }
 *          trace("MainListener called.");
 *          times++;
 *      }
 *   }
 * </code>
 *
 * SubListener:
 * <code>
 *   import org.as2lib.env.event.SimpleConsumableEventListener;
 *   import org.as2lib.env.event.SimpleConsumableEventInfo;
 *
 *   class SubListener extends SimpleConsumableEventListener { 
 *      public function SubListener() {
 *      }
 *      public function onLoad(info:ConsumableEventInfo) {
 *          trace("SubListener called.");
 *      }
 *   }
 * </code>
 * 
 * Output:
 * <pre>
 *   MainListener called.
 *   SubListener called.
 *   MainListener called.
 * </pre>
 *
 * @author Martin Heidegger
 */
interface org.as2lib.env.event.ConsumableEventBroadcaster extends EventBroadcaster {
	
	/**
	 * Dispatches the events associated with the name contained in the
	 * EventInfo instance.
	 * 
	 * @param event the EventInfo to be passed to the operation of the EventListeners
	 */
	public function dispatchConsumable(event:ConsumableEventInfo):Void;
	
	/*
	public function executeAscending(Void):Void;
	
	public function executeDescending(Void):Void;

	public function isExecutingAscending(Void):Boolean;
	
	public function isExecutingDescending(Void):Boolean;
	*/
}