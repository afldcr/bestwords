var REGEX_URL = "https://raw.githubusercontent.com/afldcr/bestwords/master/bestwords.regexp";
var REGEX = null;
var BG_COLOR = "#ccffff";

function onInstall() {
  onOpen();
}

function onOpen() {
  var ui = DocumentApp.getUi();
  ui.createMenu("Bestwords")
    .addItem("Check", "check")
    .addItem("Clear", "clear")
    .addToUi()
}

function fetchRegex() {
  if (REGEX) { return REGEX; }
  var body = UrlFetchApp.fetch(REGEX_URL).getContentText();
  REGEX = body.substr(0, body.length - 1);
  return REGEX;
}

function check() {
  var body = DocumentApp.getActiveDocument().getBody();
  var regex = fetchRegex();
  var match = null;
  while (match = body.findText(regex, match)) {
    match.getElement()
        .asText()
        .setBackgroundColor(
          match.getStartOffset(),
          match.getEndOffsetInclusive(),
          BG_COLOR
        )
  }
}

function clear() {
  var body = DocumentApp.getActiveDocument().getBody();
  var match = null;
  while (match = body.findElement(DocumentApp.ElementType.TEXT, match)) {
        match.getElement()
        .asText()
        .setBackgroundColor(null)
  }
}
