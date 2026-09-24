/*
 * Copyright © 2025-present Jiangsu Qiantong Technology Co., Ltd.
 *
 * This file is part of qData Data Middle Platform (Open Source Edition).
 *
 * qData is licensed under Apache License 2.0 with additional qData terms.
 * You may use qData for commercial purposes, but you may not remove, hide,
 * modify, or replace the qData logo, copyright notices, license notices,
 * or attribution information without a separate commercial license.
 *
 * White-label use, OEM distribution, rebranding, or presenting qData as
 * another product requires separate commercial authorization from
 * Jiangsu Qiantong Technology Co., Ltd.
 *
 * Business License: https://community.qdata.tech/business/policy.html
 * See the LICENSE file in the project root for full license information.
 */

import { defineConfig, loadEnv } from "vite";
import path from "path";
import createVitePlugins from "./vite/plugins";

const chunkGroups = [
  { name: "vue", deps: ["vue", "vue-router", "pinia", "@vueuse/core"] },
  { name: "element-plus", deps: ["element-plus", "@element-plus/icons-vue"] },
  { name: "antv", deps: ["@antv/x6", "@antv/x6-plugin-dnd", "@antv/x6-plugin-export", "@antv/x6-plugin-history", "@antv/x6-plugin-keyboard", "@antv/x6-plugin-selection", "@antv/x6-vue-shape", "@antv/layout"] },
  { name: "editor", deps: ["monaco-editor", "ace-builds", "codemirror", "@codemirror"] },
  { name: "charts", deps: ["echarts", "zrender", "vis-network"] },
  { name: "office", deps: ["xlsx", "jszip", "@vue-office"] },
  { name: "crypto", deps: ["crypto-js", "jsencrypt"] },
];

function getNodeModuleName(id) {
  const normalized = id.split(path.sep).join("/");
  const [, modulePath] = normalized.split("/node_modules/");
  if (!modulePath) return "";
  const parts = modulePath.split("/");
  return parts[0]?.startsWith("@") ? `${parts[0]}/${parts[1]}` : parts[0];
}

function manualChunks(id) {
  if (!id.includes("node_modules")) return undefined;
  const moduleName = getNodeModuleName(id);
  const group = chunkGroups.find(({ deps }) =>
    deps.some((dep) => moduleName === dep || moduleName.startsWith(`${dep}/`))
  );
  return group?.name || "vendor";
}

// https://vitejs.dev/config/
export default defineConfig(({ mode, command }) => {
  const env = loadEnv(mode, process.cwd());
  const { VITE_APP_ENV, VITE_APP_FLOW_API } = env;
  return {
    // Deploy URLs in production and development environments.
    // By default, Vite will assume that your application is deployed on the root path of a domain name
    // For example https://www.qdata.vip/. If the application is deployed on a subpath, you need to specify the subpath with this option. For example, if your application is deployed at https://www.qdata.vip/admin/, set the baseUrl to /admin/.
    base: "/shell/",
    plugins: createVitePlugins(env, command === "build"),
    build: {
      rollupOptions: {
        input: {
          main: path.resolve(__dirname, "index.html"),
          // nested: path.resolve(__dirname, "login/index.html"),
        },
        output: {
          manualChunks,
        },
      },
    },
    optimizeDeps: {
      include: [
        "vue",
        "vue-router",
        "pinia",
        "axios",
        "element-plus",
        "@element-plus/icons-vue",
        "@vueuse/core",
      ],
    },
    resolve: {
      // https://cn.vitejs.dev/config/#resolve-alias
      alias: {
        // Set path
        "~": path.resolve(__dirname, "./"),
        // Set alias
        "@": path.resolve(__dirname, "./src"),
      },
      // https://cn.vitejs.dev/config/#resolve-extensions
      extensions: [".mjs", ".js", ".ts", ".jsx", ".tsx", ".json", ".vue"],
    },
    // Vite related configuration
    server: {
      port: 82,
      host: true,
      open: true,
      proxy: {
        // https://cn.vitejs.dev/config/#server-proxy
        "/dev-api": {
          target: "http://localhost:8080",
          changeOrigin: true,
          rewrite: (p) => p.replace(/^\/dev-api/, ""),
        },
        "/dev-ai": {
          target: "http://localhost:8087",
          // target: "http://192.168.20.115:8080",
          // target: "https://qdata-pro.qiantong.tech/prod-api/",
          // target: "http://110.42.38.62:30001/prod-api/",
          changeOrigin: true,
          rewrite: (p) => p.replace(/^\/dev-ai/, ""),
        },
        "/dev-quality": {
          target: "http://localhost:8083",
          changeOrigin: true,
          rewrite: (p) => p.replace(/^\/dev-quality/, ""),
        },
        "/jmreport": {
          target: "http://localhost:8080",
          changeOrigin: true,
        },
        "/v3/api-docs": {
          target: "http://localhost:8080",
          changeOrigin: true,
          rewrite: (p) => p.replace("", ""),
        },
      },
    },
    //fix:error:stdin>:7356:1: warning: "@charset" must be the first rule in the file
    css: {
      postcss: {
        plugins: [
          {
            postcssPlugin: "internal:charset-removal",
            AtRule: {
              charset: (atRule) => {
                if (atRule.name === "charset") {
                  atRule.remove();
                }
              },
            },
          },
        ],
      },
    },
  };
});
