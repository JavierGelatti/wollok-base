Class {
	#name : #ClassDeclarationInterpreter,
	#superclass : #Object,
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
ClassDeclarationInterpreter >> visitClass: aClassNode [
   | class methods |
	class := WollokVMClass new.
	methods := aClassNode members collect: [ :memberNode | 
		memberNode acceptVisitor: self.
	].
   class methodDictionary: (methods collect: [ :method | method selector -> method ]) asDictionary.

	^ class.
]

{ #category : #'as yet unclassified' }
ClassDeclarationInterpreter >> visitFile: aWollokFileNode [ 
   ^ aWollokFileNode elements first acceptVisitor: self.
]

{ #category : #'as yet unclassified' }
ClassDeclarationInterpreter >> visitMethodDeclaration: aMethodDeclarationNode [ 
	^ WollokVMMethod 
	    named: aMethodDeclarationNode name value asSymbol 
		 withParameters: aMethodDeclarationNode parameters
	    withBody: aMethodDeclarationNode expression.

]
