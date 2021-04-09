Class {
	#name : #WollokASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'bindings',
		'returnBinding',
		'receiverBinding'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #bindings }
WollokASTInterpreter >> addBinding: aName value: aWollokVMClass [ 
	
	bindings at: aName put: aWollokVMClass
]

{ #category : #bindings }
WollokASTInterpreter >> addBindingOfClass: aName fromString: aString [

	WollokReducedLoader new addBindingOfClass: aName fromString: aString in: self
]

{ #category : #interpreting }
WollokASTInterpreter >> initialize [

	super initialize.

	bindings := Dictionary new.
	
	WollokReducedLoader new loadInto: self
]

{ #category : #interpreting }
WollokASTInterpreter >> interpretExpression: anExpressionNode [ 

	^ anExpressionNode acceptVisitor: self
]

{ #category : #interpreting }
WollokASTInterpreter >> interpretExpression: anExpressionNode withinReceiver: aWollokObject withAdditionalBindings: arguments [ 
	receiverBinding := aWollokObject.
	bindings := bindings union: arguments.
	^ self interpretExpression: anExpressionNode.
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
WollokASTInterpreter >> resolve: aString [ 
	
	^ bindings at: aString
]

{ #category : #'message sending' }
WollokASTInterpreter >> send: selector to: receiver with: arguments [
	| method |
	
	method := receiver wollokClass
		methodFor: selector
		ifNone: [ self notYetImplemented "method not found" ]. 
		
	^ method evaluateBoundTo: receiver with: arguments context: self
]

{ #category : #visiting }
WollokASTInterpreter >> visitAssignment: anAssignmentNode [ 
	| variableName variableValue |
	variableName := anAssignmentNode variable name value.
	variableValue := self interpretExpression: anAssignmentNode value.
	
	bindings at: variableName put: variableValue.
	
	^ variableValue.
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
  returnBinding := [ :valueToReturn | ^ valueToReturn ].
	^ (aBlockExpressionNode expressions collect: [ :expression | self interpretExpression: expression ]) last.
]

{ #category : #visiting }
WollokASTInterpreter >> visitBooleanLiteral: aBooleanLiteralNode [

  ^ self wollokBooleanFrom: aBooleanLiteralNode booleanValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitClosure: aClosureNode [ 
	^ self interpretExpression: aClosureNode expression.
]

{ #category : #visiting }
WollokASTInterpreter >> visitConstructorCall: aConstructorCallNode [
   | className class instanceVariables |

	className := aConstructorCallNode classRef identifiers first value.
	class := self resolve: className.
	instanceVariables := 	class instanceVariablesForNewObjectInContext: self.
		
   ^ WollokVMObject new
			wollokClass: class;
			instanceVariables: instanceVariables;
       yourself.
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

{ #category : #visiting }
WollokASTInterpreter >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	^ self wollokNumberFrom: aWollokNumberLiteralNode numberValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitReturnExpression: aReturnExpressionNode [
  | result |
  result := self interpretExpression: aReturnExpressionNode expression.

  returnBinding value: result.
]

{ #category : #visiting }
WollokASTInterpreter >> visitStringLiteral: aStringLiteralNode [

	^ self wollokStringFrom: aStringLiteralNode stringValue
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
	^ bindings at: variableName ifAbsent: [
		receiverBinding instanceVariableNamed: variableName
	].
]

{ #category : #visiting }
WollokASTInterpreter >> visitVariableDeclaration: aVariableDeclarationNode [

	| variableName variableValue |
	variableName := aVariableDeclarationNode variable name value.
	variableValue := self interpretExpression: aVariableDeclarationNode right.
	
	bindings at: variableName put: variableValue.
	
	^ variableValue.
	
]

{ #category : #literals }
WollokASTInterpreter >> wollokBooleanFrom: aSmalltalkBoolean [

	^ WollokVMLiteral new
		   wollokClass: (self resolve: 'wollok.lang.Boolean');
		   literalValue: aSmalltalkBoolean;
		   yourself
]

{ #category : #literals }
WollokASTInterpreter >> wollokNull [
	^ WollokVMNull new
]

{ #category : #literals }
WollokASTInterpreter >> wollokNumberFrom: anInteger [ 

	^ WollokVMLiteral new
		wollokClass: (self resolve: 'wollok.lang.Number');
		literalValue: anInteger;
		yourself
]

{ #category : #literals }
WollokASTInterpreter >> wollokStringFrom: aSmalltalkString [ 
	
	^ WollokVMLiteral new
		   wollokClass: (self resolve: 'wollok.lang.String');
		   literalValue: aSmalltalkString;
		   yourself
]
