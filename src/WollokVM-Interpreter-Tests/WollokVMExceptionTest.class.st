Class {
	#name : #WollokVMExceptionTest,
	#superclass : #AbstractWollokVMInterpreterTest,
	#category : #'WollokVM-Interpreter-Tests-7.Exceptions'
}

{ #category : #tests }
WollokVMExceptionTest >> testFinallyExecutesWithException [

	| returnObject |
	interpreter addBindingOfClass: 'MyFaillingClass' fromString: '
class MyFaillingClass { 
	var a = 7
	
	method boom(){
		throw new wollok.lang.Exception(message = "Boom!")
	}
	
	method noboom() {  }
}'.

	returnObject := self interpretExpression: '
		var x = 6
		try {new MyFaillingClass().boom()}
			catch e:wollok.lang.Exception { x = 7}
			then always { x = 99}
		x'.
		
	self assert: returnObject literalValue equals: 99

]

{ #category : #tests }
WollokVMExceptionTest >> testFinallyExecutesWithoutException [

	| returnObject |
	interpreter addBindingOfClass: 'MyFaillingClass' fromString: '
class MyFaillingClass { 
	var a = 7
	
	method boom(){
		throw new wollok.lang.Exception(message = "Boom!")
	}
	
	method noboom() {  }
}'.

	returnObject := self interpretExpression: '
		var x = 6
		try {new MyFaillingClass().noboom()}
			catch e:wollok.lang.Exception {return 7}
			then always { x = 99}
		x'.
		
	self assert: returnObject literalValue equals: 99

]

{ #category : #tests }
WollokVMExceptionTest >> testMethodCanThrowException [

	interpreter addBindingOfClass: 'MyFaillingClass' fromString: '
class MyFaillingClass { 
	var a = 7
	
	method boom(){
		throw new wollok.lang.Exception(message = "Boom!")
	}
}'.

	[self interpretExpression: 'new MyFaillingClass().boom()'] 
		on: WollokError 
		do: [ :e |
			self assert: e wollokException isNotNil.
			^ self
		].
	

]

{ #category : #tests }
WollokVMExceptionTest >> testTryCatchesTheException [

	| returnObject |
	interpreter addBindingOfClass: 'MyFaillingClass' fromString: '
class MyFaillingClass { 
	var a = 7
	
	method boom(){
		throw new wollok.lang.Exception(message = "Boom!")
	}
}'.

	returnObject := self interpretExpression: 'try {new MyFaillingClass().boom()}
		catch e:wollok.lang.Exception {return 7}'.
		
	self assert: returnObject literalValue equals: 7
	

]

{ #category : #tests }
WollokVMExceptionTest >> testTryWithCatchWithoutExceptionWithoutFinally [

	| returnObject |
	interpreter addBindingOfClass: 'MyCustomException1' fromString: 'class MyCustomException1 inherits wollok.lang.Exception {}'.
	interpreter addBindingOfClass: 'MyCustomException2' fromString: 'class MyCustomException2 inherits wollok.lang.Exception {}'.
	interpreter addBindingOfClass: 'MyFaillingClass' fromString: '
		class MyFaillingClass {
			method boom(){
				throw new MyCustomException2(message = "Boom!")
			}
		}
	'.

	returnObject := self interpretExpression: '
		try {
			new MyFaillingClass().boom()
		} catch e:MyCustomException1 {
			return 1
		} catch e:MyCustomException2 {
			return 2
		}'.
		
	self assert: returnObject literalValue equals: 2

]

{ #category : #tests }
WollokVMExceptionTest >> testWollokExceptionReachingEndOfStackPopsAsAWollokError [

	[self interpretExpression: 'throw new wollok.lang.Exception(message = "ahhhh me muero")'] 
		on: WollokError 
		do: [ :e |
			self assert: e wollokException isNotNil.
			^ self
		].
		
	self fail
]
