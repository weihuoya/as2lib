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

import org.as2lib.bean.Mergeable;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Properties;

/**
 * {@code ManagedProperties} represents a properties that may be merged with a parent
 * properties.
 * 
 * <p>Note that this {@code Properties} implementation implements only the {@code setProp},
 * {@code getKeys} and {@code getValues} methods.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ManagedProperties extends BasicClass implements Properties, Mergeable {
	
	/** All set keys. */
	private var keys:Array;
	
	/** All set values. */
	private var values:Array;
	
	/** Is mergin enabled? */
	private var mergeEnabled:Boolean;
	
	/**
	 * Constructs a new {@code ManagedProperties} instance.
	 */
	public function ManagedProperties(Void) {
		keys = new Array();
		values = new Array();
	}
	
	public function isMergeEnabled(Void):Boolean {
		return mergeEnabled;
	}
	
	public function setMergeEnabled(mergeEnabled:Boolean):Void {
		this.mergeEnabled = mergeEnabled;
	}
	
	public function merge(parent):Void {
		if (parent instanceof Properties) {
			var parentProperties:Properties = parent;
			keys = parentProperties.getKeys().concat(keys);
			values = parentProperties.getValues().concat(values);
		}
	}
	
	public function setProp(key:String, value:String):Void {
		keys.push(key);
		values.push(value);
	}
	
	public function getKeys(Void):Array {
		return keys;
	}
	
	public function getValues(Void):Array {
		return values;
	}
	
	public function getProp(key:String, defaultValue:String):String {
		return null;
	}
	
	public function putAll(source:Properties):Void {
	}
	
	public function clear(Void):Void {
	}
	
}