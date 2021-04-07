Class {
	#name : #WollokVMNativeMethod,
	#superclass : #Object,
	#instVars : [
		'nativeBlock'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokVMNativeMethod class >> fromBlocK: aBlock [
	^ self new initializeWithBlock: aBlock; yourself
]

{ #category : #'as yet unclassified' }
WollokVMNativeMethod >> evaluateBoundTo: receiver with: arguments context: anInterpreter [ 
	^ nativeBlock valueWithArguments: { anInterpreter . receiver }, arguments
]

{ #category : #'as yet unclassified' }
WollokVMNativeMethod >> initializeWithBlock: aBlock [
	nativeBlock := aBlock
]
