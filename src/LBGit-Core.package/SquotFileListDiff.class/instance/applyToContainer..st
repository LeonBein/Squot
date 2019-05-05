applying
applyToContainer: anObjectContainer

	self hasChanges ifFalse: [^ nil].
	^ anObjectContainer applyFilesDiff: self