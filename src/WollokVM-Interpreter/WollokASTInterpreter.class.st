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

{ #category : #visitor }
WollokASTInterpreter >> visitBinaryOperation: aBinaryOperationNode [
  | operator leftValue rightValue |

	leftValue := (aBinaryOperationNode leftOperand acceptVisitor: self) literalValue.
	rightValue := (aBinaryOperationNode rightOperand acceptVisitor: self) literalValue.
	operator := aBinaryOperationNode operation value.
	
	operator = '&&' ifTrue: [ ^ self wollokBooleanFrom: leftValue & rightValue ].
	operator = '||' ifTrue: [ ^ self wollokBooleanFrom: leftValue | rightValue ].
	
	operator = '>' ifTrue: [ ^ self wollokBooleanFrom: leftValue > rightValue ].
	operator = '<' ifTrue: [ ^ self wollokBooleanFrom: leftValue < rightValue ].
	operator = '+' ifTrue: [ ^ self wollokNumberFrom: leftValue + rightValue ].
	operator = '-' ifTrue: [ ^ self wollokNumberFrom: leftValue - rightValue ].
	operator = '/' ifTrue: [ ^ self wollokNumberFrom: leftValue / rightValue ].
	operator = '%' ifTrue: [ ^ self wollokNumberFrom: leftValue % rightValue ].
	operator = '*' ifTrue: [ ^ self wollokNumberFrom: leftValue * rightValue ].

	self notYetImplemented.
]

{ #category : #visit }
WollokASTInterpreter >> visitBooleanLiteral: aBooleanLiteralNode [

  ^ self wollokBooleanFrom: aBooleanLiteralNode booleanValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitMemberFeatureCall: aMemberFeatureCallNode [
	
	| receiver argument |
	
	receiver := (aMemberFeatureCallNode receiver acceptVisitor: self) literalValue.
	argument := 3.
	
	^ self wollokNumberFrom: (receiver truncateTo: 1 / (10 ** argument)) asFloat
]

{ #category : #visiting }
WollokASTInterpreter >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	^ self wollokNumberFrom: aWollokNumberLiteralNode numberValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitUnaryOperation: aUnaryOperationNode [ 
	
	| operand operator |
	operand := (aUnaryOperationNode rightOperand acceptVisitor: self) literalValue.
	
	operator := aUnaryOperationNode operation value.
	
	operator = '+' ifTrue: [ ^ self wollokNumberFrom: operand ].
	operator = '-' ifTrue: [ ^ self wollokNumberFrom: operand negated ].
	
  self notYetImplemented
]

{ #category : #'as yet unclassified' }
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
