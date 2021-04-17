Class {
	#name : #WollokVMObject,
	#superclass : #Object,
	#traits : 'TWollokScope',
	#classTraits : 'TWollokScope classTrait',
	#instVars : [
		'wollokClass',
		'instanceVariables',
		'parentScope'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #accessing }
WollokVMObject >> atInstanceVariable: aVariableName put: aValue [
	instanceVariables at: aVariableName put: aValue
]

{ #category : #UI }
WollokVMObject >> gtInspectorVariablesIn: composite [
	<gtInspectorPresentationOrder: 1> 

	^ composite fastTable
		title: 'Wollok Inspector';
		display: [ self valueCollection ];
		column: 'Name' evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each key ];
		column: 'Value' evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each value ];
		send: [ :selection | 
			selection
				ifNil: [ nil ]
				ifNotNil: [ selection value ] ]
]

{ #category : #protected }
WollokVMObject >> hasOwnDefinitionFor: aName [
	^ instanceVariables includesKey: aName
	
]

{ #category : #accessing }
WollokVMObject >> initialize [
	instanceVariables := Dictionary new
]

{ #category : #accessing }
WollokVMObject >> instanceVariables [
	^ instanceVariables
]

{ #category : #accessing }
WollokVMObject >> instanceVariables: aCollection [ 
	instanceVariables := aCollection
]

{ #category : #accessing }
WollokVMObject >> instanceVariablesValues [

	self flag: #todo.
	^ #()
]

{ #category : #accessing }
WollokVMObject >> parentScope [
	^ parentScope
]

{ #category : #accessing }
WollokVMObject >> parentScope: aScope [ 
	parentScope := aScope
]

{ #category : #printing }
WollokVMObject >> printOn: aStream [

	super printOn: aStream.
	
	aStream
		space;
		nextPut: $(;
		print: wollokClass;
		nextPut: $)

		 
]

{ #category : #protected }
WollokVMObject >> readOwnVariableNamed: aName [
	^ instanceVariables at: aName
	
]

{ #category : #accessing }
WollokVMObject >> wollokClass [
	^ wollokClass
]

{ #category : #accessing }
WollokVMObject >> wollokClass: anObject [
	wollokClass := anObject
]

{ #category : #accessing }
WollokVMObject >> wollokClassName [
	
	^ wollokClass name
]

{ #category : #protected }
WollokVMObject >> writeOwnVariableNamed: aName value: aValue [
	instanceVariables at: aName put: aValue
	
]
