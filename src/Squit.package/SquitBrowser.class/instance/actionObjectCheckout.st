actions on objects
actionObjectCheckout
	self projectSelection loadArtifactInteractively: self objectSelection artifact ifCanceled: [^self].