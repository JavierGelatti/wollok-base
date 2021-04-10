Class {
	#name : #WollokVMMethodActivation,
	#superclass : #Object,
	#instVars : [
		'method',
		'class',
		'receiver',
		'arguments',
		'localVariables',
		'returnClosure'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokVMMethodActivation class >> newFor: aWollokMethod comingFrom: aWollokClass boundTo: aWollokObject withArguments: someArguments returningWith: aContinuationBlock [ 
	^ self new
			initializeWithMethod: aWollokMethod
			currentClass: aWollokClass
			receiver: aWollokObject
			arguments: someArguments
			returnClosure: aContinuationBlock;
		yourself.
]

{ #category : #'as yet unclassified' }
WollokVMMethodActivation >> at: aVariableName put: aWollokObject ifNotBound: aBlock [
	(localVariables includesKey: aVariableName) ifTrue: [
		localVariables at: aVariableName put: aWollokObject 
	] ifFalse: [
		(receiver instanceVariables includesKey: aVariableName) ifTrue: [
			receiver atInstanceVariable: aVariableName put: aWollokObject 
		] ifFalse: aBlock
	]
]

{ #category : #accesing }
WollokVMMethodActivation >> currentClass [
	^ class
]

{ #category : #'as yet unclassified' }
WollokVMMethodActivation >> declareVariableNamed: aString withInitialValue: aWollokObject [
	localVariables at: aString put: aWollokObject.
]

{ #category : #initialization }
WollokVMMethodActivation >> initializeWithMethod: aWollokMethod currentClass: aWollokClass receiver: aWollokObject arguments: someArguments returnClosure: aBlock [
	method := aWollokMethod.
	class := aWollokClass.
	receiver := aWollokObject.
	localVariables := Dictionary new.
	returnClosure := aBlock.
	
	arguments := (method parameterNames with: someArguments collect: [:parameterName :argument |
		parameterName -> argument
	]) asDictionary.
]

{ #category : #accesing }
WollokVMMethodActivation >> method [
	^ method
]

{ #category : #accesing }
WollokVMMethodActivation >> receiver [
	^ receiver
]

{ #category : #'as yet unclassified' }
WollokVMMethodActivation >> resolve: anIdentifier ifNotBound: aBlock [
	^ (receiver instanceVariables union: (arguments union: localVariables)) at: anIdentifier ifAbsent: aBlock
]

{ #category : #'as yet unclassified' }
WollokVMMethodActivation >> return: aWollokObject [ 
	returnClosure value: aWollokObject
]
