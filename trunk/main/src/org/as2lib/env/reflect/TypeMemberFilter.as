﻿/*
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

import org.as2lib.core.BasicInterface;
import org.as2lib.env.reflect.TypeMemberInfo;

/**
 * TypeMemberFilter gets used to filter the result of type members' searches.
 *
 * <p>You can pass it for example in the ClassInfo.getMethods(TypeMemberInfo)
 * method to receive only methods that match your criteria.
 *
 * <p>Using this filter can mean a performance boost. Refer to the specific
 * filter and search methods for more information.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.TypeMemberFilter extends BasicInterface {
	
	/**
	 * Returns true if the passed-in type member shall be filtered, that
	 * means excluded from the result.
	 *
	 * <p>This method slows the whole algorithm down because it gets invoked
	 * for every found type member that is not excluded by any of the other
	 * filter methods.
	 * So if you use it try to keep the checks simple.
	 *
	 * @param typeMember the type member to exclude or to include from the result
	 * @return true if the type member shall be excluded else false
	 */
	public function filter(typeMember:TypeMemberInfo):Boolean;
	
	/**
	 * Returns true if all static type members shall be filtered, that means
	 * excluded from the result.
	 *
	 * <p>Returning true can mean a performance boost because the algorithm
	 * does then not search for static type members.
	 *
	 * @return true if static type members shall be excluded else false
	 */
	//public function filterStatic(Void):Boolean;
	
	/**
	 * Returns true if all non-static type members shall be filtered, that
	 * means excluded from the result.
	 *
	 * <p>Returning true can mean a performance boost because the algorithm
	 * does then not search for non-static type members.
	 *
	 * @return true if non-static type members shall be excluded else false
	 */
	//public function filterNonStatic(Void):Boolean;
	
	/**
	 * Returns true if type members of super types shall be filtered, that
	 * means excluded from the result.
	 *
	 * <p>Returning true can mean a performance boost because the algorithm
	 * does then not search for type members of super types.
	 *
	 * @return true if super types' type members shall be excluded else false
	 */
	public function filterSuperTypes(Void):Boolean;
	
}