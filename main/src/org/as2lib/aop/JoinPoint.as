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
import org.as2lib.env.reflect.TypeMemberInfo;

/**
 * JoinPoint represents an identifiable point in a program. Although
 * this points could also be try..catch blocks the join points offered
 * by this framework are limited to members of classes or interfaces.
 * Refer to http://www.simonwacker.com/blog/archives/000041.php for a
 * description of join points in AOP terms.
 *
 * @author Simon Wacker
 */
interface org.as2lib.aop.JoinPoint extends BasicInterface {
	
	/**
	 * Returns the TypeMemberInfo instance, that represents the join
	 * point. The TypeMemberInfo class is part of the as2libs Reflection
	 * API.
	 *
	 * @return the TypeMemberInfo representing the static part of the join point
	 */
	public function getInfo(Void):TypeMemberInfo;
	
	/**
	 * Executes the type member represented by this join point, passing the
	 * arguments and returns the result.
	 *
	 * @param args the arguments to be passed with the method call
	 * @return the result of the method execution
	 */
	public function proceed(args:Array);
	
	/**
	 * Returns the object where this join point resides on.
	 *
	 * @return the object this join point resides on
	 */
	public function getThis(Void);
	
	/**
	 * Returns a clone of this JoinPoint with the up-to-date type
	 * member.
	 *
	 * @return a clone of this JoinPoint with a up-to-date type member
	 */
	public function clone(Void):JoinPoint;
	
	/**
	 * Returns the type of the join point. This can for example be
	 * AbstractJoinPoint.TYPE_METHOD.
	 *
	 * @return the type of the join point represented by a number
	 */
	public function getType(Void):Number;
	
	/**
	 * Checks if the join point matches the given pattern. The pattern
	 * can contain wildcards like '*' or '..'. A pattern could for example
	 * be 'org..BasicClass.*'.
	 * Refer to http://www.simonwacker.com/blog/archives/000053.php for
	 * an explanation of possible wildcards. Note the the '?' wildcard is
	 * not supported.
	 *
	 * @param pattern the pattern to be matched against this join point
	 */
	public function matches(pattern:String):Boolean;
	
}