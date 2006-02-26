/*
 Copyright aswing.org, see the LICENCE.txt.
*/

 import org.aswing.EventDispatcher;
 
/**
 * Fires one or more action events after a specified delay.  
 * For example, an animation object can use a <code>Timer</code>
 * as the trigger for drawing its frames.
 *
 *<p>
 * Setting up a timer
 * involves creating a <code>Timer</code> object,
 * registering one or more action listeners on it,
 * and starting the timer using
 * the <code>start</code> method.
 * For example, 
 * the following code creates and starts a timer
 * that fires an action event once per second
 * (as specified by the first argument to the <code>Timer</code> constructor).
 * The second argument to the <code>Timer</code> constructor
 * specifies a listener to receive the timer's action events.
 *
 *<pre>
 *  var delay:Number = 1000; //milliseconds
 *  var listener:Object = new Object();
 *  listener.taskPerformer = function() {
 *          <em>//...Perform a task...</em>
 *      }
 *  var timer:Timer = new Timer(delay);
 *  timer.addActionListener(listener.taskPerformer, listener);
 *  timer.start();
 * </pre>
 *
 * <p>
 * @author iiley
 */
class org.aswing.util.Timer extends EventDispatcher{
	
	private var delay:Number;
	private var initialDelay:Number;
	private var repeats:Boolean;
	private var intervalID:Number;
	private var isInitalFire:Boolean;
	
	/**
	 * Construct Timer.
	 * @see #setDelay()
     * @throws Error when init delay <= 0 or delay == null
	 */
	public function Timer(delay:Number){
		if(delay == undefined || delay <=0){
			trace("delay must > 0! when create a Timer");
			throw new Error("delay must > 0! when create a Timer");
		}
		this.delay = delay;
		this.initialDelay = undefined;
		this.repeats = true;
		this.isInitalFire = true;
		this.intervalID = null;
	}
	
    /**
     * addActionListener(fuc:Function, obj:Object)<br>
     * addActionListener(fuc:Function)<br>
     * Adds an action listener to the <code>Timer</code>.
     *
     * @param fuc the listener function.
     * @param obj which context to run in by the func.
     * @see org.aswing.EventDispatcher#addEventListener()
     * @see org.aswing.EventDispatcher#ON_ACT
     * @return the listener just added.
     */	
	public function addActionListener(func:Function, obj:Object):Object{
		return addEventListener(ON_ACT, func, obj);
	}
	
    /**
     * Sets the <code>Timer</code>'s delay, the number of milliseconds
     * between successive events.
     *
     * @param delay the delay in milliseconds
     * @see #setInitialDelay()
     * @throws Error when set delay <= 0 or delay == null
     */	
	public function setDelay(delay:Number):Void{
		if(delay == undefined || delay <= 0){
			trace("Timer should be specified delay>0! Error delay = " + delay);
			throw new Error("Timer should be specified delay>0! Error delay = " + delay);
		}
		this.delay = delay;
	}
	
    /**
     * Returns the delay, in milliseconds, 
     * between firings of events.
     *
     * @see #setDelay()
     * @see #getInitialDelay()
     */	
	public function getDelay():Number{
		return delay;
	}
	
    /**
     * Sets the <code>Timer</code>'s initial delay,
     * which by default is the same as the between-event delay.
     * This is used only for the first action event.
     * Subsequent events are spaced
     * using the delay property.
     * 
     * @param initialDelay the delay, in milliseconds, 
     *                     between the invocation of the <code>start</code>
     *                     method and the first event
     *                     fired by this timer
     *
     * @see #setDelay()
     * @throws Error when set initialDelay <= 0 or initialDelay == null
     */	
	public function setInitialDelay(initialDelay:Number):Void{
		if(initialDelay == undefined || initialDelay <= 0){
			trace("Timer should be specified initialDelay>0! Error initialDelay = " + initialDelay);
			throw new Error("Timer should be specified initialDelay>0! Error initialDelay = " + initialDelay);
		}
		this.initialDelay = initialDelay;
	}
	
    /**
     * Returns the <code>Timer</code>'s initial delay.
     *
     * @see #setInitialDelay()
     * @see #setDelay()
     */	
	public function getInitialDelay():Number{
		if(initialDelay == undefined){
			return delay;
		}else{
			return initialDelay;
		}
	}
	
	/**
     * If <code>flag</code> is <code>false</code>,
     * instructs the <code>Timer</code> to send only once
     * action event to its listeners after a start.
     *
     * @param flag specify <code>false</code> to make the timer
     *             stop after sending its first action event.
     *             Default value is true.
	 */
	public function setRepeats(flag:Boolean):Void{
		repeats = flag;
	}
	
    /**
     * Returns <code>true</code> (the default)
     * if the <code>Timer</code> will send
     * an action event 
     * to its listeners multiple times.
     *
     * @see #setRepeats()
     */	
	public function isRepeats():Boolean{
		return repeats;
	}
	
    /**
     * Starts the <code>Timer</code>,
     * causing it to start sending action events
     * to its listeners.
     *
     * @see #stop()
     */
    public function start():Void{
    	isInitalFire = true;
    	clearInterval(intervalID);
    	intervalID = setInterval(this, "fireActionPerformed", getInitialDelay());
    }
    
    /**
     * Returns <code>true</code> if the <code>Timer</code> is running.
     *
     * @see #start()
     */
    public function isRunning():Boolean{
    	return intervalID != null;
    }
    
    /**
     * Stops the <code>Timer</code>,
     * causing it to stop sending action events
     * to its listeners.
     *
     * @see #start()
     */
    public function stop():Void{
    	clearInterval(intervalID);
    	intervalID = null;
    }
    
    /**
     * Restarts the <code>Timer</code>,
     * canceling any pending firings and causing
     * it to fire with its initial delay.
     */
    public function restart():Void{
        stop();
        start();
    }
    
    private function fireActionPerformed():Void{
    	fireActionEvent();
    	if(isInitalFire){
    		isInitalFire = false;
    		if(repeats){
    			clearInterval(intervalID);
    			intervalID = setInterval(this, "fireActionPerformed", getDelay());
    		}else{
    			stop();
    		}
    	}
    }
}
