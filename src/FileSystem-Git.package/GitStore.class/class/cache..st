instance creation
cache: aFilesystem
	^ self basicNew
		initializeWithCache: aFilesystem;
		yourself