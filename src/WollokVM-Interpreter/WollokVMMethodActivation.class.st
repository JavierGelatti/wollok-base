Class {
	#name : #WollokVMMethodActivation,
	#superclass : #Object,
	#traits : 'TWollokScope',
	#classTraits : 'TWollokScope classTrait',
	#instVars : [
		'method',
		'class',
		'receiver',
		'arguments',
		'localVariables',
		'returnClosure',
		'parentScope'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokVMMethodActivation class >> newFor: aWollokMethod comingFrom: aWollokClass boundTo: aWollokObject withArguments: someArguments returningWith: aContinuationBlock parentScope: aScope [
	^ self new
			initializeWithMethod: aWollokMethod
			currentClass: aWollokClass
			receiver: aWollokObject
			arguments: someArguments
			returnClosure: aContinuationBlock
			parentScope: aScope;
		yourself.
]

{ #category : #'as yet unclassified' }
WollokVMMethodActivation >> at: aVariableName put: aWollokObject ifNotBound: aBlock [
	(localVariables includesKey: aVariableName) ifTrue: [
		localVariables at: aVariableName put: aWollokObject 
	] ifFalse: aBlock
]

{ #category : #accesing }
WollokVMMethodActivation >> currentClass [
	^ class
]

{ #category : #protected }
WollokVMMethodActivation >> hasOwnDefinitionFor: aName [
	
	^ (arguments union: localVariables) includesKey: aName.
]

{ #category : #initialization }
WollokVMMethodActivation >> initializeWithMethod: aWollokMethod currentClass: aWollokClass receiver: aWollokObject arguments: someArguments returnClosure: aBlock parentScope: aScope [
	method := aWollokMethod.
	class := aWollokClass.
	receiver := aWollokObject.
	localVariables := Dictionary new.
	returnClosure := aBlock.
	parentScope := aWollokObject.
	
	arguments := (method parameterNames with: someArguments collect: [:parameterName :argument |
		parameterName -> argument
	]) asDictionary.
]

{ #category : #accesing }
WollokVMMethodActivation >> method [
	^ method
]

{ #category : #protected }
WollokVMMethodActivation >> readOwnVariableNamed: aName [
	^ (arguments union: localVariables) at: aName
	
]

{ #category : #accesing }
WollokVMMethodActivation >> receiver [
	^ receiver
]

{ #category : #'as yet unclassified' }
WollokVMMethodActivation >> resolve: anIdentifier ifNotBound: aBlock [

	^ (arguments union: localVariables) at: anIdentifier ifAbsent: aBlock
]

{ #category : #'as yet unclassified' }
WollokVMMethodActivation >> return: aWollokObject [ 
	returnClosure value: aWollokObject
]

{ #category : #protected }
WollokVMMethodActivation >> writeOwnVariableNamed: aName value: aValue [
	localVariables at: aName put: aValue
	
]
