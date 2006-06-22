/**
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
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.test.unit.ExecutionInfo;
import org.as2lib.util.StopWatch;
import org.as2lib.util.StringUtil;

/**
 * {@code TestCaseMethodInfo} contains information regarding the execution of a test
 * method.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.TestCaseMethodInfo extends BasicClass {

	/** Reflection information about this method. */
	private var methodInfo:MethodInfo;

	/** Stop watch used to measure the needed execution time. */
	private var stopWatch:StopWatch;

	/** Assertion information of the execution. */
	private var infos:TypedArray;

	/** Has this method already been executed? */
	private var executed:Boolean = false;

	/**
	 * Constructs a new {@code TestCaseMethodInfo} instance.
	 *
	 * @param methodInfo reflection information of the method
	 */
	public function TestCaseMethodInfo(methodInfo:MethodInfo) {
		this.methodInfo = methodInfo;
		stopWatch = new StopWatch();
		infos = new TypedArray(ExecutionInfo);
	}

	/**
	 * Returns the fully qualified name of this test method.
	 */
	public function getName(Void):String {
		return methodInfo.getFullName();
	}

	/**
	 * Returns the stop watch to measure the execution time.
	 */
	public function getStopWatch(Void):StopWatch {
		return stopWatch;
	}

	/**
	 * Returns {@code true} if at least one assertion failed, otherwise {@code false}.
	 */
	public function hasErrors(Void):Boolean {
		for (var i:Number = 0; i < infos.length; i++) {
			var info:ExecutionInfo = infos[i];
			if (info.isFailed()) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Returns the time needed to execute this test method.
	 */
	public function getOperationTime(Void):Number {
		return getStopWatch().getTimeInMilliSeconds();
	}

	/**
	 * Returns the reflection information about this method.
	 */
	public function getMethodInfo(Void):MethodInfo {
		return this.methodInfo;
	}

	/**
	 * Adds information about the execution of this method.
	 */
	public function addInfo(info:ExecutionInfo):Void {
		infos.push(info);
	}

	/**
	 * Returns all added information as {@link ExecutionInfo} instances about the
	 * execution of this method.
	 */
	public function getInfos(Void):TypedArray {
		return infos.concat();
	}

	/**
	 * Returns all errors as failed {@link ExecutionInfo} instances that occurred
	 * during the execution of this method.
	 */
	public function getErrors(Void):TypedArray {
		var result:TypedArray = new TypedArray(ExecutionInfo);
		for (var i:Number = 0; i < infos.length; i++) {
			var info:ExecutionInfo = infos[i];
			if (info.isFailed()) {
				result.push(info);
			}
		}
		return result;
	}

	/**
	 * Has this test method already been executed?
	 */
	public function isExecuted(Void):Boolean {
		return executed;
	}

	/**
	 * Sets whether this method was executed.
	 */
	public function setExecuted(executed:Boolean):Void {
		this.executed = executed;
	}

	/**
	 * Returns the string representation of this test method.
	 */
	public function toString():String {
		var result:String = getMethodInfo().getName() + "()";
		result += " [" + getStopWatch().getTimeInMilliSeconds() + "ms]:";
		var errors:Array = getErrors();
		if (errors.length > 1) {
			result += " " + errors.length + " errors occurred";
		}
		else if(errors.length > 0) {
			result += " 1 error occurred";
		}
		for (var i:Number = 0; i < errors.length; i++) {
			var error:ExecutionInfo = errors[i];
			result += "\n" + StringUtil.addSpaceIndent(error.getMessage(), 2);
		}
		if (errors.length > 0) {
			result += "\n";
		}
		return result;
	}

}