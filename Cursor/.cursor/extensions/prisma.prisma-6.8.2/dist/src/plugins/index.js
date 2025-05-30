"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const ai_tools_1 = __importDefault(require("./ai-tools"));
const prisma_language_server_1 = __importDefault(require("./prisma-language-server"));
const plugins = [prisma_language_server_1.default, ai_tools_1.default];
exports.default = plugins;
//# sourceMappingURL=index.js.map