Class {
	#name : #WollokVMClass,
	#superclass : #Object,
	#instVars : [
		'name',
		'ast',
		'methodDictionary'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #accessing }
WollokVMClass >> allVariables [

	self flag: #todo.
	^ #()
]

{ #category : #accessing }
WollokVMClass >> ast [
	^ ast
]

{ #category : #accessing }
WollokVMClass >> ast: anObject [
	ast := anObject
]

{ #category : #accessing }
WollokVMClass >> methodDictionary: aMethodDictionary [
	methodDictionary := aMethodDictionary
]

{ #category : #'message execution' }
WollokVMClass >> methodFor: aSelector ifNone: aBlock [
	^methodDictionary at: aSelector ifAbsent: aBlock.
]

{ #category : #accessing }
WollokVMClass >> name [
	^ name
]

{ #category : #accessing }
WollokVMClass >> name: anObject [
	name := anObject
]

{ #category : #printing }
WollokVMClass >> printOn: aStream [

	super printOn: aStream.
	
	aStream
		space;
		nextPut: $(;
		print: name;
		nextPut: $)
		 
]
