*Squot-trackable
asSquotLiveArtifactAt: aPath in: aStore
	^ (SquotLiveArtifact on: self at: aPath in: aStore)
		storeInfo: (aStore metadataForObjectAt: aPath);
		yourself