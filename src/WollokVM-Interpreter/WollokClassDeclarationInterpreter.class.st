Class {
	#name : #WollokClassDeclarationInterpreter,
	#superclass : #Object,
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokClassDeclarationInterpreter class >> interpretClassNamed: aName from: anAST withNativeMethods: nativeMethodsDictionary [
	| aWollokClass |
	
	aWollokClass := anAST acceptVisitor: self new.
	^ aWollokClass
		name: aName;
		ast: anAST;
		mergeMethods: nativeMethodsDictionary;
		yourself.
]

{ #category : #visiting }
WollokClassDeclarationInterpreter >> visitClass: aClassNode [
   | class methods |
	class := WollokVMClass new.
	methods := aClassNode members collect: [ :memberNode | 
		memberNode acceptVisitor: self.
	].
  class methodDictionary: (methods collect: [ :method | method selector -> method ]) asDictionary.

	class instanceVariableDeclarations: aClassNode variables.

	^ class.
]

{ #category : #visiting }
WollokClassDeclarationInterpreter >> visitFile: aWollokFileNode [ 
   ^ aWollokFileNode elements first acceptVisitor: self.
]

{ #category : #visiting }
WollokClassDeclarationInterpreter >> visitMethodDeclaration: aMethodDeclarationNode [ 
	^ WollokVMCustomMethod 
	    named: aMethodDeclarationNode name value asSymbol 
		 withParameters: aMethodDeclarationNode parameters
	    withBody: aMethodDeclarationNode expression.

]
