<!--
  Copyright © 2025-present Jiangsu Qiantong Technology Co., Ltd.

  This file is part of qData Data Middle Platform (Open Source Edition).

  qData is licensed under Apache License 2.0 with additional qData terms.
  You may use qData for commercial purposes, but you may not remove, hide,
  modify, or replace the qData logo, copyright notices, license notices,
  or attribution information without a separate commercial license.

  White-label use, OEM distribution, rebranding, or presenting qData as
  another product requires separate commercial authorization from
  Jiangsu Qiantong Technology Co., Ltd.

  Business License: https://community.qdata.tech/business/policy.html
  See the LICENSE file in the project root for full license information.
-->

<template>
  <el-config-provider
    :locale="localeStore.currentLocale.elLocale"
    :size="elementSize"
  >
    <!-- Page content -->
    <el-watermark
      v-if="watermarkText"
      style="width: 100%; height: 100%; position: ''"
      :font="config.font"
      :content="watermarkText"
      :gap="[200, 200]"
    >
      <router-view />
    </el-watermark>
    <router-view v-else />
  </el-config-provider>
</template>

<script setup>
import Cookies from 'js-cookie'
import useSettingsStore from "@/store/system/settings";
import { handleThemeStyle } from "@/utils/theme";
import { useRoute } from "vue-router"; // Introduce useRoute hook
import useUserStore from "@/store/system/user";
import useLocaleStore from '@/store/system/locale'
import defaultSettings from '@/settings'
import {i18n} from '@/plugins/vueI18n'
import { shellStorageKey } from '@/utils/storage'
// import useAppStore from "@/store/system/app";
// const appStore = useAppStore();
useUserStore();
// import { alertEffects } from "element-plus";
// Use the useRoute hook to get the current route object
const route = useRoute();
const localeStore = useLocaleStore()
const elementSize = Cookies.get(shellStorageKey('size')) || 'default'
// const storedUser = useUserStore();
;
const title = () => i18n.global.t('common.html.appTitle') || defaultSettings.title;
document.title = title();
// Calculate the watermark text and dynamically obtain the name of the current route
const watermarkText = computed(() => {
  if (localStorage.getItem(shellStorageKey("username"))) {
    if (route.path != "/login" && route.path != "/sso/login") {
      return localStorage.getItem(shellStorageKey("username")) || "Default Watermark"; //Watermark assignment is required and does not need to be empty.
    } else {
      return "";
    }
  }
});
const config = reactive({
  content: "Element Plus",
  font: {
    fontSize: 16,
    color: "rgba(0, 0, 0, 0.15)",
  },
});
onMounted(() => {
  nextTick(() => {
    // Initialize theme style
    handleThemeStyle(useSettingsStore().theme);
  });
});
</script>
