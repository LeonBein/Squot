Squot-diff-patching
squotApplyToLoaded: anObjectGraph
	"Modify anObject such that it matches what I model and answer the modified object, even if it was modified in-place."
	^ SquotObjectPatcher new
		registry: anObjectGraph;
		apply: self toLoadedGraph: anObjectGraph