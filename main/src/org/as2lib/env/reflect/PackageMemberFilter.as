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

import org.as2lib.core.BasicInterface;
import org.as2lib.env.reflect.PackageMemberInfo;

/**
 * PackageMemberInfo gets used to filter the result of searches for package
 * members, that are types and packages.
 *
 * <p>You can pass it for example in the PackageInfo.getMemberClasses or
 * PackageInfo.getMemberPackages methods to receive only classes or packages
 * that match your criteria.
 *
 * <p>Using this filter can mean a performance boost. Refer to the specific
 * filter and search methods for more information.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.PackageMemberFilter extends BasicInterface {
	
	/**
	 * Returns true if the passed-in package member shall be filtered, that
	 * means excluded from the result.
	 *
	 * <p>This method slows the whole algorithm down because it gets invoked
	 * for every found package member that is not excluded by any of the other
	 * filter methods.
	 * So if you use it try to keep the checks simple.
	 *
	 * @param packageMember the package member to exclude or to include from the result
	 * @return true if the package member shall be excluded else false
	 */
	public function filter(packageMember:PackageMemberInfo):Boolean;
	
	/**
	 * Returns true if package members of sub-packages shall be filtered,
	 * that means excluded from the result.
	 *
	 * <p>Returning true can mean a performance boost because the algorithm
	 * does then not search for package members of sub-packages.
	 *
	 * @return true if sub-packages' package members shall be excluded else false
	 */
	public function filterSubPackages(Void):Boolean;
	
}