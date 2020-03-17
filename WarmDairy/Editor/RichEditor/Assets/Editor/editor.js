"use strict";
const container = document.getElementById("editor"),
  editor = new Squire(container, {
    blockTag: "div",
    tagAttributes: {
      a: {
        target: "_blank"
      }
    }
  }),
  tagName = {
    bold: "b",
    italic: "i",
    strikethrough: "del",
    underline: "u",
    link: "a"
  };
var lastFontInfo = {},
  newFontInfo = {},
  lastFormat = {
    bold: !1,
    italic: !1,
    strikethrough: !1,
    underline: !1,
    link: !1
  },
  newFormat = clone(lastFormat),
  lastHeight = 0,
  newHeight = 0,
  isFocused = !1;


// 失去焦点的时候检测是否有文本，如果没有，添加 placeholder
function setPlaceholderText(text) {
  // container.setAttribute("placeholder", text)
}
function updatePlaceholder() {
  // if (!isEditable) { return }
  // console.log(container.innerHTML, '============')
  //
  // if (container && container.innerHTML !== "<div><br></div>" &&
  // container.innerHTML !== "<br><div><br></div> – " &&
  // container.innerHTML !== "<br>" &&
  // container.innerHTML !== "")) {
  //   console.log(container, "fail")
  //   if (container.classList[0] == "placeholder") {
  //     container.classList.remove("placeholder");
  //   }
  // } else {
  //   console.log(container, "success")
  //   if (container && container.classList && container.classList[0] != "placeholder") {
  //     container.classList.add("placeholder");
  //   }
  // }
}

function detectEditorHeightChanged() {
  newHeight = container.clientHeight,
  lastHeight != newHeight && postEditorContentHeight(lastHeight = clone(newHeight))
}
function detectFontInfoChnaged() {
  let t = editor.getFontInfo().size;
  null != t && (t = t.replace("px", "")),
  newFontInfo = {
    color: rgbToHex(editor.getFontInfo().color),
    backgroundColor: rgbToHex(editor.getFontInfo().backgroundColor),
    family: editor.getFontInfo().family,
    size: t
  },
  isEquivalent(lastFontInfo, newFontInfo) || postFontInfo(lastFontInfo = clone(newFontInfo))
}
function detectFormatChnaged() {
  let t = Object.getOwnPropertyNames(lastFormat);
  for (let e = 0; e < t.length; e++) {
    let n = t[e],
      o = tagName[n];
    newFormat[n] = editor.hasFormat(o)
  }
  isEquivalent(lastFormat, newFormat) || postFormat(lastFormat = clone(newFormat))
}
function isEquivalent(t, e) {
  let n = Object.getOwnPropertyNames(t),
    o = Object.getOwnPropertyNames(e);
  if (n.length != o.length)
    return !1;
  for (let o = 0; o < n.length; o++) {
    var i = n[o];
    if (t[i] !== e[i])
      return !1
  }
  return !0
}
function clone(t) {
  if (null == t || "object" != typeof t)
    return t;
  var e = new t.constructor;
  for (var n in t)
    e[n] = clone(t[n]);
  return e
}
function rgbToHex(t) {
  if (null == t)
    return null;
  let e = t.match(/\d+/g).map((function(t) {
    return parseInt(t)
  }));
  return n = e[0],
  o = e[1],
  i = e[2],
  "#" + (
  (1 << 24) + (n << 16) + (o << 8) + i).toString(16).slice(1);
  var n,
    o,
    i
}
function setFormat(t) {
  let e = tagName[t];
  "undefined" !== e && editor.changeFormat({tag: e})
}
function removeFormat(t) {
  let e = tagName[t];
  "undefined" !== e && editor.changeFormat(null, {tag: e})
}
function setFontSize(t) {
  editor.setFontSize(t + "px")
}
function setTextColor(t) {
  editor.setTextColour(t)
}
function insertImage(t) {
  editor.insertImage(t)
}
function insertHTML(t) {
  editor.insertHTML(t)
}
function getHTML() {
  return editor.getHTML()
}
function clear() {
  editor.setHTML("")
}
function makeLink(t) {
  editor.makeLink(t)
}
function removeLink() {
  editor.removeLink()
}
function inserImage(t) {
  editor.insertImage(t)
}
function setTextSelection(t, e, n, o) {
  let i = Array.prototype.find.call(document.getElementById(t).childNodes, (function(t) {
      return t.nodeType == Node.TEXT_NODE
    })),
    r = Array.prototype.find.call(document.getElementById(n).childNodes, (function(t) {
      return t.nodeType == Node.TEXT_NODE
    })),
    a = editor.createRange(i, e, r, o);
  editor.setSelection(a)
}
function getSelectedText() {
  return editor.getSelectedText()
}
function setTextBackgroundColor(t) {
  editor.setHighlightColour(t)
}

// left | right | center
function setTextAlignment(t) {
  editor.setTextAlignment(t)
}
// sans-serif, Pingfang SC, ....
function setFontFamily(t) {
  editor.setFontFamily(t)
}

function postEditorContentHeight(t) {
  window.webkit.messageHandlers.contentHeight.postMessage(t)
}
function postFontInfo(t) {
  window.webkit.messageHandlers.fontInfo.postMessage(t)
}
function postFormat(t) {
  window.webkit.messageHandlers.format.postMessage(t)
}
document.getElementById("outer-container").onclick = function(t) {
  t.target === this && (isFocused || editor.focus())
},
editor.addEventListener("focus", (function() {
  detectEditorHeightChanged(),
  isFocused = !0
}), !1),
editor.addEventListener("blur", (function() {
  isFocused = !1
}), !1),
editor.addEventListener("input", (function() {
  updatePlaceholder(),
  detectEditorHeightChanged(),
  detectFontInfoChnaged(),
  detectFormatChnaged()
}), !1),
editor.addEventListener("select", (function() {
  detectFontInfoChnaged(),
  detectFormatChnaged()
}), !1),
editor.addEventListener("cursor", (function() {
  detectFontInfoChnaged(),
  detectFormatChnaged()
}), !1);
