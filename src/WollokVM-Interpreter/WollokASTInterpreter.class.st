Class {
	#name : #WollokASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'bindings'
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
WollokASTInterpreter >> visitBinaryOperation: aBinaryOperationNode [
  | operator leftValue rightValue |

	leftValue := (aBinaryOperationNode leftOperand acceptVisitor: self).
	rightValue := (aBinaryOperationNode rightOperand acceptVisitor: self).
	operator := aBinaryOperationNode operation value.
	
	^ self send: (operator, '/1') asSymbol to: leftValue with: { rightValue }
]

{ #category : #visiting }
WollokASTInterpreter >> visitBooleanLiteral: aBooleanLiteralNode [

  ^ self wollokBooleanFrom: aBooleanLiteralNode booleanValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitConstructorCall: aConstructorCallNode [
   | className |

	className := aConstructorCallNode classRef identifiers first value.
   ^ WollokVMObject new wollokClass: (self resolve: className); 
       yourself.
]

{ #category : #visiting }
WollokASTInterpreter >> visitIfExpression: anIfExpressionNode [
   | condition then else |
	condition := anIfExpressionNode condition acceptVisitor: self.
	then := anIfExpressionNode then acceptVisitor: self.
	else := anIfExpressionNode else acceptVisitor: self.
	
	condition literalValue ifTrue: [ 
		^ then
	] ifFalse: [ 
		^ else  
	].

	self shouldBeImplemented.
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

{ #category : #literals }
WollokASTInterpreter >> wollokBooleanFrom: aSmalltalkBoolean [

	^ WollokVMLiteral new
		   wollokClass: (self resolve: 'wollok.lang.Boolean');
		   literalValue: aSmalltalkBoolean;
		   yourself
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
