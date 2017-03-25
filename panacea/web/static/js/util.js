export const createElementWithClass = (elementName, className) => {
  const element = document.createElement(elementName);
  element.classList.add(className);
  return element;
}

