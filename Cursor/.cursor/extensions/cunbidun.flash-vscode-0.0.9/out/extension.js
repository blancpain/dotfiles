"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = activate;
exports.deactivate = deactivate;
const vscode = __importStar(require("vscode"));
function activate(context) {
    // Decoration types for grey-out, highlight, and labels:
    const config = vscode.workspace.getConfiguration('flash-vscode');
    const dimColor = config.get('dimColor', 'rgba(128, 128, 128, 0.5)');
    const matchColor = config.get('matchColor', 'rgb(0,191,255)');
    const matchFontWeight = config.get('matchFontWeight', 'normal');
    const labelColor = config.get('labelColor', 'black');
    const labelBackgroundColor = config.get('labelBackgroundColor', '#a3be8c');
    const labelQuestionBackgroundColor = config.get('labelQuestionBackgroundColor', '#ebcb8b');
    const labelFontWeight = config.get('labelFontWeight', 'normal');
    // Define the character pool for labels: lowercase, then uppercase, then digits
    const labelChars = config.get('labelKeys', 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:\'",.<>/`~\\');
    const dimDecoration = vscode.window.createTextEditorDecorationType({
        color: dimColor
    });
    const matchDecoration = vscode.window.createTextEditorDecorationType({
        color: matchColor,
        fontWeight: matchFontWeight,
    });
    const labelDecoration = vscode.window.createTextEditorDecorationType({
        before: {
            color: labelColor,
            backgroundColor: labelBackgroundColor,
            fontWeight: labelFontWeight,
        }
    });
    const labelDecorationQuestion = vscode.window.createTextEditorDecorationType({
        before: {
            color: labelColor,
            backgroundColor: labelQuestionBackgroundColor,
            contentText: '?',
            fontWeight: labelFontWeight
        }
    });
    let active = false;
    let searchQuery = '';
    let isSelectionMode = false;
    // Map of label character to target position
    let labelMap = new Map();
    const searchChars = labelChars;
    // Helper to update all editor decorations based on current query
    function updateHighlights() {
        if (!active) {
            return;
        }
        ;
        labelMap.clear();
        const config = vscode.workspace.getConfiguration('flash-vscode');
        const caseSensitive = config.get('caseSensitive', true);
        // If query is empty, simply grey out everything (no matches to highlight)
        if (searchQuery.length === 0) {
            // Grey-out all visible text
            for (const editor of vscode.window.visibleTextEditors) {
                if (isSelectionMode && editor !== vscode.window.activeTextEditor) {
                    continue;
                }
                // Apply dim decoration to full visible ranges of each editor
                editor.setDecorations(dimDecoration, editor.visibleRanges);
                editor.setDecorations(labelDecoration, []);
                editor.setDecorations(labelDecorationQuestion, []);
            }
            return;
        }
        else {
            for (const editor of vscode.window.visibleTextEditors) {
                if (isSelectionMode && editor !== vscode.window.activeTextEditor) {
                    continue;
                }
                editor.setDecorations(dimDecoration, []);
            }
        }
        let allMatches = [];
        let allLabels = [];
        const allUnMatches = [];
        let nextChars = [];
        for (const editor of vscode.window.visibleTextEditors) {
            if (isSelectionMode && editor !== vscode.window.activeTextEditor) {
                continue;
            }
            const document = editor.document;
            for (const visibleRange of editor.visibleRanges) {
                const startLine = visibleRange.start.line;
                const endLine = visibleRange.end.line;
                // add some lines before and after the visible range to allUnMatches
                const startLineUnMatch = Math.max(0, startLine - 5);
                const endLineUnMatch = Math.min(document.lineCount - 1, endLine + 5);
                allUnMatches.push({
                    editor,
                    range: new vscode.Range(new vscode.Position(startLineUnMatch, 0), new vscode.Position(startLine, 0)),
                    matchStart: new vscode.Position(startLineUnMatch, 0)
                });
                allUnMatches.push({
                    editor,
                    range: new vscode.Range(new vscode.Position(endLine + 1, 0), new vscode.Position(endLineUnMatch, 0)),
                    matchStart: new vscode.Position(endLine, 0)
                });
                for (let lineNum = startLine; lineNum <= endLine; lineNum++) {
                    const lineText = document.lineAt(lineNum).text;
                    const textToSearch = caseSensitive ? lineText : lineText.toLowerCase();
                    const queryToSearch = caseSensitive ? searchQuery : searchQuery.toLowerCase();
                    // Search for all occurrences of queryToSearch in this line (case-sensitive)
                    let index = textToSearch.indexOf(queryToSearch);
                    let last_match_index = 0;
                    while (index !== -1) {
                        const matchStart = new vscode.Position(lineNum, index);
                        const matchEnd = new vscode.Position(lineNum, index + queryToSearch.length);
                        // set nextChar to the character after the match, if it exists
                        const nextChar = textToSearch[index + queryToSearch.length];
                        if (nextChar) {
                            nextChars.push(nextChar);
                        }
                        allMatches.push({ editor, range: new vscode.Range(matchStart, matchEnd), matchStart: matchStart });
                        const labelStart = new vscode.Position(lineNum, index + queryToSearch.length);
                        const labelEnd = new vscode.Position(lineNum, index + queryToSearch.length + 1);
                        allLabels.push({ editor, range: new vscode.Range(labelStart, labelEnd), matchStart: matchStart });
                        // continue searching from just after this match start
                        if (last_match_index < index) {
                            allUnMatches.push({
                                editor,
                                range: new vscode.Range(new vscode.Position(lineNum, last_match_index), matchStart),
                                matchStart: new vscode.Position(lineNum, index - 1)
                            });
                        }
                        last_match_index = index + queryToSearch.length;
                        index = textToSearch.indexOf(queryToSearch, index + 1);
                    }
                    if (last_match_index < textToSearch.length) {
                        allUnMatches.push({
                            editor,
                            range: new vscode.Range(new vscode.Position(lineNum, last_match_index), new vscode.Position(lineNum, textToSearch.length)),
                            matchStart: new vscode.Position(lineNum, textToSearch.length - 1)
                        });
                    }
                }
            }
        }
        const activeEditor = vscode.window.activeTextEditor;
        if (activeEditor) {
            const cursorPos = activeEditor.selection.active;
            // Helper function to compute Euclidean distance between two positions.
            function getDistance(pos1, pos2) {
                const lineDiff = pos1.line - pos2.line;
                const charDiff = pos1.character - pos2.character;
                return lineDiff * lineDiff * 10 + charDiff * charDiff + 4;
            }
            // Sort the matches by distance from the cursor.
            allLabels.sort((a, b) => {
                let weight_a = 1;
                let weight_b = 1;
                if (a.editor !== activeEditor) {
                    weight_a = 10000;
                }
                if (b.editor !== activeEditor) {
                    weight_b = 10000;
                }
                const distanceA = getDistance(cursorPos, a.matchStart) * weight_a;
                const distanceB = getDistance(cursorPos, b.matchStart) * weight_b;
                return distanceA - distanceB;
            });
        }
        // Decide how many (if any) to label:
        const totalMatches = allMatches.length;
        // deduplicate nextChars
        const allNextChars = [...new Set(nextChars)];
        // all characters that are in labelChars but not in allNextChars
        const useableLabelChars = labelChars.split('').filter(c => !allNextChars.includes(c));
        // create an label array with length equal to the number of matches, and fill it with the useableLabelChars
        // if there are more matches than useableLabelChars, then fill the array with the useableLabelChars and then
        // fill the rest with the question mark character
        const labelCharsToUse = totalMatches > useableLabelChars.length ?
            useableLabelChars.concat(Array(totalMatches - useableLabelChars.length).fill('?')) :
            useableLabelChars.slice(0, totalMatches);
        let charCounter = 0;
        let visibleEditors = vscode.window.visibleTextEditors;
        // move the active editor to the front of the array
        if (activeEditor) {
            visibleEditors = [activeEditor, ...vscode.window.visibleTextEditors.filter(e => e !== activeEditor)];
        }
        for (const editor of visibleEditors) {
            const decorationOptions = [];
            const questionDecorationOptions = [];
            editor.setDecorations(matchDecoration, allMatches.filter(m => m.editor === editor).map(m => m.range));
            editor.setDecorations(dimDecoration, allUnMatches.filter(m => m.editor === editor).map(m => m.range));
            // set the character before the match to the label character
            const ranges = allLabels.filter(m => m.editor === editor);
            for (let i = 0; i < ranges.length; i++) {
                let char = labelCharsToUse[charCounter];
                charCounter++;
                if (char !== '?') {
                    labelMap.set(char, { editor: editor, position: ranges[i].matchStart });
                    decorationOptions.push({
                        range: ranges[i].range,
                        renderOptions: {
                            before: { contentText: char }
                        }
                    });
                }
                else {
                    questionDecorationOptions.push({
                        range: ranges[i].range,
                        renderOptions: {
                            before: { contentText: '?' }
                        }
                    });
                }
            }
            editor.setDecorations(labelDecoration, decorationOptions);
            editor.setDecorations(labelDecorationQuestion, questionDecorationOptions);
            if (isSelectionMode) {
                break;
            }
        }
    }
    // Command to start navigation mode
    const _start = () => {
        if (active) {
            return;
        }
        ;
        active = true;
        searchQuery = '';
        labelMap.clear();
        // Set a context key for when-clause usage (for keybindings)
        vscode.commands.executeCommand('setContext', 'flash-vscode.active', true);
        // Initial highlight update (just grey out everything visible)
        updateHighlights();
    };
    const start = vscode.commands.registerCommand('flash-vscode.start', () => {
        isSelectionMode = false;
        _start();
    });
    const startSelection = vscode.commands.registerCommand('flash-vscode.startSelection', () => {
        isSelectionMode = true;
        _start();
    });
    // Exit navigation mode (clear decorations and reset state)
    const exit = vscode.commands.registerCommand('flash-vscode.exit', () => {
        if (!active) {
            return;
        }
        ;
        // Clear all decorations
        for (const editor of vscode.window.visibleTextEditors) {
            editor.setDecorations(dimDecoration, []);
            editor.setDecorations(matchDecoration, []);
            editor.setDecorations(labelDecoration, []);
            editor.setDecorations(labelDecorationQuestion, []);
        }
        active = false;
        searchQuery = '';
        labelMap.clear();
        vscode.commands.executeCommand('setContext', 'flash-vscode.active', false);
    });
    // Handle backspace: remove last character of query
    const backspaceHandler = vscode.commands.registerCommand('flash-vscode.backspace', () => {
        if (!active) {
            return;
        }
        ;
        if (searchQuery.length > 0) {
            searchQuery = searchQuery.slice(0, -1);
            updateHighlights();
        }
        else {
            // If query is empty, exit navigation (nothing to delete)
            vscode.commands.executeCommand('flash-vscode.exit');
        }
    });
    const jump = (target) => {
        const targetEditor = target.editor;
        const targetPos = target.position;
        targetEditor.selection = new vscode.Selection(isSelectionMode ? targetEditor.selection.anchor : targetPos, targetPos);
        targetEditor.revealRange(new vscode.Range(targetPos, targetPos));
        // If the target is in a different editor, focus that editor
        if (vscode.window.activeTextEditor !== targetEditor) {
            vscode.window.showTextDocument(targetEditor.document, targetEditor.viewColumn);
        }
    };
    // Override the 'type' command to capture alphanumeric/symbol keys while in nav mode
    const handleInput = (chr) => {
        if (chr === 'space') {
            chr = ' ';
        }
        const text = chr;
        if (!text) {
            return; // nothing to handle
        }
        // If in navigation mode:
        // Check if this key corresponds to an active jump label
        if (labelMap.size > 0 && labelMap.has(text)) {
            // We have a label matching this key – perform the jump
            const target = labelMap.get(text);
            jump(target);
            // Exit navigation mode after jumping
            vscode.commands.executeCommand('flash-vscode.exit');
            return;
        }
        // Append typed character to the search query
        searchQuery += text;
        updateHighlights();
    };
    // Listen to editor scroll/visible range changes to update highlights in real-time
    const visChange = vscode.window.onDidChangeTextEditorVisibleRanges(event => {
        if (active) {
            // Recompute highlights (this will use the same searchQuery)
            updateHighlights();
        }
    });
    const configChangeListener = vscode.workspace.onDidChangeConfiguration(event => {
        if (event.affectsConfiguration('flash-vscode.caseInsensitive')) {
            updateHighlights();
        }
    });
    let allChars = searchChars.split('').concat(['space']);
    context.subscriptions.push(configChangeListener, start, startSelection, exit, backspaceHandler, visChange, ...allChars.map(c => vscode.commands.registerCommand(`flash-vscode.jump.${c}`, () => handleInput(c))));
}
function deactivate() {
    // Clean up if needed (usually not much to do here for this extension)
}
//# sourceMappingURL=extension.js.map