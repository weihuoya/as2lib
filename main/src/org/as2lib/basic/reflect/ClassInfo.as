import org.as2lib.basic.TypedArray;

/**
 * Informationholder for the reflected Classinformation
 * This Interface defines the properties and possibilities to access
 * all informations that are stored using reflections.
 */

interface org.as2lib.basic.reflect.ClassInfo { 
      
     /** 
      * @return the name of the class
      */ 
     public function getName(Void):String; 
     
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
      * @return a TypedArray from type MethodInfo containing all methods that an instance of this class has. 
      */ 
     public function getMethods(Void):TypedArray; 
      
     /** 
      * @return a TypedArray from type String containing all Vars that the Class has. 
      */ 
     public function getStaticVars(Void):TypedArray; 
      
     /** 
      * @return a TypedArray from type MethodInfo containing all Methods that the Class has. 
      */ 
     public function getStaticMethods(Void):TypedArray; 
 
} 