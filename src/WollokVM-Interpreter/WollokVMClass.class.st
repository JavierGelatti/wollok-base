Class {
	#name : #WollokVMClass,
	#superclass : #Object,
	#instVars : [
		'name',
		'ast',
		'methodDictionary',
		'instanceVariableDeclarations'
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
WollokVMClass >> instanceVariableDeclarations: instanceVariables [ 
	instanceVariableDeclarations := instanceVariables.
]

{ #category : #'as yet unclassified' }
WollokVMClass >> instanceVariablesForNewObjectInContext: aWollokASTInterpreter [ 
	^ (instanceVariableDeclarations collect: [ :instanceVariableDeclaration | | instanceVariableName instanceVariableValue |
		instanceVariableName := instanceVariableDeclaration variable name value.
		instanceVariableValue := instanceVariableDeclaration right ifNil: [
			aWollokASTInterpreter wollokNull
		] ifNotNil: [ :expressionForInitialValue |
			aWollokASTInterpreter interpretExpression: expressionForInitialValue
		].
		instanceVariableName -> instanceVariableValue
	]) asDictionary.
]

{ #category : #'as yet unclassified' }
WollokVMClass >> mergeMethods: anotherMethodDictionary [
	methodDictionary := methodDictionary union: anotherMethodDictionary.
]

{ #category : #accessing }
WollokVMClass >> methodDictionary: aMethodDictionary [
	methodDictionary := aMethodDictionary
]

{ #category : #'message execution' }
WollokVMClass >> methodFor: aSelector ifNone: aBlock [
	^ methodDictionary at: aSelector ifAbsent: aBlock.
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
