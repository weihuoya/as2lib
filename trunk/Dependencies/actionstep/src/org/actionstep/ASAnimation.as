﻿/* See LICENSE for copyright and terms of use */

import org.actionstep.constants.NSAnimationCurve;
import org.actionstep.constants.NSAnimationMode;
import org.actionstep.NSArray;
import org.actionstep.NSObject;
import org.actionstep.NSTimer;
import org.actionstep.NSException;

/**
 * <p>Objects of the ASAnimation class manage the timing and progress of 
 * animations in the user interface. The class also lets you link together 
 * multiple animations so that when one animation ends another one starts. It 
 * does not provide any drawing support for animation and does not directly 
 * deal with views, targets, or actions.</p>
 * 
 * <p>ASAnimation objects have several characteristics, including duration, 
 * frame rate, and animation curve, which describes the relative speed of the 
 * animation over its course. You can set progress marks in an animation, each 
 * of which specifies a percentage of the animation completed; when an 
 * animation reaches a progress mark, it notifies its delegate and posts a 
 * notification to any observers.</p>
 * 
 * @author Tay Ray Chuan
 */
class org.actionstep.ASAnimation extends NSObject {

	//******************************************************
	//*                  Members
	//******************************************************
	
	private var m_curve:NSAnimationCurve;
	private var m_mode:NSAnimationMode;
	private var m_delegate:Object;
	private var m_frameRate:Number;
	private var m_progressMarks:NSArray;

	private var m_timer:NSTimer;

	private var m_begin:Number;
	private var m_change:Number;
	private var m_end:Number;

	private var m_duration:Number;
	private var m_time:Number;
	private var m_progress:Number;
	private var m_value:Number;

	private var m_startAnim:Object;
	private var m_stopAnim:Object;

	//******************************************************
	//*                  Construction
	//******************************************************

	/**
	 * <p>Constructs a new instance of the <code>ASAnimation</code> class.</p>
	 * 
	 * <p>Should be followed with a call to 
	 * {@link #initWithDurationAnimationCurve()}.</p>
	 */
	public function ASAnimation() {
		m_mode = NSAnimationMode.NSBlocking;
		m_timer = new NSTimer();
	}

	/**
	 * <p>Returns an <code>ASAnimation</code> object initialized with the 
	 * specified duration and animation-curve values.</p>
	 * 
	 * @throws NSException If <code>time</code> is negative.
	 */
	public function initWithDurationAnimationCurve(time:Number, curve:NSAnimationCurve):ASAnimation {
		if (time < 0) {
			var e:NSException = NSException.exceptionWithNameReasonUserInfo(
				NSException.NSInvalidArgument,
				"time must be a non-negative number",
				null);
			trace(e);
			throw e;
		}
		
		m_duration = time;
		
		if (curve == null) {
			curve = NSAnimationCurve.NSEaseInOutLinear;
		}
		
		m_curve = curve;
		return this;
	}

	//******************************************************
	//*              Describing the animation
	//******************************************************
	
	/**
	 * Returns a string representation of the ASAnimation instance.
	 */
	public function description():String {
		return "ASAnimation()";
	}
	
	//******************************************************
	//*                  Attributes
	//******************************************************

	public function setBlockingMode(mode:NSAnimationMode):Void {
		m_mode = mode;
	}

	public function blockingMode():NSAnimationMode {
		return m_mode;
	}

	public function setAnimationCurve(f:NSAnimationCurve):Void {
		m_curve = f;
	}

	public function animationCurve():NSAnimationCurve {
		return m_curve;
	}

	public function setDelegate(f:Object):Void {
		m_delegate = f;
	}

	public function delegate():Object {
		return m_delegate;
	}

	//******************************************************
	//*            Time and Values Attributes
	//******************************************************

	public function currentValue():Number {
		return m_value;
	}

	public function setDuration(f:Number):Void {
		m_duration = f;
	}

	public function duration():Number {
		return m_duration;
	}

	public function setBegin(f:Number):Void {
		m_begin = f;
		m_end = m_begin+m_change;
	}

	public function begin():Number {
		return m_begin;
	}

	public function setChange(f:Number):Void {
		m_change = f;
		m_end = m_begin+m_change;
	}

	public function change():Number {
		return m_change;
	}

	public function setFrameRate(f:Number):Void {
		m_frameRate = f;
	}

	public function frameRate():Number {
		return m_frameRate;
	}
	
	//******************************************************
	//*                  Animation Control
	//******************************************************

	public function startAnimation():Void {
		if(m_delegate["animationShouldStart"].call(m_delegate, this)) {
			return;
		}

		m_timer.initWithFireDateIntervalTargetSelectorUserInfoRepeats(
		new Date(), 1/m_frameRate, this, "handleTimer", {
			st: getTimer()
		}, true);
	}

	public function stopAnimation():Void {
		if(isAnimating()) {
			m_timer.invalidate();
		}
		trace("in "+(m_duration==null));
		if(m_progress == 1) {
			m_delegate["animationDidEnd"].call(m_delegate, this);
		} else {
			m_delegate["animationDidStop"].call(m_delegate, this);
		}
	}

	public function isAnimating():Boolean {
		return m_timer.isValid();
	}

	private function handleTimer(timer:NSTimer, info:Object):Void {
		m_time = getTimer() - info.st;
		if(m_time > m_duration) {
			m_time = m_duration;
		}
		trace(m_time);
		if(m_time == Number(m_startAnim.time)) {
			trace("in");
			ASAnimation(m_startAnim.anim).startAnimation();
		} else if(m_time == Number(m_stopAnim.time)) {
			trace("in");
			ASAnimation(m_stopAnim.anim).stopAnimation();
		}

		//!FIXME how accurate?
		//m_progress = Math.round(m_time/m_duration*100)/100;

		m_value = m_curve.currentValue(m_time, m_begin, m_change, m_duration);
		if(m_value >= m_end) {
			stopAnimation();
		}
	}

	//******************************************************
	//*            Managing Progress Marks
	//******************************************************

	public function setProgressMarks(f:NSArray):Void {
		m_progressMarks = f;
	}

	public function progressMarks():NSArray {
		return m_progressMarks;
	}

	public function addProgressMark(n:Number):Void {
		m_progressMarks.addObject(n);
	}

	public function removeProgressMark(n:Number):Void {
		m_progressMarks.removeObject(n);
	}

	//! FIXME am i doing it right?
	public function currentProgress():Number {
		return m_progress;
	}

	//******************************************************
	//*                Linking Animations
	//******************************************************

	private function setStartAnimation(anim:ASAnimation, progress:Number):Void {
		m_startAnim = {time: progress, anim: anim};
	}

	public function startWhenAnimationReachesTime(anim:ASAnimation, progress:Number):Void {
		anim.setStartAnimation(anim, progress);
	}

	private function setStopAnimation(anim:ASAnimation, progress:Number):Void {
		m_stopAnim = {time: progress, anim: anim};
	}

	public function stopWhenAnimationReachesTime(anim:ASAnimation, progress:Number):Void {
		anim.setStopAnimation(anim, progress);
	}
}