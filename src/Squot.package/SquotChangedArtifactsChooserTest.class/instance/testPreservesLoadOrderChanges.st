testing
testPreservesLoadOrderChanges
	| patch selectedPatch |
	patch := SquotPatch builder
		addDiff: (SquotArtifactDiffMock path: '1');
		addDiff: (SquotArtifactDiffMock path: '2');
		newLoadOrder: #('2' '1');
		buildPatch.
	self assert: patch diffs size = 2;
		assert: (patch loadOrderDiff applyTo: #('1' '2')) = #('2' '1').
	tool := self newToolOn: patch.
	tool rootNodes. "generate nodes"
	"when"
	tool accept.
	selectedPatch := tool selectedPatch.
	"then"
	self assert: selectedPatch diffs size = 2;
		assert: (selectedPatch loadOrderDiff applyTo: #('1' '2')) = #('2' '1').