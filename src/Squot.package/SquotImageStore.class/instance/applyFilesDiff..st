patching
applyFilesDiff: aFileListDiff
	| object |
	self flag: 'The image store should not deal with files outside of the image'.
	object := objects at: aFileListDiff path.
	aFileListDiff applyToLoaded: object.