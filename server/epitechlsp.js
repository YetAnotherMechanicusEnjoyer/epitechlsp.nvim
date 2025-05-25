#!/usr/bin/env node

const {
  createConnection,
  TextDocuments,
  DiagnosticSeverity,
} = require('vscode-languageserver/node');
const cp = require('child_process');
const path = require('path');
const url = require('url');
const cdsDB = require('./cds.json');

const connection = createConnection(process.stdin, process.stdout);
const documents = new TextDocuments();

connection.onInitialize(() => {
  return {
    capabilities: {
      textDocumentSync: documents.syncKind,
    },
  };
});

documents.listen(connection);
connection.listen();

function parseEcslsOutput(output) {
  const diagnosticsByFile = {};
  const lines = output.split("\n");
  const regex = /^(.*?):(\d+): error: (.+)$/;

  for (const line of lines) {
    const match = line.match(regex);
    if (!match) continue;

    const [_, file, lineNumStr, rawCode] = match;
    const lineNum = parseInt(lineNumStr, 10) - 1;

    const code = rawCode.trim().split(":").pop();
    console.log(code);
    const def = cdsDB[code] || {
      label: code,
      description: "Unknown error",
      severity: 2,
      category: "Unknown",
    };

    const diagnostic = {
      range: {
        start: { line: lineNum, character: 0 },
        end: { line: lineNum, character: 1 }
      },
      message: `${def.label}\n${def.description}`,
      severity: def.severity,
      source: "epitechlsp",
      code,
      data: {
        category: def.category,
      },
    };
    const fileUri = url.pathToFileURL(path.resolve(file)).toString();
    diagnosticsByFile[fileUri] = diagnosticsByFile[fileUri] || [];
    diagnosticsByFile[fileUri].push(diagnostic);
  }

  return diagnosticsByFile;
}

function runEcsls() {
  try {
    const output = cp.execSync('ecsls_run', {
      encoding: 'utf-8',
      cwd: process.cwd(),
    });

    const diagnostics = parseEcslsOutput(output);
    for (const [uri, diags] of Object.entries(diagnostics)) {
      connection.sendDiagnostics({ uri, diagnostics: diags });
    }
  } catch (err) {
    connection.console.error(err.message);
  }
}

connection.onInitialized(() => {
  runEcsls();
});

connection.onDidSaveTextDocument((params) => {
  runEcsls();
});
