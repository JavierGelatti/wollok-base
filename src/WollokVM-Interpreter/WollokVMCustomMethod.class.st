Class {
	#name : #WollokVMCustomMethod,
	#superclass : #WollokVMMethod,
	#instVars : [
		'parameters',
		'body'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #'instance creation' }
WollokVMCustomMethod class >> named: aString withParameters: aCollection withBody: aWollokBlockExpressionNode [ 
	^ self new 
	   initializeWithName: aString 
	   parameters: aCollection 
	   body: aWollokBlockExpressionNode; yourself.
]

{ #category : #accessing }
WollokVMCustomMethod >> arity [
	^ parameters size
]

{ #category : #evaluating }
WollokVMCustomMethod >> evaluateBoundTo: receiver with: arguments context: anInterpreter [

  ^ anInterpreter interpretExpression: body.
]

{ #category : #initialization }
WollokVMCustomMethod >> initializeWithName: aString parameters: aCollection body: aBlockExpressionNode [ 
   name := aString.
   parameters := aCollection.
   body := aBlockExpressionNode.
]

{ #category : #accessing }
WollokVMCustomMethod >> parameterNames [
	^ parameters collect: [ :parameterNode | parameterNode parameter value ].
]
