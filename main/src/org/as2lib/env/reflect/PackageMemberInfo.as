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

import org.as2lib.env.reflect.MemberInfo;
import org.as2lib.env.reflect.PackageInfo;

/**
 * PackageMemberInfo is the super interface for members of packages.
 *
 * <p>Members of packages are classes, interfaces and packages themselves.
 *
 * <p>Accoring to this classes and interfaces can be seen as leafs in
 * a compositional structure and packages as composites. This design
 * pattern is known under the name Composite.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.PackageMemberInfo extends MemberInfo {
	
	/**
	 * Returns the full name of the package member.
	 * 
	 * <p>A full qualified name is a name that consists of the members
	 * name as well as its path.
	 *
	 * @return the full name of the package member
	 */
	public function getFullName(Void):String;
	
	/**
	 * Returns teh parent of the package member.
	 *
	 * <p>The parent is the package this package member is a member
	 * of / resides in.
	 *
	 * @return the parent of this package member
	 */
	public function getParent(Void):PackageInfo;
	
}