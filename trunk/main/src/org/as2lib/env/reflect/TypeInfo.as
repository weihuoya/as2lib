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
import org.as2lib.data.holder.Map;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.CompositeMemberInfo;

/**
 * TypeInfo represents a type in the Flash environment. That means either a
 * class or an interface.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.TypeInfo extends CompositeMemberInfo {
	/**
	 * Returns the type this TypeInfo represents.
	 *
	 * @return the type represented by this TypeInfo
	 */
	public function getRepresentedType(Void):Function;
	
	/**
	 * Returns the super types's TypeInfo.
	 * 
	 * @return the super types's TypeInfo
	 */
	public function getSuperType(Void):TypeInfo;
	
	/**
	 * Returns the parent of the type. The parent is the package represented
	 * by a PackageInfo the type resides in.
	 *
	 * @return the parent of the type
	 */
	public function getParent(Void):PackageInfo;
	
	/**
	 * Returns a Map containing the operations represented by MethodInfos
	 * the type has.
	 *
	 * @return a Map containing MethodInfos representing the operations
	 */
	public function getMethods(Void):Map;
	
	/**
	 * Overload
	 * #getMethodByName()
	 * #getMethodByMethod()
	 */
	public function getMethod(method):MethodInfo;
	
	/**
	 * Returns the MethodInfo corresponding to the passed method name.
	 *
	 * @param methodName the name of the method you wanna obtain
	 * @return the MethodInfo correspoinding to the method name
	 * @throws org.as2lib.env.reflect.NoSuchTypeMemberException if the method you tried to obtain does not exist
	 */
	public function getMethodByName(methodName:String):MethodInfo;
	
	/**
	 * Returns the MethodInfo corresponding to the passed method.
	 *
	 * @param method the method you wanna obtain the corresponding MethodInfo
	 * @return the MethodInfo correspoinding to the method
	 * @throws org.as2lib.env.reflect.NoSuchTypeMemberException if the method you tried to obtain does not exist
	 */
	public function getMethodByMethod(concreteMethod:Function):MethodInfo;
}