import org.as2lib.basic.TypedArray;

/**
 * Informationholder for the reflected Classinformation
 * This Interfaces defines the properties and possibilies to access
 * all informations that are stored using reflections.
 */

interface org.as2lib.reflect.ClassInfo { 
      
     /** 
      * @return the name of the class
      */ 
     public function getName(Void):String; 
     
     /** 
      * You may set the name for yourself to save performance.
      * If you set the name this way, reflections will be switched off.
      * This value won't get validated by an internal routine.
      *
      * @param name of this class
      */
     public function setName(to:String):Void;
     
     /** 
      * @return the constructor of the class.
      */ 
     public function getConstructor(Void):Function; 
     
     /** 
      * @return a new instance of the constructor appending arguments to the constructor.
      */ 
     public function newInstance(usedArguments:Array):Object; 
      
     /** 
      * @return a TypedArray from type String containing all Vars that an Instance of this class has. 
      */ 
     public function getVars(Void):TypedArray; 
     
     /**
      * Overwrite the internal array of vars.
      * @param the TypedArray
      */
     public function setVars(to:TypedArray):Void;
     
     /** 
      * @return a TypedArray from type MethodInfo containing all methods that an instance of this class has. 
      */ 
     public function getMethods(Void):TypedArray; 
     
     /**
      * Sets the method array that will be returned by the call of the getMethods method.
      * @param the TypedArray containing the definitions of the methods
      */
     public function setMethods(to:TypedArray):Void;
      
     /** 
      * @return a TypedArray from type String containing all Vars that the Class has. 
      */ 
     public function getStaticVars(Void):TypedArray; 
     
     /**
      * Sets the static vars array that will be returned by the invocation of the getStaticVars method.
      * @param the TypedArray containing the definitions of all static vars
      */
     public function setStaticVars(to:TypedArray):Void;
      
     /** 
      * @return a TypedArray from type MethodInfo containing all Methods that the Class has. 
      */ 
     public function getStaticMethods(Void):TypedArray; 
     
     /**
      * Sets the TypedArray that will be returned by an invocation of the getStaticMethods method.
      * @param the TypedArray that contains the definitions of the static methods.
      */
     public function setStaticMethods(to:TypedArray):Void;
 
} 