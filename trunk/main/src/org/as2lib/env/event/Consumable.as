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

/**
 * The Consumable interface can be implemented by EventInfos.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
interface org.as2lib.env.event.Consumable {
	/**
	 * Marks the Consumable as consumed.
	 */
	public function consume(Void):Void;
	
	/**
	 * Returns whether the Consumable has already been consumed.
	 *
	 * @return true if the Consumable is marked as consumed else false
	 */
	public function isConsumed(Void):Boolean;
}