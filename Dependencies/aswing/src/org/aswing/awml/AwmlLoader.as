/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.EventDispatcher;
import org.aswing.util.Delegate;

/**
 * Provides load handling routines for AWML files. 
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.AwmlLoader extends EventDispatcher {

	/**
	 * When the loading is started.
	 *<br>
	 * onLoadStart(source:AwmlLoader)
	 */	
	public static var ON_LOAD_START:String = "onLoadStart";	

	/**
	 * When the loading is completed.
	 *<br>
	 * onLoadComplete(source:AwmlLoader, awml:String)
	 */	
	public static var ON_LOAD_COMPLETE:String = "onLoadComplete";	

	/**
	 * When the loading is failed.
	 *<br>
	 * onLoadFail(source:AwmlLoader)
	 */	
	public static var ON_LOAD_FAIL:String = "onLoadFail";	

	
	/** <code>LoadVars</code> instance for loading the content. */
    private var loader:LoadVars;
	
	
	/** 
	 * Constructor.
	 */
	public function AwmlLoader(Void) {
		super();
		
		loader = new LoadVars();
		loader.onData = Delegate.create(this, __onData);
	}
	
    /**
     * addActionListener(fuc:Function, obj:Object)<br>
     * addActionListener(fuc:Function)<br>
     * Adds a action listener to the loader. Loader fires a action event when 
     * AWML file is loaded.
     * @param fuc the listener function.
     * @param obj which context to run in by the func.
     * @return the listener just added.
     * @see EventDispatcher#ON_ACT
     */
    public function addActionListener(fuc:Function, obj:Object):Object{
    	return addEventListener(ON_ACT, fuc, obj);
    }
    
    /**
     * Start loading AWML file from the specified <code>url</code>.
     * 
     * @param url the URL there AWML file is located. 
     */
    public function load(url:String):Void {
    	if (loader.load(url)) {
    		fireLoadStartEvent();	
    	} else {
    		fireLoadFailEvent();	
    	}
    } 
    
    /**
     * Fires ON_LOAD_START event.
     */
    private function fireLoadStartEvent(Void):Void {
    	dispatchEvent(createEventObj(ON_LOAD_START));
    }

    /**
     * Fires ON_LOAD_COMPLETE event.
     */
    private function fireLoadCompleteEvent(awml:String):Void {
    	dispatchEvent(createEventObj(ON_LOAD_COMPLETE, awml));
    }
    /**
     * Fires ON_LOAD_FAIL event.
     */
    private function fireLoadFailEvent(Void):Void {
    	dispatchEvent(createEventObj(ON_LOAD_FAIL));
    }

    /**
     * Handles <code>LoadVars#onData</code> event.
     */
    private function __onData(awml:String):Void {
    	if (awml != null) {
    		fireLoadCompleteEvent(awml);
    		fireActionEvent(awml);
    	} else {
    		fireLoadFailEvent();
    	}
    }
    
}