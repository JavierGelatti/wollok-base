Trait {
	#name : #TWollokScope,
	#instVars : [
		'parentScope'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #bindings }
TWollokScope >> declareVariableNamed: aName value: aValue [
	self writeOwnVariableNamed: aName value: aValue
	
]

{ #category : #protected }
TWollokScope >> hasOwnDefinitionFor: aName [
	^ self explicitRequirement
	
]

{ #category : #protected }
TWollokScope >> readOwnVariableNamed: aName [
	^ self explicitRequirement
	
]

{ #category : #bindings }
TWollokScope >> readVariableNamed: aName [ 
	^ (self scopeWithBindingFor: aName) readOwnVariableNamed: aName
	
]

{ #category : #private }
TWollokScope >> scopeWithBindingFor: aName [
	^ (self hasOwnDefinitionFor: aName)
		ifTrue: [ self ]
		ifFalse: [
			parentScope ifNil: [ self flag: #todo ] ifNotNil: [ parentScope scopeWithBindingFor: aName ]
		]
	
]

{ #category : #bindings }
TWollokScope >> updateVariableNamed: aName value: aValue [ 
	(self scopeWithBindingFor: aName) writeOwnVariableNamed: aName value: aValue
	
]

{ #category : #protected }
TWollokScope >> writeOwnVariableNamed: aName value: aValue [
	^ self explicitRequirement
	
]
