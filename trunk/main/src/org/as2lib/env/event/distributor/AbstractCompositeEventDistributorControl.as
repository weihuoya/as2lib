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

import org.as2lib.util.ArrayUtil;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.event.distributor.CompositeEventDistributorControl;
import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.event.distributor.EventDistributorControlFactory;

/**
 * {@code AbstractEventDistributorControl} offers default implementations of
 * methods needed when implementing the {@link EventDistributorControl} interface
 * or any sub-interface.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.env.event.distributor.AbstractCompositeEventDistributorControl implements CompositeEventDistributorControl {
	
	private var f:EventDistributorControlFactory;
	private var l:Array;
	// DistributorControlMap
	private var m:Map;
	
	public function AbstractCompositeEventDistributorControl(factory:EventDistributorControlFactory) {
		f = factory;
		m = new HashMap();
		l = new Array();
	}
	
	public function addListener(l):Void {
		if (!hasListener(l)) {
			var k:Array = m.getKeys();
			var v:Array = m.getValues();
			var i:Number;
			var added:Boolean;
			for (i=0; i<k.length; i++) {
				if(l instanceof k[i]) {
					v[i].addListener(l);
					added = true;
				}
			}
			if (added) {
				this.l.push(l);
			} else {
				var message:String = "Passed listener ["+ReflectUtil.getTypeNameForInstance(l)+"] doesnt match any of the supported listener types ";
				var size:Number = m.size();
				if (size > 0) {
					message += "("+m.size()+"):";
				} else {
					message += "(No types defined).";
				}
				var iter:Iterator = m.keyIterator();
				while (iter.hasNext()) {
					message += "\n - "+ReflectUtil.getTypeNameForType(iter.next());
				}
				throw new IllegalArgumentException(message, this, arguments);
			}
		}
	}
	
	public function removeListener(l):Void {
		if (hasListener(l)) {
			var k:Array = m.getKeys();
			var v:Array = m.getValues();
			var i:Number;
			for (i=0; i<k.length; i++) {
				if (l instanceof k[i]) {
					v[i].removeListener(l);
				}
			}
			ArrayUtil.removeElement(this.l, l);
		}
	}
	
	public function addAllListeners(list:Array):Void {
		for (var i=0; i<list.length; i++) {
			addListener(list[i]);
		}
	}
	
	public function removeAllListeners(Void):Void {
		var i:Number;
		var list:Array = l;
		for (i=0; i<list.length; i++) {
			removeListener(list[i]);
		}
	}
	
	public function getAllListeners(Void):Array {
		return l.concat();
	}
	
	public function hasListener(listener):Boolean {
		return ArrayUtil.contains(l, listener);
	}
	
	public function acceptListenerType(type:Function):Void {
		if (!m.get(type)) {
			var distri:EventDistributorControl = f.createEventDistributorControl(type);
			var i:Number;
			for (i=0; i<l.length; i++) {
				if (l[i] instanceof type) {
					distri.addListener(l[i]);
				}
			}
			m.put(type, distri);
		}
	}
	
	public function getDistributor(type:Function) {
		var distri:EventDistributorControl = m.get(type);
		if (distri === null  || distri === undefined) {
			throw new IllegalArgumentException(ReflectUtil.getTypeName(type)+" is no supported distributor type", this, arguments);
		}
		return distri.getDistributor(type);
	}
	
	public function setEventDistributorControl(eventDistributorControl:EventDistributorControl):Void  {
		if (eventDistributorControl != null) {
			var i:Number;
			var type:Function = eventDistributorControl.getType();
			eventDistributorControl.removeAllListeners();
			for (i=0; i<l.length; i++) {
				if (l[i] instanceof type) {
					eventDistributorControl.addListener(l[i]);
				}
			}	
			m.put(type, eventDistributorControl);
		} else {
			throw new IllegalArgumentException("distributorControl is not of any possible type.", this, arguments);
		}
	}
	
	public function setDefaultEventDistributorControl(type:Function):Void {
		var control:EventDistributorControl = m.remove(type);
		if (control === undefined || control === null) {
			throw new IllegalArgumentException(ReflectUtil.getTypeNameForType(type)+" is not accepted as listener type", this, arguments);
		}
		acceptListenerType(type);
	}
}