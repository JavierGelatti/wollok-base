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

	self notYetImplemented.
]

{ #category : #visit }
WollokASTInterpreter >> visitBooleanLiteral: aBooleanLiteralNode [

  ^ self wollokBooleanFrom: aBooleanLiteralNode booleanValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	^ self wollokNumberFrom: aWollokNumberLiteralNode numberValue
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> wollokBooleanFrom: aBooleanValue [

	^ WollokVMLiteral new
		wollokClass: (self resolve: 'wollok.lang.Boolean');
		literalValue: aBooleanValue;
		yourself
]

{ #category : #literals }
WollokASTInterpreter >> wollokNumberFrom: anInteger [ 

	^ WollokVMLiteral new
		wollokClass: (self resolve: 'wollok.lang.Number');
		literalValue: anInteger;
		yourself
]
