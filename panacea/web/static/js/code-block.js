import * as Util from "./util"

export const generate = (lines, highlightLineNumber, surroundingLines = 2) => {
  const highlightIndex = highlightLineNumber - 1;

  const startIndex = Math.max(0, highlightIndex - surroundingLines);
  const endIndex   = Math.min(lines.length - 1, highlightIndex + surroundingLines) + 1;

  const displayLines = lines.slice(startIndex, endIndex);

  const codeBlock = Util.createElementWithClass('PRE', 'code-block');

  displayLines.forEach((lineContents, index) => {
    const lineNumber = startIndex + index + 1;
    const isHighlighted = lineNumber == highlightLineNumber;

    const line = generateLine(lineContents, lineNumber, isHighlighted)

    codeBlock.appendChild(line);
  })

  return codeBlock;
}

const generateLine = (contents, lineNumber, isHighlighted) => {
  const lineContainer = Util.createElementWithClass('SPAN', 'line');
  if (isHighlighted) {
    lineContainer.classList.add('highlighted');
  }

  const lineNumberSpan = Util.createElementWithClass('SPAN', 'ln');
  lineNumberSpan.innerHTML = lineNumber;

  const lineContentSpan = Util.createElementWithClass('SPAN', 'code');
  lineContentSpan.innerHTML = contents;

  lineContainer.appendChild(lineNumberSpan);
  lineContainer.appendChild(lineContentSpan);

  return lineContainer;
}
