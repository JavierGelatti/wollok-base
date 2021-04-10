Class {
	#name : #WollokVMClass,
	#superclass : #Object,
	#instVars : [
		'name',
		'ast',
		'methodDictionary',
		'instanceVariableDeclarations',
		'superclass'
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
WollokVMClass >> instanceVariableDeclarations [

	| instanceVariableDeclarationsFromSuperclass instanceVariableDeclarationsFromMyself |
	
	instanceVariableDeclarationsFromSuperclass := superclass ifNil: [ Dictionary new ] ifNotNil: [ superclass instanceVariableDeclarations ].

  instanceVariableDeclarationsFromMyself := (instanceVariableDeclarations collect: [ :instanceVariableDeclaration |
	  | instanceVariableName instanceVariableValue |
		instanceVariableName := instanceVariableDeclaration variable name value.
		instanceVariableValue := instanceVariableDeclaration right.
		instanceVariableName -> instanceVariableValue
	]) asDictionary.

	^ instanceVariableDeclarationsFromSuperclass union: instanceVariableDeclarationsFromMyself
]

{ #category : #accessing }
WollokVMClass >> instanceVariableDeclarations: instanceVariables [ 
	instanceVariableDeclarations := instanceVariables.
]

{ #category : #'as yet unclassified' }
WollokVMClass >> instanceVariablesForNewObjectInContext: aWollokASTInterpreter [
  | initializedInstanceVariables |
	initializedInstanceVariables := Dictionary new.
	self instanceVariableDeclarations keysAndValuesDo: [ :instanceVariableName :expressionForInitialValue |
		initializedInstanceVariables
			at: instanceVariableName
			put: (self interpret: expressionForInitialValue using: aWollokASTInterpreter)
	].
	^ initializedInstanceVariables
]

{ #category : #'as yet unclassified' }
WollokVMClass >> interpret: expressionForInitialValue using: aWollokASTInterpreter [
	^ expressionForInitialValue
		ifNil: [ aWollokASTInterpreter wollokNull ]
		ifNotNil: [ aWollokASTInterpreter interpretExpression: expressionForInitialValue ]
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
	^ self -> (methodDictionary at: aSelector ifAbsent: [
		superclass ifNil: [ ^ aBlock value 	].

		^ superclass methodFor: aSelector ifNone: aBlock
	]).
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

{ #category : #accessing }
WollokVMClass >> superclass [
	^ superclass
]

{ #category : #accessing }
WollokVMClass >> superclass: aWollokClass [ 
	superclass := aWollokClass
]
