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

import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.data.holder.Map;

/**
 * CacheInfo is the interface for classes residing in the Cache.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.CacheInfo {
	/**
	 * Returns the name of the entity this CacheInfo represents.
	 *
	 * @return the name of the entity
	 */
	public function getName(Void):String;
	
	/**
	 * Returns the full name of the entity this CacheInfo represents. The full
	 * name includes the name as well as the path.
	 *
	 * @return the full name of the entity
	 */
	public function getFullName(Void):String;
	
	/**
	 * Returns the parent of the entity represented by a PackageInfo. The parent
	 * is the package the entity resieds in.
	 *
	 * @return the parent
	 */
	public function getParent(Void):PackageInfo;
	
	/**
	 * Returns a Map containing the children of the entity.
	 *
	 * @return the children of the entity
	 */
	public function getChildren(Void):Map;
}