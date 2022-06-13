"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.HandlerErrors = void 0;
var HandlerErrors;
(function (HandlerErrors) {
    HandlerErrors[HandlerErrors["UnsupportedOperation"] = 0] = "UnsupportedOperation";
    HandlerErrors[HandlerErrors["DatabaseError"] = 1] = "DatabaseError";
    HandlerErrors[HandlerErrors["NotFound"] = 2] = "NotFound";
    HandlerErrors[HandlerErrors["ValidationError"] = 3] = "ValidationError";
})(HandlerErrors = exports.HandlerErrors || (exports.HandlerErrors = {}));
