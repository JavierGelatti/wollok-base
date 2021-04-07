Class {
	#name : #WollokVMMethod,
	#superclass : #Object,
	#instVars : [
		'name',
		'parameters',
		'body'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokVMMethod class >> named: aString withParameters: aCollection withBody: aWollokBlockExpressionNode [ 
	^ self new 
	   initializeWithName: aString 
	   parameters: aCollection 
	   body: aWollokBlockExpressionNode; yourself.
]

{ #category : #'as yet unclassified' }
WollokVMMethod >> initializeWithName: aString parameters: aCollection body: aBlockExpressionNode [ 
   name := aString.
   parameters := aCollection.
   body := aBlockExpressionNode.
]

{ #category : #'as yet unclassified' }
WollokVMMethod >> name [
	^ name
]

{ #category : #'as yet unclassified' }
WollokVMMethod >> selector [
	^ (name asString, '/' , parameters size asString) asSymbol.
]

{ #category : #'as yet unclassified' }
WollokVMMethod >> valueWithArguments: context [
  "| interpreter receiver arguments |
  interpreter := context first.
  receiver := context second.
  arguments := context allButFirst allButFirst.
  interpreter "
  | interpreter |
  interpreter := context first.
  ^  interpreter wollokNumberFrom: 42.
]
