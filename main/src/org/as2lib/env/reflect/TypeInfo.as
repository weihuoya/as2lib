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

import org.as2lib.env.reflect.CompositeMemberInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.TypeMemberFilter;

/**
 * TypeInfo represents a type in the Flash environment. That means either a
 * class or an interface.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.TypeInfo extends CompositeMemberInfo {
	
	/**
	 * Returns the type this TypeInfo instance represents.
	 *
	 * @return the type represented by this instance
	 */
	public function getType(Void):Function;
	
	/**
	 * Returns the super types's TypeInfo instance.
	 * 
	 * @return the super types's TypeInfo instance
	 */
	public function getSuperType(Void):TypeInfo;
	
	/**
	 * @overload #getMethodsByFlag(Boolean):Array
	 * @overload #getMethodsByFilter(TypeMemberFilter):Array
	 */
	public function getMethods():Array;
	
	/**
	 * Returns an array containing the methods represented by MethodInfos
	 * this type declares and maybe the ones of the super types.
	 *
	 * <p>The super types' methods are included if you pass-in false, null
	 * or undefined and excluded/filtered if you pass-in true.
	 *
	 * @param filterSuperTypes (optional) determines whether the super types'
	 * methods shall be excluded, that means filtered (true) or included (false)
	 * @return an array containing the methods
	 */
	public function getMethodsByFlag(filterSuperTypes:Boolean):Array;
	
	/**
	 * Returns an array containing the methods represented by MethodInfos
	 * this type and super types' declare that do not get filtered/excluded.
	 *
	 * <p>The TypeMemberFilter#filter(TypeMemberInfo):Boolean gets invoked
	 * for every method to determine whether it shall be contained in the 
	 * result.
	 *
	 * @param methodFilter the filter that filters unwanted methods out
	 * @return an array containing the remaining methods
	 */
	public function getMethodsByFilter(methodFilter:TypeMemberFilter):Array;
	
	/**
	 * @overload #getMethodByName(String)
	 * @overload #getMethodByMethod(Function)
	 */
	public function getMethod(method):MethodInfo;
	
	/**
	 * Returns the MethodInfo corresponding to the passed method name.
	 *
	 * @param methodName the name of the method you wanna obtain
	 * @return the MethodInfo correspoinding to the method name
	 */
	public function getMethodByName(methodName:String):MethodInfo;
	
	/**
	 * Returns the MethodInfo corresponding to the passed method.
	 *
	 * @param method the method you wanna obtain the corresponding MethodInfo
	 * @return the MethodInfo correspoinding to the method
	 */
	public function getMethodByMethod(concreteMethod:Function):MethodInfo;
	
}