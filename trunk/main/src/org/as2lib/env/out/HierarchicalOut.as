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

import org.as2lib.env.out.OutAccess;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.out.HierarchicalOut extends OutAccess {
	
	/**
	 * @return the parent of this Out instance, it may be set via #setParent()
	 */
	public function getParent(Void):HierarchicalOut;
	
	/**
	 * Sets the parent of this Out instance. The parent is used to obtain the
	 * level if none is specifically set for this instance.
	 *
	 * @param parent the parent Out instance
	 */
	public function setParent(parent:HierarchicalOut):Void;
	
	/**
	 * @return the name of this Out instance
	 */
	public function getName(Void):String;
	
	/**
	 * @return all registered OutHandlers
	 */
	public function getAllHandler(Void):Array;
	
}