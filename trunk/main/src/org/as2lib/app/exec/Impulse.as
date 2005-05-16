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
 
import org.as2lib.app.exec.Executable;
import org.as2lib.core.BasicInterface;

/**
 * {@code Impulse} is a definition for events that gets executed periodically.
 * 
 * <p>Periodical events could be frame executions, seconds, hours or dates.
 * {@code Impulse} allows to seperate the certain kind of Impulse from the
 * execution code.
 * 
 * <p>The {@code Impulse} executes {@link Executable#execute} on each impulse of
 * the connected executables.
 * 
 * Example:
 * <code>
 *   import org.as2lib.app.exec.Impulse;
 * 
 *   var impulse:Impulse = new MySinusImpulse();
 *   impulse.connectExecutable(new MySpecialCall());
 *   impulse.connectExecutable(new MyMostImportantCall());
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.app.exec.Impulse extends BasicInterface {
	
	/**
	 * Connect a certain executable to listen to the continous event.
	 * 
	 * @param executable Executable that should be connected
	 */
	public function connectExecutable(executable:Executable):Void;
	
	/**
	 * Disconnect a certain executable from listening to the {@code Impulse}.
	 * 
	 * @param executable Executable that should be disconnected
	 */
	public function disconnectExecutable(executable:Executable):Void;
	
	/**
	 * Flag if a certain(passed-in) {@code executable} is connected.
	 * 
	 * @param executable {@link Executable} is 
	 * @return true if the certain executable got connected
	 */
	public function isExecutableConnected(executable:Executable):Boolean;
}