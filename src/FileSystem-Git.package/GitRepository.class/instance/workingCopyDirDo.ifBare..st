public-locations
workingCopyDirDo: aBlock ifBare: bareRepositoryBlock
	| worktree |
	self hasWorkingCopy ifFalse: [^ bareRepositoryBlock value].
	worktree := self configAt: 'core.worktree' ifAbsent: ['..'].
	^ aBlock value: (self baseDir resolve: worktree)