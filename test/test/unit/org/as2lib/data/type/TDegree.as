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

import test.unit.org.as2lib.data.type.TAngle;
import org.as2lib.data.type.Angle;
import org.as2lib.data.type.Degree;

/**
 * Tests the degree implementation of the angle
 * 
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.data.type.TDegree extends TAngle {
	
	/**
	 * Implementation of the template method of TAngle
	 * 
	 * @param param Parameter for the Angle instance
	 * @return Degree instance for the parameter.
	 */
	public function getAngle(param:Number):Angle {
		return new Degree(param);
	}
	
	/**
	 * Tests that value of returns the value of the angle.
	 */
	public function testValue(Void):Void {
		assertEquals("The valueof the instance should be the same like given to the instance", new Degree(90), 90);
		assertEquals("The getDegree the instance should be the same like given to the instance", new Degree(90).toDegree(), 90);
		assertEquals("The getRadian the instance should be the same like given to the instance", new Degree(90).toRadian(), 90*Math.PI/180);
	}
}