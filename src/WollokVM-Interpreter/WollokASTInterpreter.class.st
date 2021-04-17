Class {
	#name : #WollokASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'contextStack',
		'globalScope'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #bindings }
WollokASTInterpreter >> addBinding: aName value: aWollokVMClass [
	globalScope declareVariableNamed: aName value: aWollokVMClass
]

{ #category : #bindings }
WollokASTInterpreter >> addBindingOfClass: aName fromString: aString [

	WollokReducedLoader new addBindingOfClass: aName fromString: aString in: self
]

{ #category : #bindings }
WollokASTInterpreter >> currentClass [
	^ contextStack top currentClass
]

{ #category : #bindings }
WollokASTInterpreter >> currentMethod [
	^ contextStack top method
]

{ #category : #bindings }
WollokASTInterpreter >> currentReceiver [
	^ contextStack top receiver
]

{ #category : #interpreting }
WollokASTInterpreter >> initialize [

	super initialize.

	globalScope := WollokGlobalScope new.
	contextStack := Stack new.
	
	WollokReducedLoader new loadInto: self
]

{ #category : #interpreting }
WollokASTInterpreter >> interpretExpression: anExpressionNode [ 

	^ anExpressionNode acceptVisitor: self
]

{ #category : #interpreting }
WollokASTInterpreter >> interpretProgram: aFileNode [ 

	| lastValue |

	aFileNode main elements do: [ :e | lastValue := e acceptVisitor: self ].

	^ lastValue	
]

{ #category : #testing }
WollokASTInterpreter >> isFalse: aWollokVMObject [
	^ aWollokVMObject literalValue = false
]

{ #category : #testing }
WollokASTInterpreter >> isNull: aWollokObject [
	^ aWollokObject isKindOf: WollokVMNull
]

{ #category : #testing }
WollokASTInterpreter >> isTrue: aWollokVMObject [
	^ aWollokVMObject literalValue = true
]

{ #category : #bindings }
WollokASTInterpreter >> resolve: aName [
	^ contextStack isEmpty
		ifTrue: [ globalScope valueFor: aName ]
		ifFalse: [ contextStack top readVariableNamed: aName ]
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> return: aWollokObject [
	contextStack pop return: aWollokObject
]

{ #category : #'message sending' }
WollokASTInterpreter >> send: selector to: receiver with: arguments [
	^ self send: selector to: receiver with: arguments startingLookupFrom: receiver wollokClass.
]

{ #category : #'message sending' }
WollokASTInterpreter >> send: selector to: receiver with: arguments startingLookupFrom: aWollokClass [
	| methodWithClass class method result methodActivation |
	
	methodWithClass := aWollokClass
		methodFor: selector
		ifNone: [ Error signal: 'method ', selector asString, ' not found for ', receiver wollokClass name ].
	
	method := methodWithClass value.
	class := methodWithClass key.
	
	methodActivation := WollokVMMethodActivation newFor: method comingFrom: class boundTo: receiver withArguments: arguments returningWith: [:x | ^ x] parentScope: globalScope.
	
	contextStack push: methodActivation.
	result := method evaluateBoundTo: receiver with: arguments context: self.
	contextStack pop.
	
	^ result
]

{ #category : #visiting }
WollokASTInterpreter >> visitAssignment: anAssignmentNode [
	| variableName variableValue |
	variableName := anAssignmentNode variable name value.
	variableValue := self interpretExpression: anAssignmentNode value.
	contextStack isEmpty
		ifTrue: [ globalScope writeAt: variableName value: variableValue ]
		ifFalse: [ contextStack top updateVariableNamed: variableName value: variableValue ].
	^ variableValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitBinaryOperation: aBinaryOperationNode [
  | operator leftValue rightValue |

	leftValue := (aBinaryOperationNode leftOperand acceptVisitor: self).
	rightValue := (aBinaryOperationNode rightOperand acceptVisitor: self).
	operator := aBinaryOperationNode operation value.
	
	^ self send: (operator, '/1') asSymbol to: leftValue with: { rightValue }
]

{ #category : #visiting }
WollokASTInterpreter >> visitBlockExpression: aBlockExpressionNode [

	| expressions |
	expressions := aBlockExpressionNode expressions.
	
	^ expressions ifEmpty: [
		self wollokNull
	] ifNotEmpty: [
		(expressions collect: [ :expression | self interpretExpression: expression ]) last
	].
]

{ #category : #visiting }
WollokASTInterpreter >> visitBooleanLiteral: aBooleanLiteralNode [

  ^ self wollokBooleanFrom: aBooleanLiteralNode booleanValue
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> visitClosure: aClosureNode [ 
	^ self interpretExpression: aClosureNode expression.
]

{ #category : #visiting }
WollokASTInterpreter >> visitConstructorCall: aConstructorCallNode [
   | className class instanceVariables newObject |

	className := aConstructorCallNode classRef identifiersAsString.
	class := self resolve: className.
	instanceVariables := 	class instanceVariablesForNewObjectInContext: self.
		
   newObject := WollokVMObject new
			wollokClass: class;
			instanceVariables: instanceVariables;
			parentScope: globalScope;
       yourself.
	
	self send: #'initialize/0' to: newObject with: #().
	
	^ newObject.
]

{ #category : #visiting }
WollokASTInterpreter >> visitIfExpression: anIfExpressionNode [
	| condition |
	
	condition := anIfExpressionNode condition acceptVisitor: self.
	
	^ condition literalValue
		ifTrue: [ anIfExpressionNode then acceptVisitor: self ]
		ifFalse: [ anIfExpressionNode else acceptVisitor: self ].
]

{ #category : #visiting }
WollokASTInterpreter >> visitMemberFeatureCall: aMemberFeatureCallNode [

	| receiver arguments featureName |
	
	receiver := aMemberFeatureCallNode receiver acceptVisitor: self.
	arguments := aMemberFeatureCallNode arguments collect: [ :argument | argument acceptVisitor: self ].
	featureName := aMemberFeatureCallNode feature value.

	^ self send: (featureName, '/' , arguments size asString) asSymbol to: receiver with: arguments.
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> visitNullLiteral: aNullLiteralNode [ 
	^ self wollokNull.
]

{ #category : #visiting }
WollokASTInterpreter >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	^ self wollokNumberFrom: aWollokNumberLiteralNode numberValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitReturnExpression: aReturnExpressionNode [
  | result |
  result := self interpretExpression: aReturnExpressionNode expression.

  self return: result.
]

{ #category : #visiting }
WollokASTInterpreter >> visitSelf: aSelfNode [ 
	^ self currentReceiver
]

{ #category : #visiting }
WollokASTInterpreter >> visitStringLiteral: aStringLiteralNode [

	^ self wollokStringFrom: aStringLiteralNode stringValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitSuperInvocation: aSuperInvocationNode [ 
	| arguments |
	
	arguments := aSuperInvocationNode arguments collect: [ :argument | argument acceptVisitor: self ].

	^ self send: self currentMethod selector to: self currentReceiver with: arguments startingLookupFrom: self currentClass superclass.
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> visitThrow: aThrowNode [ 
	| anExceptionToThrow |
	anExceptionToThrow := self interpretExpression: aThrowNode exception.
	
	(WollokError new wollokException: anExceptionToThrow) signal.
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> visitTry: aTryNode [ 
	| expressionToTry |
	expressionToTry := aTryNode expression.
	
	[ |result|
		result := self interpretExpression: expressionToTry.
		aTryNode alwaysExpression ifNotNil: [ 
			self interpretExpression: aTryNode alwaysExpression.
		].
		^ result.
	] on: WollokError do: [:aWollokError | | catchBlock catchResult |
		catchBlock := aTryNode catchBlocks detect: [:aCatchBlock |
			aWollokError wollokException wollokClass isIdentifiedBy: aCatchBlock exceptionType.
		].
		
		catchResult := self interpretExpression: catchBlock expression.
		self interpretExpression: aTryNode alwaysExpression.
		^ catchResult.
	]
]

{ #category : #visiting }
WollokASTInterpreter >> visitUnaryOperation: aUnaryOperationNode [ 
	
	| operand operator |
	operand := aUnaryOperationNode rightOperand acceptVisitor: self.
	operator := aUnaryOperationNode operation value.
	
	^ self send: ('@', operator, '/0') asSymbol to: operand with: { }
]

{ #category : #visiting }
WollokASTInterpreter >> visitVariable: aVariableNode [
	| variableName |
	variableName := aVariableNode name value.
	^ self resolve: variableName
]

{ #category : #visiting }
WollokASTInterpreter >> visitVariableDeclaration: aVariableDeclarationNode [
	| variableName variableValue |
	variableName := aVariableDeclarationNode variable name value.
	variableValue := self
		interpretExpression: aVariableDeclarationNode right.
	contextStack isEmpty
		ifTrue: [ globalScope declareVariableNamed: variableName value: variableValue ]
		ifFalse: [ contextStack top
				declareVariableNamed: variableName
				value: variableValue ].
	^ variableValue
]

{ #category : #literals }
WollokASTInterpreter >> wollokBooleanFrom: aSmalltalkBoolean [

	^ WollokVMLiteral new
		   wollokClass: (self resolve: 'wollok.lang.Boolean');
		   literalValue: aSmalltalkBoolean;
			 parentScope: globalScope;
			 yourself
]

{ #category : #literals }
WollokASTInterpreter >> wollokNull [
	^ WollokVMNull new yourself
]

{ #category : #literals }
WollokASTInterpreter >> wollokNumberFrom: anInteger [ 

	^ WollokVMLiteral new
		wollokClass: (self resolve: 'wollok.lang.Number');
		literalValue: anInteger;
		parentScope: globalScope;
		yourself
]

{ #category : #literals }
WollokASTInterpreter >> wollokStringFrom: aSmalltalkString [ 
	
	^ WollokVMLiteral new
		   wollokClass: (self resolve: 'wollok.lang.String');
		   literalValue: aSmalltalkString;
			 parentScope: globalScope;
		   yourself
]
