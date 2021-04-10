Class {
	#name : #WollokClassDeclarationInterpreter,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #'instance creation' }
WollokClassDeclarationInterpreter class >> inContext: aContext [
	^ self new initializeWithContext: aContext; yourself.
]

{ #category : #'as yet unclassified' }
WollokClassDeclarationInterpreter class >> interpretClassNamed: aName from: anAST withNativeMethods: nativeMethodsDictionary resolvingReferencesWith: aContext [
	| aWollokClass |
	
	aWollokClass := anAST acceptVisitor: (self inContext: aContext).
	
	^ aWollokClass
		name: aName;
		ast: anAST;
		mergeMethods: nativeMethodsDictionary;
		yourself.
]

{ #category : #initialization }
WollokClassDeclarationInterpreter >> initializeWithContext: aContext [
	context := aContext
]

{ #category : #visiting }
WollokClassDeclarationInterpreter >> visitClass: aClassNode [
	| superclass methods class |

	superclass := aClassNode superclass ifNotNil: [ :superclassNode |
		| superclassIdentifier |
		superclassIdentifier := (superclassNode identifiers collect: [:id | id value]) joinUsing: '.'.
		context resolve: superclassIdentifier
	].
	
	methods := aClassNode members collect: [ :memberNode | 
		memberNode acceptVisitor: self.
	].

	class := WollokVMClass new.
	class superclass: superclass.
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
			withBody: aMethodDeclarationNode expression
]
