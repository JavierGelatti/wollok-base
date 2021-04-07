Class {
	#name : #ClassDeclarationInterpreter,
	#superclass : #Object,
	#category : #'WollokVM-Interpreter'
}

{ #category : #visiting }
ClassDeclarationInterpreter >> visitClass: aClassNode [
   | class methods |
	class := WollokVMClass new.
	methods := aClassNode members collect: [ :memberNode | 
		memberNode acceptVisitor: self.
	].
   class methodDictionary: (methods collect: [ :method | method selector -> method ]) asDictionary.

	^ class.
]

{ #category : #visiting }
ClassDeclarationInterpreter >> visitFile: aWollokFileNode [ 
   ^ aWollokFileNode elements first acceptVisitor: self.
]

{ #category : #visiting }
ClassDeclarationInterpreter >> visitMethodDeclaration: aMethodDeclarationNode [ 
	^ WollokVMCustomMethod 
	    named: aMethodDeclarationNode name value asSymbol 
		 withParameters: aMethodDeclarationNode parameters
	    withBody: aMethodDeclarationNode expression.

]
