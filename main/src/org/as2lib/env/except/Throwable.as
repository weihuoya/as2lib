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

/**
 * Throwable is the basic interface for every class that gets be thrown.
 *
 * <p>You can actually throw every class even if it does not implement
 * this interface but it is recommended to strictly use this interface
 * for every throwable. Using it produces clarity and setups a standard.
 *
 * <p>It prescribes implementing classes to provide key functionalities
 * that help you a lot when an exception gets thrown and you do not catch
 * it.
 * 
 * <p>The first thing is the message. The message contains detaild information
 * about the problem that occurred.
 * 
 * <p>The second is the stack trace. The stack trace contains at least the
 * method that actually threw the throwable. It can also contain the
 * method that invoked the method that threw the throwable and so on.
 * 
 * <p>The third feature is the cause. Let's say a throwable gets thrown
 * and we catch it. After catching it we want to throw a new throwable,
 * that is of another type and contains another message that describes
 * the problem from the point of view of the catching method. In
 * such a case we of course do not want to lose the information the
 * catched throwable provides, that caused the throwing of the new
 * throwable. We thus create the new throwable and initialize its cause,
 * the catched throwable, to get a more comprehensive error message.
 *
 * <p>Working with throwables in Flash is a little buggy if you do not
 * know to what you have to pay attention to.
 *
 * <p>The first thing is that if you catch a throwable, the type of it
 * must be fully qualified. You cannot import the throwable and then
 * only use its name, because Flash will then not recognize the type,
 * and will not catch the thrown throwable (Note that it actually works
 * when working on the timeline. The problem only occures within classes.
 * But I would nevertheless always use fully qualified names to guard
 * agains potential errors.). Thus write your catch-blocks always the
 * following way.
 * <code>try {
 *   ...
 * } catch (e:org.as2lib.env.except.IllegalArgumentException) {
 *   ...
 * }</code>
 *
 * <p>The second problem occurs when working with Flex. The throwable
 * type in the catch-block's signature must always be a sub-class of
 * type Error (which is the native 'throwable' of ActionScript). Because
 * of that it is not possible to catch throwables by interfaces, like
 * the this interface. If you simply want to catch all throwables that
 * may be thrown in your application do not specify a throwable type or
 * use Error if you are really really sure that all your concrete throwable
 * implementations extend this class.
 * Note that the Exception and FatalException classes extend the Error
 * class, so they and any sub-classes can be used with Flex.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.except.Throwable extends BasicInterface {
	
	/**
	 * Returns an array that contains StackTraceElement instances of the
	 * methods the were invoked before this throwable was thrown.
	 *
	 * <p>The last element is always the one that contains the actual method
	 * that threw the throwable.
	 *
	 * <p>The stack trace helps you a lot because it says you where the
	 * throwing of the throwable took place and also what arguments caused
	 * the throwing.
	 *
	 * @return a stack containing the invoked methods until the throwable was thrown
	 */
	public function getStackTrace(Void):Array;
	
	/**
	 * Adds a stack trace element to the stack trace.
	 *
	 * <p>The new stack trace element is added to the end of the stack trace.
	 *
	 * <p>At some parts in your application you may want to add stack trace
	 * elements manually. This can help you to get a clearer image of what
	 * went where wrong and why.
	 * You can use this method to do so.
	 *
	 * @param thrower the object that threw, rethrew or forwarded (let pass) the throwable
	 * @param method the method that threw, rethrew or forwarded (let pass) the throwable
	 * @param args the arguments the method was invoked with when throwing, rethrowing or forwarding (leting pass) the throwable
	 */
	public function addStackTraceElement(thrower, method:Function, args:Array):Void;
	
	/**
	 * Initializes the cause of this throwable.
	 *
	 * <p>The cause can only be initialized once. You normally initialize 
	 * a cause if you throw a throwable due to the throwing of another throwable.
	 * Thereby you do not lose the information the cause offers.
	 * 
	 * <p>This method returns this throwable to have an easy way to initialize
	 * the cause.
	 * Following is how you could use the cause mechanism.
	 *
	 * <code>try {
	 *   myInstance.invokeMethodThatThrowsAThrowable();
	 * } catch (e:org.as2lib.env.except.Throwable) {
	 *   throw new MyThrowable("myMessage", this, arguments).initCause(e);
	 * }</code>
	 * 
	 * @param cause the throwable that caused the throwing of this throwable
	 * @return this throwable itself
	 * @throws org.as2lib.env.except.IllegalStateException if the cause has already been initialized
	 */
	public function initCause(cause:Throwable):Throwable;
	
	/**
	 * Returns the initialized cause.
	 *
	 * <p>The cause is the throwable that caused this throwable to be thrown.
	 *
	 * @return the initialized cause
	 * @see #initCause
	 */
	public function getCause(Void):Throwable;
	
	/**
	 * Returns the message that describes in detail what went wrong.
	 *
	 * <p>The message should be understandable, even for non-programmers.
	 * It should contain detailed information about what went wrong. And
	 * maybe also how the user that sees this message can solve the problem.
	 *
	 * <p>If the throwable was thrown for example because of a wrong collaborator
	 * or an illegal string or something similar, provide the string representation
	 * of it in the error message. It is recommended to put these into '-signs.
	 *
	 * @return the message that describes the problem in detail
	 */
	public function getMessage(Void):String;
	
}