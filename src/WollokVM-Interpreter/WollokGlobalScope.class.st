Class {
	#name : #WollokGlobalScope,
	#superclass : #Object,
	#traits : 'TWollokScope',
	#classTraits : 'TWollokScope classTrait',
	#instVars : [
		'bindings'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #protected }
WollokGlobalScope >> hasOwnDefinitionFor: aName [
	^ bindings includesKey: aName
	
]

{ #category : #bindings }
WollokGlobalScope >> initialize [
	bindings := Dictionary new
]

{ #category : #accessing }
WollokGlobalScope >> parentScope [
	^ nil
]

{ #category : #protected }
WollokGlobalScope >> readOwnVariableNamed: aName [
	^ bindings at: aName
	
]

{ #category : #bindings }
WollokGlobalScope >> valueFor: aName [
	
	^ bindings at: aName
]

{ #category : #bindings }
WollokGlobalScope >> writeAt: aName value: aValue [
	bindings at: aName put: aValue.
]

{ #category : #protected }
WollokGlobalScope >> writeOwnVariableNamed: aName value: aValue [
	bindings at: aName put: aValue
	
]
