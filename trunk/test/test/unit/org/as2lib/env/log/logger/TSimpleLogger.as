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

import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MockControl;
import org.as2lib.test.mock.support.SimpleMockControl;
import org.as2lib.env.log.logger.SimpleLogger;
import org.as2lib.env.log.LogLevel;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.log.logger.TSimpleLogger extends TestCase {
	
	public function testConstructor(Void):Void {
		var logger:SimpleLogger = new SimpleLogger();
		var returnedName:String = logger.getName();
		assertSame("The returned name [" + returnedName + "] should be a blank string.", "", returnedName);
	}
	
	public function testConstructorWithName(Void):Void {
		var logger:SimpleLogger = new SimpleLogger("loggerName");
		var returnedName:String = logger.getName();
		assertSame("The two names [loggerName ," + returnedName + "] should be the same.", "loggerName", returnedName);
	}
	
	public function testSetLevelWithValidLevel(Void):Void {
		var logger:SimpleLogger = new SimpleLogger();
		var level:LogLevel = new LogLevel();
		logger.setLevel(level);
		var returnedLevel:LogLevel = logger.getLevel();
		assertSame("The two levels [" + level + ", " + returnedLevel + "] should be the same.", level, returnedLevel);
	}
	
	public function testSetLevelWithNullLevel(Void):Void {
		var logger:SimpleLogger = new SimpleLogger();
		logger.setLevel(null);
		var returnedLevel:LogLevel = logger.getLevel();
		assertNull("The returned level [" + returnedLevel + "] should be null.", returnedLevel);
	}
	
	public function testSetLevelWithNullLevelAndParentWithValidLevel(Void):Void {
		var logger:SimpleLogger = new SimpleLogger();
		var parent:SimpleLogger = new SimpleLogger();
		var level:LogLevel = new LogLevel();
		parent.setLevel(level);
		logger.setParent(parent);
		var returnedLevel:LogLevel = logger.getLevel();
		assertSame("The two levels [" + level + ", " + returnedLevel + "] should be the same.", level, returnedLevel);
	}
	
	public function testSetName(Void):Void {
		var logger:SimpleLogger = new SimpleLogger();
		logger.setName("any.name");
		var returnedName:String = logger.getName();
		assertSame("The returned name [" + returnedName + "] should be 'any.name'.", "any.name", returnedName);
	}
	
	public function testAddHandler(Void):Void {
		// TODO: Functionality to add a custom broadcaster needed.
	}
	
	public function testRemoveHandler(Void):Void {
		// TODO: Functionality to add a custom broadcaster needed.
	}
	
	public function testRemoveAllHandler(Void):Void {
		// TODO: Functionality to add a custom broadcaster needed.
	}
	
	public function testGetAllHandler(Void):Void {
		// TODO: Functionality to add a custom broadcaster needed.
	}
	
	public function testIsEnabled(Void):Void {
		var control:MockControl = new SimpleMockControl(LogLevel);
		var level:LogLevel = control.getMock();
		var passedLevel:LogLevel = new LogLevel();
		level.isGreaterOrEqual(passedLevel);
		control.setReturnValue(true);
		control.replay();
	
		var logger:SimpleLogger = new SimpleLogger();
		logger.setLevel(level);
		var returnedBoolean = logger.isEnabled(passedLevel);
		assertTrue("Returned boolean [" + returnedBoolean + "] should be 'true'.", returnedBoolean);
		
		control.verify(this);
	}
	
	public function testLogWithEnabledLevel(Void):Void {
		// TODO: Functionality to add a custom broadcaster needed.
		//       Functionality to use a custom log message needed.
	}
	
	public function testLogWithDisabledLevel(Void):Void {
		// TODO: Functionality to add a custom broadcaster needed.
		//       Functionality to use a custom log message needed.
	}
	
}