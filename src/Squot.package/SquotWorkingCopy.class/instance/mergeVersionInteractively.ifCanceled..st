loading and unloading
mergeVersionInteractively: aVersion ifCanceled: cancelBlock
	"Let the user choose artifact editions to load from aVersion and add the version as parent version."
	| mergeBases fastForwardPossible mergePatch |
	fastForwardPossible := false.
	mergeBases := self checkMergeBasesOfHeadVersionWith: aVersion
		ifNoCommonAncestor: ["the versions have no common base version"
			{SquotSnapshot empty}]
		ifAncestor:
			[self inform: 'Merge version already is an ancestor of the head of the active branch ', loadedHistorian name, '.'.
			^ cancelBlock value]
		ifDescendant: [fastForwardPossible := true].
	self flag: 'TODO: if there are multiple merge-bases, resolve conflicts recursively below'.
	mergePatch := SquotMergePatchBuilder new
		patchFrom: self currentSnapshot
		to: aVersion
		base: mergeBases anyOne.
	self loadPatchInteractively: mergePatch ifCanceled: [^ cancelBlock value].
	fastForwardPossible
		ifTrue: 
			[loadedHistorian version: aVersion.
			self loadedVersion: aVersion]
		ifFalse: [self addParentVersion: aVersion].