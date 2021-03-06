git porcelain
fetchFrom: aRemoteName
	| remote url fetchSpec packFile protocol remoteRefs wantRefs wantSignatures packFileData |
	remote := repository remoteNamed: aRemoteName.
	url := remote url.
	fetchSpec := remote fetchSpecs
		ifEmpty: [GitFetchSpec
					fromString: '+refs/heads/*:refs/remotes/', aRemoteName, '/*'
					forRemote: remote]
		ifNotEmpty: [:fetchSpecs | fetchSpecs first].
	self flag: #todo. "regard all fetch specs, not just the first one"
	protocol := GitAbstractProtocol url: url.
	protocol
		remote: remote;
		withOpenConnection:
			[remoteRefs := protocol refs.
			wantRefs := remoteRefs keys select: [:each | fetchSpec remoteRefPattern match: each].
			wantSignatures := wantRefs collect: [:each | remoteRefs at: each].
			packFileData := protocol wantAll: wantSignatures.
			packFile := GitPackFile readFrom: packFileData readStream].
	packFile repository: repository.
	packFile unpack.
	wantRefs do:
		[:each | repository
					updateRef: (remote trackingRefOf: each)
					to: (remoteRefs at: each)].