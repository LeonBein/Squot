tests
testMergeVersionWithLoadedObjects
	| sampleClass packagePath firstVersion addedMethod secondVersion packageInfo |
	"create a base version"
	classFactory cleanUp.
	self suppressChangeNotificationsDuring: [sampleClass := classFactory newClass].
	sampleClass compileSilently: 'firstMethod ^ self' classified: 'methods of first version'.
	packageInfo := PackageInfo named: classFactory packageName.
	workingCopy add: packageInfo at: 'src'.
	workingCopy saveNewVersionMessage: 'first version' interactive: false.
	packagePath := (workingCopy store pathsOf: packageInfo) anyOne.
	firstVersion := workingCopy baseVersion.
	"create unsaved changes"
	addedMethod := sampleClass compileSilently: 'addedMethod ^ self' classified: 'unsaved methods'.
	addedMethod := sampleClass >> addedMethod.
	"create a yet unloaded followup version"
	firstVersion snapshot in: [:firstSnapshot | | packageArtifact newSnapshot |
		packageArtifact := firstSnapshot artifactAt: packagePath.
		newSnapshot := firstSnapshot createNewBuilder
			add: (packageArtifact copyWithDifferentContent:
				((MCSnapshot fromDefinitions: packageArtifact packageArtifactDefinitions,
					{MCMethodDefinition className: sampleClass name
						selector: #anotherMethod category: 'methods of second version'
						timeStamp: 'whatever' source: 'anotherMethod ^ self'})
					asSquotArtifactForPackage: packageInfo) content);
			buildSnapshot.
		secondVersion := workingCopy loadedHistorian createNewVersion: newSnapshot
			with: [:newVersion | newVersion message: 'second version']].
	"merge the second version
	and assert that no attempt is made to discard the unsaved method"
	self suppressChangeNotificationsDuring:
	[[[workingCopy mergeVersionWithLoadedObjects: secondVersion
			ifCanceled: [self fail: 'should not reach here']]
		on: SquotSelectionOfChangesRequested do: [:request | | packageDiff |
			"make sure the unsaved method does not appear in the diff (will not be changed)"
			packageDiff := request patch diffAt: packagePath.
			self assert: (packageDiff diffOfTrackedObject operations
				noneSatisfy: [:each | each definition isMethodDefinition and: [each definition selector = addedMethod selector]]).
			self assert: packageDiff diffOfTrackedObject conflicts isEmpty.
			request resume: request patch "all of it"]]
		valueSupplyingAnswers: {{'*'. #default}}].
	self assert: addedMethod
		equals: sampleClass >> #addedMethod
		description: 'unsaved method unchanged after merge'.
	self assert: firstVersion equals: workingCopy loadedVersion.