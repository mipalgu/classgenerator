import Foundation

import Helpers
import Creators
import Containers
import IO
import Parsers
import Main

let container = WarningsContainerRef()

let generator = ClassGenerator(
    parser: ClassParser(
        container: container,
        sectionsParser: SectionsParser(container: container, reader: FoundationFileReader()),
        variablesParser: VariablesTableParser(
            container: container,
            parser: VariableParser(container: container)
        )
    ),
    printer: CommandLinePrinter(
        errorStream: StderrOutputStream(),
        messageStream: StdoutOutputStream(),
        warningStream: StdoutOutputStream()
    ),
    creatorHelpersFactory: CreatorHelpersFactory(),
    cHeaderCreatorFactory: CHeaderCreatorFactory(),
    cFileCreatorFactory: CFileCreatorFactory(),
    cppHeaderCreatorFactory: CPPHeaderCreatorFactory(),
    swiftFileCreatorFactory: SwiftFileCreatorFactory()
)

generator.run(CommandLine.arguments)
