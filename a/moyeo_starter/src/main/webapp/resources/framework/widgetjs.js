(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else if(typeof exports === 'object')
		exports["widgetjs"] = factory();
	else
		root["widgetjs"] = factory();
})(typeof self !== 'undefined' ? self : this, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

exports.createCustomEvent = createCustomEvent;
exports.getWidget = getWidget;
exports.ready = ready;

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/*
Copyright (c) 2012, Nicolas Vanhoren
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

function matches(elm, selector) {
  if (elm.matches) return elm.matches(selector);
  if (elm.matchesSelector) return elm.matchesSelector(selector);
  var matches = (elm.document || elm.ownerDocument).querySelectorAll(selector),
      i = matches.length;
  // eslint-disable-next-line
  while (--i >= 0 && matches.item(i) !== elm) {}
  return i > -1;
}

function addClass(el, name) {
  if (el.classList) el.classList.add(name);else el.className += " " + name;
}

function createCustomEvent(type, canBubble, cancelable, detail) {
  if (typeof CustomEvent === "function") {
    return new CustomEvent(type, { detail: detail, bubbles: canBubble || false,
      cancelable: cancelable || false });
  } else {
    var e = document.createEvent("CustomEvent");
    e.initCustomEvent(type, canBubble || false, cancelable || false, detail);
    if (cancelable) {
      // hack for IE due to a bug in that browser
      e.preventDefault = function () {
        Object.defineProperty(this, "defaultPrevented", { get: function get() {
            return true;
          } });
      };
    }
    return e;
  }
}

var LifeCycle = exports.LifeCycle = function () {
  function LifeCycle() {
    _classCallCheck(this, LifeCycle);

    this.__lifeCycle = true;
    this.__lifeCycleChildren = [];
    this.__lifeCycleParent = null;
    this.__lifeCycleDestroyed = false;
  }

  _createClass(LifeCycle, [{
    key: "destroy",
    value: function destroy() {
      this.children.forEach(function (el) {
        el.destroy();
      });
      this.parent = undefined;
      this.__lifeCycleDestroyed = true;
    }
  }, {
    key: "destroyed",
    get: function get() {
      return this.__lifeCycleDestroyed;
    }
  }, {
    key: "parent",
    set: function set(parent) {
      if (this.parent && this.parent.__lifeCycle) {
        this.parent.__lifeCycleChildren = this.parent.children.filter(function (el) {
          return el !== this;
        }.bind(this));
      }
      this.__lifeCycleParent = parent;
      if (parent && parent.__lifeCycle) {
        parent.__lifeCycleChildren.push(this);
      }
    },
    get: function get() {
      return this.__lifeCycleParent;
    }
  }, {
    key: "children",
    get: function get() {
      return this.__lifeCycleChildren.slice();
    }
  }]);

  return LifeCycle;
}();

var EventDispatcher = exports.EventDispatcher = function (_LifeCycle) {
  _inherits(EventDispatcher, _LifeCycle);

  function EventDispatcher() {
    _classCallCheck(this, EventDispatcher);

    var _this = _possibleConstructorReturn(this, (EventDispatcher.__proto__ || Object.getPrototypeOf(EventDispatcher)).call(this));

    _this._listeners = [];
    return _this;
  }

  _createClass(EventDispatcher, [{
    key: "addEventListener",
    value: function addEventListener(type, callback) {
      (this._listeners[type] = this._listeners[type] || []).push(callback);
    }
  }, {
    key: "removeEventListener",
    value: function removeEventListener(type, callback) {
      var stack = this._listeners[type] || [];
      for (var i = 0; i < stack.length; i++) {
        if (stack[i] === callback) {
          stack.splice(i, 1);
        }
      }
    }
  }, {
    key: "dispatchEvent",
    value: function dispatchEvent(event, overrideType) {
      var stack = this._listeners[overrideType || event.type] || [];
      for (var i = 0, l = stack.length; i < l; i++) {
        stack[i].call(this, event);
      }
    }
  }, {
    key: "on",
    value: function on(arg1, arg2) {
      var events = {};
      if (typeof arg1 === "string") {
        events[arg1] = arg2;
      } else {
        events = arg1;
      }
      for (var key in events) {
        this.addEventListener(key, events[key]);
      }
      return this;
    }
  }, {
    key: "off",
    value: function off(arg1, arg2) {
      var events = {};
      if (typeof arg1 === "string") {
        events[arg1] = arg2;
      } else {
        events = arg1;
      }
      for (var key in events) {
        this.removeEventListener(key, events[key]);
      }
      return this;
    }
  }, {
    key: "trigger",
    value: function trigger(arg1, arg2) {
      if (arg1 instanceof Event) {
        this.dispatchEvent(arg1);
      } else {
        var ev = createCustomEvent(arg1, false, false, arg2);
        this.dispatchEvent(ev);
      }
      return this;
    }
  }, {
    key: "destroy",
    value: function destroy() {
      this._listeners = [];
      LifeCycle.prototype.destroy.call(this);
    }
  }]);

  return EventDispatcher;
}(LifeCycle);

function getWidget(element) {
  return element.__widgetWidget;
}

var Widget = exports.Widget = function (_EventDispatcher) {
  _inherits(Widget, _EventDispatcher);

  _createClass(Widget, [{
    key: "tagName",
    get: function get() {
      return 'div';
    }
  }, {
    key: "className",
    get: function get() {
      return '';
    }
  }, {
    key: "attributes",
    get: function get() {
      return {};
    }
  }]);

  function Widget() {
    _classCallCheck(this, Widget);

    var _this2 = _possibleConstructorReturn(this, (Widget.__proto__ || Object.getPrototypeOf(Widget)).call(this));

    _this2.__widgetAppended = false;
    _this2.__widgetExplicitParent = false;
    _this2.__widgetDomEvents = {};
    _this2.__widgetElement = document.createElement(_this2.tagName);
    _this2.className.split(" ").filter(function (name) {
      return name !== "";
    }).forEach(function (name) {
      return addClass(this.el, name);
    }.bind(_this2));
    for (var key in _this2.attributes) {
      _this2.el.setAttribute(key, _this2.attributes[key]);
    }_this2.el.__widgetWidget = _this2;
    _this2.el.setAttribute("data-__widget", "");
    return _this2;
  }

  _createClass(Widget, [{
    key: "destroy",
    value: function destroy() {
      this.trigger("destroying");
      this.children.forEach(function (el) {
        el.destroy();
      });
      this.detach();
      EventDispatcher.prototype.destroy.call(this);
    }
  }, {
    key: "appendTo",
    value: function appendTo(target) {
      target.appendChild(this.el);
      this.__checkAppended();
      return this;
    }
  }, {
    key: "prependTo",
    value: function prependTo(target) {
      target.insertBefore(this.el, target.firstChild);
      this.__checkAppended();
      return this;
    }
  }, {
    key: "insertAfter",
    value: function insertAfter(target) {
      if (!target.nextSibling) target.parentNode.appendChild(this.el);else target.parentNode.insertBefore(this.el, target.nextSibling);
      this.__checkAppended();
      return this;
    }
  }, {
    key: "insertBefore",
    value: function insertBefore(target) {
      target.parentNode.insertBefore(this.el, target);
      this.__checkAppended();
      return this;
    }
  }, {
    key: "replace",
    value: function replace(target) {
      target.parentNode.replaceChild(this.el, target);
      this.__checkAppended();
      return this;
    }
  }, {
    key: "detach",
    value: function detach() {
      if (this.el.parentNode) this.el.parentNode.removeChild(this.el);
      this.__checkAppended(true);
      return this;
    }
  }, {
    key: "addEventListener",
    value: function addEventListener(type, callback) {
      EventDispatcher.prototype.addEventListener.call(this, type, callback);
      var res = /^dom:(\w+)(?: (.*))?$/.exec(type);
      if (!res) return;
      if (!this.__widgetDomEvents[type]) {
        var domCallback;
        if (!res[2]) {
          domCallback = function (e) {
            e.bindedTarget = this.el;
            this.dispatchEvent(e, type);
          }.bind(this);
        } else {
          domCallback = function (e) {
            var elem = e.target;
            while (elem && elem !== this.el && !matches(elem, res[2])) {
              elem = elem.parentNode;
            }
            if (elem && elem !== this.el) {
              e.bindedTarget = elem;
              this.dispatchEvent(e, type);
            }
          }.bind(this);
        }
        this.el.addEventListener(res[1], domCallback);
        this.__widgetDomEvents[type] = [1, domCallback];
      } else {
        this.__widgetDomEvents[type][0] += 1;
      }
    }
  }, {
    key: "removeEventListener",
    value: function removeEventListener(type, callback) {
      EventDispatcher.prototype.removeEventListener.call(this, type, callback);
      var res = /^dom:(\w+)(?: (.*))?$/.exec(type);
      if (!res) return;
      if (!this.__widgetDomEvents[type]) return;
      this.__widgetDomEvents[type][0] -= 1;
      if (this.__widgetDomEvents[type][0] === 0) {
        this.el.removeEventListener(res[1], this.__widgetDomEvents[type][1]);
        delete this.__widgetDomEvents[type];
      }
    }
  }, {
    key: "resetParent",
    value: function resetParent() {
      this.__widgetExplicitParent = false;
      this.__checkAppended();
    }
  }, {
    key: "__checkAppended",
    value: function __checkAppended(detached) {
      // check for parent change
      if (!this.__widgetExplicitParent) {
        var parent = this.el.parentNode;
        while (parent && !getWidget(parent)) {
          parent = parent.parentNode;
        }
        parent = parent ? getWidget(parent) : null;
        if (parent !== this.parent) {
          this.parent = parent;
          this.__widgetExplicitParent = false;
        }
      }

      // update appendedToDom and propagate to all sub elements
      var inHtml = detached ? false : document.body.contains(this.el);
      if (this.appendedToDom === inHtml) return;
      this.__widgetAppended = inHtml;
      this.trigger(inHtml ? "appendedToDom" : "removedFromDom");
      Array.prototype.forEach.call(this.el.querySelectorAll("[data-__widget]"), function (el) {
        getWidget(el).__widgetAppended = inHtml;
        getWidget(el).trigger(inHtml ? "appendedToDom" : "removedFromDom");
      });
    }
  }, {
    key: "el",
    get: function get() {
      return this.__widgetElement;
    }
  }, {
    key: "appendedToDom",
    get: function get() {
      return this.__widgetAppended;
    }
  }, {
    key: "parent",
    set: function set(parent) {
      Object.getOwnPropertyDescriptor(LifeCycle.prototype, 'parent').set.call(this, parent);
      this.__widgetExplicitParent = true;
    },
    get: function get() {
      return Object.getOwnPropertyDescriptor(LifeCycle.prototype, 'parent').get.call(this);
    }
  }]);

  return Widget;
}(EventDispatcher);

function ready(callback) {
  if (document.readyState === "complete") {
    callback();
  } else {
    var c = function c() {
      document.removeEventListener("DOMContentLoaded", c);
      callback();
    };
    document.addEventListener("DOMContentLoaded", c);
  }
}

/***/ })
/******/ ]);
});