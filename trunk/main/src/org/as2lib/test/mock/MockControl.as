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

import org.as2lib.core.BasicInterface;

/**
 * @author Simon Wacker
 */
interface org.as2lib.test.mock.MockControl extends BasicInterface {
	
	/**
	 * Returns the mock object. It can be casted to the defined interface.
	 *
	 * @return the mock object
	 */
	public function getMock(Void);
	
	/**
	 * Switches the mock object from record state to replay state. The mock
	 * object is in record state as soon as it gets returned by the #getMock()
	 * operation.
	 */
	public function replay(Void):Void;
	
	/**
	 * Resets the mock control and the mock object to the state directly after
	 * creation. That means that all previously made configurations will be
	 * removed and that the mock object will again be in record state.
	 */
	public function reset(Void):Void;
	
	/**
	 * Records that the mock object will by default allow the last method specified
	 * by a method call and will react by returning the provided return value.
	 *
	 * @param value the return value to return
	 */
	public function setDefaultReturnValue(value):Void;
	
	/**
	 * Records that the mock object will by default allow the last method specified 
	 * by a method call, and will react by throwing the provided throwable.
	 *
	 * @param throwable the throwable to throw
	 */
	public function setDefaultThrowable(throwable):Void;
	
	/**
	 * Recards that the mock object will by default allow the last method specified
	 * by a method call.
	 */
	public function setDefaultVoidCallable(Void):Void;
	
	/**
	 * @overload #setReturnValueByValue()
	 * @overload #setReturnValueByValueAndQuantity()
	 * @overload #setReturnValueByValueAndMinimumAndMaximumQuantity()
	 */
	public function setReturnValue():Void;
	
	/**
	 * Records that the mock object will expect the last method call once and will
	 * react by returning the provided return value.
	 *
	 * @param value the return value to return
	 */
	public function setReturnValueByValue(value):Void;
	
	/**
	 * Records that the mock object will expect the last method call a fixed number
	 * of times and will react by returning the provided return value.
	 *
	 * @param value the return value to return
	 * @param quantity the number of times the method is allowed to be invoked
	 */
	public function setReturnValueByValueAndQuantity(value, quantity:Number):Void;
	
	/**
	 * Records that the mock object will expect the last method call between minimumQuantity
	 * and maximumQuantity times and will react by returning the provided return value.
	 *
	 * @param value the return value to return
	 * @param minimumQuantity the minimum number of times the method must be called
	 * @param maximumQuantity the maximum number of times the method can be called
	 */ 
	public function setReturnValueByValueAndMinimumAndMaximumQuantity(value, minimumQuantity:Number, maximumQuantity:Number):Void;
	
	/**
	 * @overload #setThrowableByThrowable()
	 * @overload #setThrowableByThrowableAndQuantity()
	 * @overload #setThrowableByThrowableAndMinimumAndMaximumQuantity()
	 */
	public function setThrowable():Void;
	
	/**
	 * Records that the mock object will expect the last method call once and will 
	 * react by throwing the provided throwable.
	 *
	 * @param throwable the throwable to throw
	 */
	public function setThrowableByThrowable(throwable):Void;
	
	/**
	 * Records that the mock object will expect the last method call a fixed number 
	 * of times and will react by throwing the provided throwable.
	 *
	 * @param throwable the throwable to throw
	 * @param quantity the number of times the method is allowed to be invoked
	 */
	public function setThrowableByThrowableAndQuantity(throwable, quantity:Number):Void;
	
	/**
	 * Records that the mock object will expect the last method call between minimumQuantity 
	 * and maximumQuantity times, and will react by throwing the provided throwable.
	 *
	 * @param throwable the throwable to throw
	 * @param minimumQuantity the minimum number of times the method must be called
	 * @param maximumQuantity the maximum number of times the method can be called
	 */
	public function setThrowableByThrowableAndMinimumAndMaximumQuantity(throwable, minimumQuantity:Number, maximumQuantity:Number):Void;
	
	/**
	 * @overload #setVoidCallableByVoid()
	 * @overload #setVoidCallableByQuantity()
	 * @overload #setVoidCallableByMinimumAndMaximumQuantity()
	 */
	public function setVoidCallable():Void;
	
	/**
	 * Records that the mock object will expect the last method call once and will 
	 * react by returning silently.
	 */
	public function setVoidCallableByVoid(Void):Void;
	
	/**
	 * Records that the mock object will expect the last method call a fixed number 
	 * of times and will react by returning silently.
	 *
	 * @param quantity the number of times the method is allowed to be invoked
	 */
	public function setVoidCallableByQuantity(quantity:Number):Void;
	
	/**
	 * Records that the mock object will expect the last method call between minimumQuantity 
	 * and maximumQuantity times and will react by returning silently.
	 *
	 * @param minimumQuantity the minimum number of times the method must be called
	 * @param maximumQuantity the maximum number of times the method can be called
	 */
	public function setVoidCallableByMinimumAndMaximumQuantity(minimumQuantity:Number, maximumQuantity:Number):Void;
	
	/**
	 * Verifies that all expectations have been met.
	 *
	 * @throws org.as2lib.env.except.IllegalStateException if the mock object is in record state
	 * @throws org.as2lib.test.mock.AssertionFailedError if any expectation has not been met
	 */
	public function verify(Void):Void;
	
}