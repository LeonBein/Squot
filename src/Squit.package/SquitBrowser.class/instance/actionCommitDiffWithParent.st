actions on versions
actionCommitDiffWithParent
	(SquotDiffExplorer
		from: (self commitSelection parents at: 1 ifAbsent: [SquotSnapshot empty])
		to: self commitSelection)
	openLabel: 'Comparing versions'.