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

import org.as2lib.env.overload.Overload;
import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.app.exec.Call;
import org.as2lib.app.exec.Executable;
import org.as2lib.app.exec.FrameImpulse;

/**
 * {@code Timeout} works as 
 * 
 * @author Martin Heidegger
 * @version 1.0
 * @see Executable#execute
 */
class org.as2lib.app.exec.Timeout extends AbstractProcess implements Executable {
	
	/**  */
	private var exe:Executable;
	
	/**  */
	private var frames:Number;
	
	/**  */
	private var executed:Number;
	
	/** List of the targets for the execution. */
	private var target:Array;
	
	/**  */
	private var timeCall:Call;
	
	/**
	 * 
	 */
	public function Timeout(Void) {
		timeCall = new Call(this, onEnterFrame);
		var o:Overload = new Overload(this);
		o.addHandler([Executable, Number], setExecutable);
		o.addHandler([Object, Function, Number], setExecutableByObjectAndFunction);
		o.forward(arguments);
	}
	
	public function setExecutable(exe:Executable, frames:Number):Void {
		this.exe = exe;
		this.frames = frames;
	}
	
	public function setExecutableByObjectAndFunction(inObject:Object, func:Function, frames:Number):Void {
		setExecutable(new Call(inObject, func), frames);
	}
	
	private function onEnterFrame() {
		if (executed++ > frames) {
			finalExecution();
		}
	}
	
	public function execute() {
		executed = 1;
		if (!target) target = new Array();
		target.push(arguments);
		FrameImpulse.connect(timeCall);
		pause();
		return null;
	}
	
	public function run() {
		execute.apply(this, arguments);
	}
	
	private function finalExecution(Void):Void {
		executed = 1;
		var i:Number;
		FrameImpulse.disconnect(timeCall);
		var oldTarget = target.concat();
		target = new Array();
		for (i=0; i<oldTarget.length; i++) {
			exe["execute"].apply(exe, oldTarget[i]);
		}
		resume();
		finish();
	}
	
	public function forEach(object):Void {
		executed = 0
		if (!target) target = new Array();
		var i:String;
		for (i in object) {
			target.push([object[i], i, object]);
			execute();
		}
		FrameImpulse.connect(timeCall);
	}
}