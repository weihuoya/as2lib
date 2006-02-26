﻿/* See LICENSE for copyright and terms of use */

import org.actionstep.ASDraw;
import org.actionstep.constants.ASConstantValue;

/**
 * <p>Describes the behaviour of the animation.</p>
 * 
 * <p>Constants of this class are associated with easing equations that can be
 * accessed using the {@link #easingFunction()} method, or used to calculate
 * the animation's current value with the {@link #currentValue()} method.</p>
 * 
 * <p>View the comments of specific curve constants to learn about the curve's
 * animation behaviour.</p>
 *
 * <p>Some of Cocoa's constants are not listed here due to their ambiguity.</p>
 *
 * @author Tay Ray Chuan
 */
class org.actionstep.constants.NSAnimationCurve extends ASConstantValue {
	
	/**
	 * Describes an animation in which the animated object moves at a contant
	 * rate until its destination is met.
	 */
	public static var NSEaseInOutLinear:NSAnimationCurve = 
		new NSAnimationCurve(0, ASDraw.linearTween);

	/** The easing function. */
	private var m_func:Function;

	/**
	 * Creates a new instance of the <code>NSAnimationCurve</code> class, with
	 * the value <code>value</code> and the easing function <code>func</code>.
	 */
	private function NSAnimationCurve(value:Number, func:Function) {
		super(value);
		m_func = func;
	}

	/**
	 * Returns this curve's easing function, that is, the mathematical function
	 * that is used to calculate positions of the animated object based on time.
	 */
	public function easingFunction():Function {
		return m_func;
	}
	
	/**
	 * <p>Returns the position of the animation based <code>timeElapsed</code>,
	 * <code>startValue</code>, <code>change</code> and <code>duration</code>.</p>
	 * 
	 * <p>Please note that <code>change</code> is the amount that the value
	 * will change over the <code>duration</code> of the animation.</p>
	 */
	public function currentValue(timeElapsed:Number, startValue:Number, 
			change:Number, duration:Number):Number {
		return m_func(timeElapsed, startValue, change, duration);
	}
}