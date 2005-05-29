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

import org.as2lib.core.BasicClass;
import org.as2lib.app.exec.Executable;
import org.as2lib.app.exec.Impulse;
import org.as2lib.env.except.FatalException;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.util.ArrayUtil;

/**
 * {@code FrameImpulse} is a implementation of {@link Impulse} for a impulse
 * that gets executed at a the Frame {@code onEnterFrame} event.
 * 
 * <p>{@code FrameImpulse} supports static methods for easy connecting to a
 * FrameImpulse.
 * 
 * Example:
 * <code>
 *   import org.as2lib.app.exec.FrameImpulse;
 *   import org.as2lib.app.exec.Executable;
 *   
 *   class com.domain.FrameTracer implements Executable {
 *   
 *      private var prefix:String;
 *      
 *      private var postfix:String;
 *      
 *      public function FrameTrigger(prefix:String, postfix:String) {
 *      	this.prefix = prefix;
 *      	this.postfix = postfix;
 *      	FrameImpulse.connect(this);
 *      }
 *      
 *      public function execute() {
 *      	trace(prefix+_root._currentframe+postfix);
 *      }
 *   }
 *   
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.app.exec.FrameImpulse extends BasicClass implements Impulse {
	
	/** Holder for the static instance */
	private static var instance:FrameImpulse;
	
	/**
	 * Connects a certain executable as listener to the impulse.
	 * <p>The Impulse will call {@code execute} on a frame change.
	 * 
	 * @param exe Executable to be connected to the Impulse
	 */
	public static function connect(exe:Executable):Void {
		getInstance().connectExecutable(exe);
	}
	
	/**
	 * Disconnects a {@link Executable} from listening to the impulse.
	 * 
	 * @param exe {@link Executable} to disconnect.
	 */
	public static function disconnect(exe:Executable):Void {
		getInstance().disconnectExecutable(exe);
	}
	
	
	/**
	 * Validates if a certain {@link Executable} is currently connected to the
	 * impulse.
	 * 
	 * @param exe {@link Executable} to be validated.
	 * @return {@code true} if the certain executable is connected.
	 */
	public static function isConnected(exe:Executable):Void {
		getInstance().isExecutableConnected(exe);
	}
	
	/**
	 * Getter for a instance of a FrameImpulse.
	 * <p>Generates a new FrameImpulse if no FrameImpulse has been set.
	 * 
	 * @return {@code FrameImpulse} instance.
	 */
	public static function getInstance(Void):FrameImpulse {
		if(!instance) instance = new FrameImpulse();
		return instance;
	}
	
	/** Holder for the timeline to the FrameImpulse */
	private var timeline:MovieClip;
	
	/** List of the connected Executables */
	private var connectedExecutables:Array;
	
	/** 
	 * Flag if the timeline is generated and should be destroyed after
	 * replacement.
	 */
	private var timelineIsGenerated:Boolean;
	
	/**
	 * Creates a new FrameImpulse instance.
	 * 
	 * @param timeline Timeline to be used - see: {@link #setTimeline}
	 */
	private function FrameImpulse(timeline:MovieClip) {
		connectedExecutables = new Array();
		setTimeline(timeline);
	}
	
	/**
	 * Connects a executable as listener to the frame execution.
	 * 
	 * @param exe Executable to be added as listener
	 */
	public function connectExecutable(exe:Executable):Void {
		if (!isExecutableConnected(exe)) {
			connectedExecutables.push(exe);
		}
	}
	
	/**
	 * Disconnects a {@link Executable} from listening to the impulse.
	 * 
	 * @param exe {@link Executable} to disconnect.
	 */
	public function disconnectExecutable(exe:Executable):Void {
		ArrayUtil.removeElement(connectedExecutables, exe);
	}
	
	/**
	 * Validates if a certain {@link Executable} is currently connected to the
	 * impulse.
	 * 
	 * @param exe {@link Executable} to be validated.
	 * @return {@code true} if the certain executable is connected.
	 */
	public function isExecutableConnected(exe:Executable):Boolean {
		return ArrayUtil.contains(connectedExecutables, exe);
	}
	
	/**
	 * 
	 * @param timeline Timeline to be used
	 */
	public function setTimeline(timeline:MovieClip):Void {
		var c:Array = connectedExecutables;
		if (timeline != null) {
			if (timeline.onEnterFrame === undefined) {
				
				if (this.timeline) {
					if(timelineIsGenerated) {
						this.timeline.removeMovieClip();
					}
					delete this.timeline.onEnterFrame;
					timelineIsGenerated = false;
				}
				
				this.timeline = timeline;
				timeline.onEnterFrame = function() {
					var i:Number = c.length;
					while (--i-(-1)) {
						c[i].execute();
					}
				}
				
			} else {
				throw new IllegalArgumentException("onEnterFrame method in "
												   +timeline
												   +" has already been overwritten",
												   this,
												   arguments);
			}
		} else {
			timeline = null;
			getTimeline();
		}
	}
	
	/**
	 * Getter for the currently listening timeline.
	 * 
	 * <p>This method creates a new timeline in root and listenes to it if no
	 * timeline has been set.
	 * 
	 * @return Currently listening timeline
	 */
	public function getTimeline(Void):MovieClip {
		if (!timeline) {
			var name:String = ReflectUtil.getUnusedMemberName(_root);
			if (!name) {
				throw new FatalException("Could not get a free instance name with"
				                        +" ObjectUtil.getUnusedChildName(_root),"
				                        +" to create a listenercontainer.",
				                        this,
				                        arguments);
			}
			var mc:MovieClip = _root.createEmptyMovieClip(name,
														  _root.getNextHighestDepth());
			if (mc) {
				setTimeline(mc);
			} else {
				throw new FatalException("Could not generate a timeline for "
										 +"impulse generation", this, arguments);
			}
			var timelineIsGenerated = true;
		}
		return timeline;
	}
}