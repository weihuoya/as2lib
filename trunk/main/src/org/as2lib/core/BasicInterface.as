import org.as2lib.env.reflect.ClassInfo;

/**
 * BasicInterface is the basic interface for each class in the as2lib framework.
 * It is recommended to always implement this interface in the classes of your
 * own project but it is not a necessity. You can use all functionality of the 
 * as2lib framework without implementing it.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 * @author Michael Hermann
 * @see org.as2lib.core.BasicClass for a default implementation
 */
interface org.as2lib.core.BasicInterface {       
     /** 
      * Returns a ClassInfo that represents the class the instance was instantiated
	  * from. 
      * 
	  * @return a ClassInfo representing the class of the instance
      */ 
     public function getClass(Void):ClassInfo; 
	 
	 public function toString(Void):String;
}