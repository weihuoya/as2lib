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

import org.as2lib.data.type.Angle;
import org.as2lib.test.unit.TestCase;

/**
 * Abstract Testcase for the Angle type.
 * 
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.data.type.TAngle extends TestCase {
	
	/**
	 * Static method to block the collecting by the TestSuiteFactory
	 * 
	 * @return true to block the content
	 */
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	/**
	 * Creates a new Angle instance. (Template method)
	 * 
	 * @param param Parameter for the angle (can be any number)
	 */
	private function getAngle(param:Number):Angle {
		return null;
	}
	
	/**
	 * Tests if positive angles work proper
	 */
	public function testPositiveAngle(Void):Void {
		var angle:Angle = getAngle(1);
		assertEquals("The Angle should work properly with positive values", angle.toDegree(), angle.toRadian()*180/Math.PI);
	}
	
	/**
	 * Tests if negative angles work proper
	 */
	public function testNegativeAngle(Void):Void {
		var angle:Angle = getAngle(-1);
		assertEquals("The Angle should work properly with a negative values", angle.toDegree(), angle.toRadian()*180/Math.PI);
	}
	
	/**
	 * Tests if zero angle work proper
	 */
	public function testZeroAngle(Void):Void {
		var angle:Angle = getAngle(0);
		assertEquals("The Angle should return zero degree by working with zero", angle.toDegree(), 0);
		assertEquals("The Angle should return zero radian by working with zero", angle.toRadian(), 0);
		
	}
}