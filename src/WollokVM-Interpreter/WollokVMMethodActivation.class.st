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

{ #category : #accessing }
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

{ #category : #accessing }
WollokVMMethodActivation >> method [
	^ method
]

{ #category : #accessing }
WollokVMMethodActivation >> parentScope [
	^ parentScope
]

{ #category : #protected }
WollokVMMethodActivation >> readOwnVariableNamed: aName [
	^ (arguments union: localVariables) at: aName
	
]

{ #category : #accessing }
WollokVMMethodActivation >> receiver [
	^ receiver
]

{ #category : #'as yet unclassified' }
WollokVMMethodActivation >> return: aWollokObject [ 
	returnClosure value: aWollokObject
]

{ #category : #protected }
WollokVMMethodActivation >> writeOwnVariableNamed: aName value: aValue [
	localVariables at: aName put: aValue
	
]
