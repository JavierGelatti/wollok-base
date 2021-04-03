Class {
	#name : #WollokBooleanLiteralNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'value'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokBooleanLiteralNode >> acceptVisitor: anAbstractNodeVisitor [
  ^ anAbstractNodeVisitor visitBooleanLiteral: self
]

{ #category : #converting }
WollokBooleanLiteralNode >> booleanValue [
	^ self source = 'true'
]

{ #category : #generated }
WollokBooleanLiteralNode >> tokenVariables [
	^ #(#value)
]

{ #category : #generated }
WollokBooleanLiteralNode >> value [
	^ value
]

{ #category : #generated }
WollokBooleanLiteralNode >> value: aSmaCCToken [
	value := aSmaCCToken
]
