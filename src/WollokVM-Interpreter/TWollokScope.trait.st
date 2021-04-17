Trait {
	#name : #TWollokScope,
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

{ #category : #accessing }
TWollokScope >> parentScope [
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
			self parentScope ifNil: [ self flag: #todo ] ifNotNil: [ self parentScope scopeWithBindingFor: aName ]
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
