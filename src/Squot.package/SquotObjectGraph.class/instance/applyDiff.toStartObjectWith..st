patching
applyDiff: aDiff toStartObjectWith: aPatcher
	| oldStartObject newStartObject patchedShadow |
	"To handle the case that the start object is exchanged,
	try to retrieve the new name and update the start name."
	oldStartObject := self startObject.
	newStartObject := aPatcher apply: aDiff toLoaded: oldStartObject.
	patchedShadow := aPatcher shadowOf: newStartObject ifAbsent: [].
	patchedShadow hasSquotShadowName
		ifTrue: [startName := patchedShadow name.
			self assign: startName to: newStartObject]
		ifFalse: [oldStartObject ~~ newStartObject ifTrue:
				[self assign: startName to: newStartObject]].
	^ newStartObject