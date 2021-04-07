Class {
	#name : #WollokVMMethod,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #accessing }
WollokVMMethod >> arity [
	self subclassResponsibility
]

{ #category : #evaluating }
WollokVMMethod >> evaluateBoundTo: receiver with: arguments context: anInterpreter [ 
	self subclassResponsibility
]

{ #category : #accessing }
WollokVMMethod >> name [
	^ name
]

{ #category : #accessing }
WollokVMMethod >> selector [
	^ (name asString , '/' , self arity asString) asSymbol
]
