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

import org.as2lib.env.reflect.PackageMemberInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.TypeMemberFilter;
import org.as2lib.env.reflect.PackageInfo;

/**
 * TypeInfo represents a type in the Flash environment. That means either
 * a class or an interface.
 *
 * <p>Note that it is not possible right now to distinguish between
 * interfaces and classes at run-time. Therefore are both classes and
 * interfaces represented by ClassInfo instances. This is going to
 * change as soon is a differentiation is possible.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.TypeInfo extends PackageMemberInfo {
	
	/**
	 * Returns the type this TypeInfo instance represents.
	 *
	 * @return the type represented by this instance
	 */
	public function getType(Void):Function;
	
	/**
	 * Returns the super types's TypeInfo instance.
	 *
	 * <p>Talking of classes the super-type is the class's super-class, that
	 * means the class it extends and with interfaces its the interface's
	 * super-interface, that means the interface it extends.
	 *
	 * <p>A super-type is not an implemented interface. Note the difference
	 * between extending and implementing.
	 * 
	 * @return the super types's TypeInfo instance
	 */
	public function getSuperType(Void):TypeInfo;
	
	/**
	 * Returns the package this type, class or interface is declared
	 * in / resides in.
	 *
	 * @return the package this type is declared in / resides in
	 */
	public function getPackage(Void):PackageInfo;
	
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
	 * <p>Note that methods of interfaces cannot be evaluated at run-time.
	 * They thus have no declared methods for the reflection api.
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
	 * <p>If the passed-in methodFilter argument is null or undefined the
	 * result of an invocation of #getMethodsByFlag with argument false
	 * gets returned.
	 *
	 * <p>Note that methods of interfaces cannot be evaluated at run-time.
	 * They thus have no declared methods for the reflection api.
	 *
	 * @param methodFilter the filter that filters unwanted methods out
	 * @return an array containing the remaining methods
	 */
	public function getMethodsByFilter(methodFilter:TypeMemberFilter):Array;
	
	/**
	 * @overload #getMethodByName(String):MethodInfo
	 * @overload #getMethodByMethod(Function):MethodInfo
	 */
	public function getMethod():MethodInfo;
	
	/**
	 * Returns the method info corresponding to the passed-in method name.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in method name is null or undefined.</li>
	 *   <li>The method does not exist in the represented type or any super-type.</li>
	 * </ul>
	 *
	 * <p>Note that methods of interfaces cannot be evaluated at run-time.
	 * They thus have no declared methods for the reflection api.
	 *
	 * @param methodName the name of the method you wanna obtain
	 * @return the method info correspoinding to the method name
	 */
	public function getMethodByName(methodName:String):MethodInfo;
	
	/**
	 * Returns the method info corresponding to the passed-in concrete method.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in concrete method is null or undefined.</li>
	 *   <li>The method does not exist in the represented type or any super-type.</li>
	 * </ul>
	 *
	 * <p>Note that methods of interfaces cannot be evaluated at run-time.
	 * They thus have no declared methods for the reflection api.
	 *
	 * @param concreteMethod the method you wanna obtain the corresponding method info
	 * @return the method info correspoinding to the concrete method
	 */
	public function getMethodByMethod(concreteMethod:Function):MethodInfo;
	
}