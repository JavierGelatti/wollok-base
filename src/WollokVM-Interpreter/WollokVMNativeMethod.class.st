Class {
	#name : #WollokVMNativeMethod,
	#superclass : #WollokVMMethod,
	#instVars : [
		'nativeBlock'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #'instance creation' }
WollokVMNativeMethod class >> named: aMethodName definedAs: aBlock [
	^ self new initializeNamed: aMethodName definedAs: aBlock; yourself
]

{ #category : #accessing }
WollokVMNativeMethod >> arity [

	^ nativeBlock argumentCount - 2 "the interpreter and the receiver"
]

{ #category : #evaluating }
WollokVMNativeMethod >> evaluateBoundTo: receiver with: arguments context: anInterpreter [ 
	^ nativeBlock valueWithArguments: { anInterpreter . receiver }, arguments
]

{ #category : #initialization }
WollokVMNativeMethod >> initializeNamed: aMethodName definedAs: aBlock [
	name := aMethodName.
	nativeBlock := aBlock
]
