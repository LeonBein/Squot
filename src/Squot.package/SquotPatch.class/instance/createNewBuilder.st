copying
createNewBuilder
	| builder |
	builder := self species builder.
	self diffsDo: [:each | builder addDiff: each copy].
	builder loadOrderDiff: loadOrderDiff.
	^ builder