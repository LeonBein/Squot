patching
applyFilesDiff: anArtifactDiff
	"Fallback implementation if there is no special handling for external files."
	^ self applyDiff: anArtifactDiff toObjectAt: anArtifactDiff path