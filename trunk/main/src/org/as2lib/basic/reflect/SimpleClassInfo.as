import org.as2lib.reflect.ClassInfo;
import org.as2lib.basic.TypedArray;

/**
 * @version 1.0
 */
class org.as2lib.basic.reflect.SimpleClassInfo implements ClassInfo {
     /** 
      * @see org.as2lib.reflect.ClassInfo
      */ 
     public function getName(Void):String {
		 return "";
	 }
     
     /** 
      * You may set the name for yourself to save performance.
      * If you set the name this way, reflections will be switched off.
      * This value won't get validated by an internal routine.
      *
      * @param name of this class
      */
     public function setName(to:String):Void {
		 
	 }
     
     /** 
      * @see org.as2lib.reflect.ClassInfo
      */ 
     public function getConstructor(Void):Function {
		 return new Function();
	 }
     
     /** 
      * @see org.as2lib.reflect.ClassInfo
      */ 
     public function newInstance(usedArguments:Array):Object {
		 return new Object();
	 }
      
     /** 
      * @see org.as2lib.reflect.ClassInfo 
      */ 
     public function getVars(Void):TypedArray {
		 return new TypedArray();
	 }
     
     /**
      * Overwrite the internal array of vars.
      * @param the TypedArray
      */
     public function setVars(to:TypedArray):Void {
		 
	 }
     
     /** 
      * @see org.as2lib.reflect.ClassInfo
      */ 
     public function getMethods(Void):TypedArray {
		  return new TypedArray();
	 }
     
     /**
      * Sets the method array that will be returned by the call of the getMethods method.
      * @param the TypedArray containing the definitions of the methods
      */
     public function setMethods(to:TypedArray):Void {
		 
	 }
      
     /** 
      * @see org.as2lib.reflect.ClassInfo
      */ 
     public function getStaticVars(Void):TypedArray {
		  return new TypedArray();
	 }
     
     /**
      * Sets the static vars array that will be returned by the invocation of the getStaticVars method.
      * @param the TypedArray containing the definitions of all static vars
      */
     public function setStaticVars(to:TypedArray):Void {
		 
	 }
      
     /** 
      * @see org.as2lib.reflect.ClassInfo
      */ 
     public function getStaticMethods(Void):TypedArray {
		  return new TypedArray();
	 }
     
     /**
      * Sets the TypedArray that will be returned by an invocation of the getStaticMethods method.
      * @param the TypedArray that contains the definitions of the static methods.
      */
     public function setStaticMethods(to:TypedArray):Void {
		 
	 }
}