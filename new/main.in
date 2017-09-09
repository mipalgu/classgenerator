import Foundation

let generator = ClassGenerator(printer: CommandLinePrinter(
    errorStream: StderrOutputStream(),
    messageStream: StdoutOutputStream(),
    warningStream: StdoutOutputStream()
))

generator.run(CommandLine.arguments)

