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
      * @see org.as2lib.reflect.ClassInfo
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
      * @see org.as2lib.reflect.ClassInfo
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
      * @see org.as2lib.reflect.ClassInfo
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
      * @see org.as2lib.reflect.ClassInfo
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
      * @see org.as2lib.reflect.ClassInfo
      */
     public function setStaticMethods(to:TypedArray):Void {
		 
	 }
}