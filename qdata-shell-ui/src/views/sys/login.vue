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
  <div class="auth-page" ref="appContainer">
    <div class="auth-grid"></div>
    <div class="auth-orbit auth-orbit-one"></div>
    <div class="auth-orbit auth-orbit-two"></div>

    <header class="auth-header">
      <div class="brand-lockup">
        <span class="brand-mark">D</span>
        <span class="brand-divider"></span>
        <span class="brand-product">DATA PLATFORM</span>
      </div>

      <div :class="['language-switcher', { open: langOpen }]" @click="langOpen = !langOpen">
        <img src="@/assets/images/system/login/icon-language.svg" alt="" />
        <span>{{ currentLocaleName }}</span>
        <el-icon><ArrowDown /></el-icon>
        <div class="language-menu">
          <button v-for="item in localeMap" :key="item.lang" type="button" @click.stop="handleLangClick(item.lang)">
            {{ item.name }}
          </button>
        </div>
      </div>
    </header>

    <main class="auth-main">
      <section class="auth-intro">
        <span class="intro-index">AUTH / 01</span>
        <h1>Data work,<br /><em>made clear.</em></h1>
        <p>统一入口，连接数据资产、治理流程与分析能力。</p>
        <div class="intro-rule"><span></span><span></span><span></span></div>
      </section>

      <section class="auth-card" aria-labelledby="login-title">
        <div class="card-topline">
          <span class="status-dot"></span>
          <span>SECURE ACCESS</span>
          <span class="card-code">PLATFORM / 2026</span>
        </div>

        <div class="card-heading">
          <span class="card-label">SIGN IN</span>
          <h2 id="login-title">账号登录</h2>
          <p>输入账号信息以访问数据平台</p>
        </div>

        <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="auth-form" @keyup.enter="handleLogin">
          <el-form-item prop="username">
            <label for="auth-username">{{ td('login.username') }}</label>
            <el-input id="auth-username" v-model="loginForm.username" type="text" autocomplete="username" :placeholder="td('login.username')">
              <template #prefix><el-icon><User /></el-icon></template>
            </el-input>
          </el-form-item>

          <el-form-item prop="password">
            <label for="auth-password">{{ td('login.password') }}</label>
            <el-input id="auth-password" v-model="loginForm.password" type="password" autocomplete="current-password" :placeholder="td('login.password')" />
          </el-form-item>

          <el-form-item v-if="captchaEnabled" prop="code">
            <label for="auth-code">{{ td('login.code') }}</label>
            <div class="captcha-line">
              <el-input id="auth-code" v-model="loginForm.code" autocomplete="off" :placeholder="td('login.code')">
                <template #prefix><el-icon><Key /></el-icon></template>
              </el-input>
              <button type="button" class="captcha-refresh" aria-label="刷新验证码" @click="getCode">
                <img :src="codeUrl" alt="captcha" />
                <span>↻</span>
              </button>
            </div>
          </el-form-item>

          <div class="form-options">
            <el-checkbox v-model="loginForm.rememberMe">{{ td('login.remember') }}</el-checkbox>
            <button type="button" class="forgot-link" @click="dialogVisible = true">{{ td('login.forgetPassword') }}</button>
          </div>

          <el-button :loading="loading" type="primary" class="auth-submit" @click="handleLogin">
            <span>{{ loading ? td('login.logining') : td('login.loginBtn') }}</span>
            <el-icon v-if="!loading"><ArrowRight /></el-icon>
          </el-button>
        </el-form>

        <div class="card-footer">
          <span>AUTHORIZED USERS ONLY</span>
          <span class="footer-line"></span>
          <span>PLATFORM</span>
        </div>
      </section>
    </main>

    <footer class="auth-footer">
      <span>© {{ new Date().getFullYear() }} Data Platform</span>
      <span>Secure workspace for data operations</span>
    </footer>
  </div>

  <el-dialog v-model="dialogVisible" :title="td('login.forgetPassword')" class="auth-forgot-dialog" width="520px" :append-to="appContainer" destroy-on-close>
    <el-form :model="fpForm" label-position="top" class="forgot-form">
      <el-form-item :label="td('login.username')">
        <el-input v-model="fpForm.username" :placeholder="td('login.usernameInputPlaceholder')" />
      </el-form-item>
      <el-form-item :label="td('login.code')">
        <div class="forgot-code-row">
          <el-input v-model="fpForm.code" :placeholder="td('login.codePlaceholder')" />
          <el-button type="primary" :disabled="codeFlag" @click="handleFPCodeClick">
            {{ codeFlag ? `${codeTime}s` : td('login.getCode') }}
          </el-button>
        </div>
      </el-form-item>
      <el-form-item :label="td('login.newPassword')">
        <el-input v-model="fpForm.password" type="password" :placeholder="td('login.newPasswordPlaceholder')" />
      </el-form-item>
      <el-form-item :label="td('login.confirmPassword')">
        <el-input v-model="fpForm.password2" type="password" :placeholder="td('login.confirmPasswordPlaceholder')" />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button type="primary" @click="dialogVisible = false">{{ td('login.resetPassword') }}</el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue';
import { ArrowDown, ArrowRight, Key, User } from '@element-plus/icons-vue';
import Cookies from 'js-cookie';
import useDefaultLang from '@/composables/useDefaultLang';
import useLocaleStore from '@/store/system/locale.js';
import useUserStore from '@/store/system/user.js';
import { useLocale } from '@/composables/useLocale';
import { getCodeImg } from '@/api/system/login';
import { encrypt, decrypt } from '@/utils/jsencrypt';
import { shellPath, shellStorageKey } from '@/utils/storage';

const { td } = useDefaultLang();
const { changeLocale } = useLocale();
const localeStore = useLocaleStore();
const userStore = useUserStore();

const appContainer = ref(null);
const loginRef = ref(null);
const loading = ref(false);
const codeUrl = ref('');
const captchaEnabled = ref(true);
const dialogVisible = ref(false);
const langOpen = ref(false);
const codeFlag = ref(false);
const codeTime = ref(3);
let codeTimer = null;

const localeMap = computed(() => localeStore.getLocaleMap);
const currentLocaleName = computed(() => {
  const currentLang = localeStore.getCurrentLocale.lang;
  return localeMap.value.find((item) => item.lang === currentLang)?.name || currentLang;
});

const loginForm = ref({ username: 'qData', password: 'qData123', rememberMe: false, code: '', uuid: '' });
const fpForm = ref({ username: '', password: '', password2: '', code: '' });

const loginRules = computed(() => ({
  username: [{ required: true, trigger: 'blur', message: td('login.usernameRequired') }],
  password: [{ required: true, trigger: 'blur', message: td('login.passwordRequired') }],
  code: [{ required: true, trigger: 'change', message: td('login.codeRequired') }]
}));

function getCookie() {
  const username = Cookies.get(shellStorageKey('username'));
  const password = Cookies.get(shellStorageKey('password'));
  const rememberMe = Cookies.get(shellStorageKey('rememberMe'));
  loginForm.value = {
    ...loginForm.value,
    username: username ?? loginForm.value.username,
    password: password ? decrypt(password) : loginForm.value.password,
    rememberMe: rememberMe === 'true'
  };
}

async function getCode() {
  const res = await getCodeImg();
  captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled;
  if (captchaEnabled.value) {
    codeUrl.value = `data:image/gif;base64,${res.img}`;
    loginForm.value.uuid = res.uuid;
  }
}

async function handleLogin() {
  localStorage.setItem(shellStorageKey('username'), loginForm.value.username);
  const valid = await loginRef.value?.validate().catch(() => false);
  if (!valid) return;
  loading.value = true;
  if (loginForm.value.rememberMe) {
    Cookies.set(shellStorageKey('username'), loginForm.value.username, { expires: 30 });
    Cookies.set(shellStorageKey('password'), encrypt(loginForm.value.password), { expires: 30 });
    Cookies.set(shellStorageKey('rememberMe'), 'true', { expires: 30 });
  } else {
    Cookies.remove(shellStorageKey('username'));
    Cookies.remove(shellStorageKey('password'));
    Cookies.remove(shellStorageKey('rememberMe'));
  }
  userStore.login(loginForm.value).then(() => {
    window.location.href = shellPath('index');
  }).catch(() => {
    loading.value = false;
    if (captchaEnabled.value) getCode();
  });
}

async function handleLangClick(lang) {
  langOpen.value = false;
  if (lang === localeStore.getCurrentLocale.lang) return;
  localeStore.setCurrentLocale({ lang });
  await changeLocale(lang);
  window.location.reload();
}

function handleFPCodeClick() {
  if (codeFlag.value) return;
  codeFlag.value = true;
  codeTime.value = 3;
  codeTimer = window.setInterval(() => {
    codeTime.value -= 1;
    if (codeTime.value <= 0) {
      window.clearInterval(codeTimer);
      codeTimer = null;
      codeFlag.value = false;
      codeTime.value = 3;
    }
  }, 1000);
}

onMounted(() => {
  getCookie();
  getCode();
});
</script>

<style lang="scss">
.auth-forgot-dialog .el-dialog {
  border: 1px solid #dbe4ef;
  border-radius: 12px;
  background: #f8fbff;
  box-shadow: 0 24px 80px rgba(15, 31, 52, 0.24);
}
.auth-forgot-dialog .el-dialog__header { margin-right: 0; padding: 22px 26px; border-bottom: 1px solid #e3ebf4; }
.auth-forgot-dialog .el-dialog__title { color: #12243b; font-size: 18px; font-weight: 700; }
.auth-forgot-dialog .el-dialog__body { padding: 24px 26px 8px; }
.forgot-form .el-form-item__label { color: #607089; font-size: 12px; font-weight: 600; }
.forgot-form .el-input__wrapper { min-height: 42px; border: 1px solid #dbe4ef; border-radius: 6px; box-shadow: none; }
.forgot-code-row { display: flex; gap: 10px; }
.forgot-code-row .el-input { flex: 1; }
.forgot-code-row .el-button,
.auth-forgot-dialog .el-dialog__footer .el-button { border-color: #2d5bff; border-radius: 6px; background: #2d5bff; }
</style>

<style scoped lang="scss">
.auth-page { position: relative; display: flex; flex-direction: column; min-height: 100vh; overflow: hidden; background: #0e1928; color: #fff; isolation: isolate; }
.auth-page::before { position: absolute; inset: 0; z-index: -3; background: radial-gradient(circle at 20% 22%, rgba(45,91,255,.22), transparent 24%), radial-gradient(circle at 80% 76%, rgba(27,155,203,.14), transparent 28%), linear-gradient(135deg,#0e1928 0%,#13253c 54%,#0b1420 100%); content: ""; }
.auth-grid { position: absolute; inset: 0; z-index: -2; opacity: .24; background-image: linear-gradient(rgba(109,164,220,.12) 1px,transparent 1px),linear-gradient(90deg,rgba(109,164,220,.12) 1px,transparent 1px); background-size: 64px 64px; mask-image: linear-gradient(135deg,#000 0%,transparent 62%); }
.auth-page::after { position: absolute; right: 9vw; bottom: 10vh; z-index: -1; width: 340px; height: 340px; border: 1px solid rgba(119,192,255,.24); border-radius: 50%; box-shadow: 0 0 0 28px rgba(119,192,255,.05),0 0 0 56px rgba(119,192,255,.035); content: ""; }
.auth-header { display: flex; align-items: center; justify-content: space-between; box-sizing: border-box; width: 100%; padding: 30px clamp(24px,6vw,92px); }
.brand-lockup { display: flex; align-items: center; gap: 13px; }
.brand-mark { display: inline-flex; align-items: center; justify-content: center; width: 28px; height: 28px; border: 1px solid rgba(114,184,255,.65); border-radius: 7px; color: #72b8ff; font-size: 15px; font-weight: 800; }
.brand-divider { width: 1px; height: 20px; background: rgba(255,255,255,.22); }
.brand-product { color: rgba(255,255,255,.56); font-size: 10px; font-weight: 700; letter-spacing: .16em; }
.language-switcher { position: relative; display: flex; align-items: center; gap: 7px; padding: 9px 11px; border: 1px solid rgba(255,255,255,.16); border-radius: 6px; color: rgba(255,255,255,.74); cursor: pointer; font-size: 12px; user-select: none; }
.language-switcher:hover,.language-switcher.open { border-color: rgba(255,255,255,.34); background: rgba(255,255,255,.08); }
.language-switcher > img { width: 15px; height: 15px; filter: brightness(0) invert(1); opacity: .82; }
.language-switcher .el-icon { transition: transform .2s ease; }
.language-switcher.open .el-icon { transform: rotate(180deg); }
.language-menu { position: absolute; top: calc(100% + 8px); right: 0; display: none; min-width: 110px; padding: 6px; border: 1px solid #dbe4ef; border-radius: 7px; background: #fff; box-shadow: 0 16px 36px rgba(3,13,27,.28); }
.language-switcher.open .language-menu { display: block; }
.language-menu button { display: block; width: 100%; height: 32px; padding: 0 10px; border: 0; border-radius: 5px; color: #24364d; background: transparent; cursor: pointer; text-align: left; }
.language-menu button:hover { color: #2d5bff; background: #edf2ff; }
.auth-main { display: grid; grid-template-columns: minmax(260px,1fr) minmax(380px,460px); align-items: center; gap: clamp(60px,10vw,180px); width: min(1120px,calc(100% - 48px)); margin: auto; }
.auth-intro { align-self: center; max-width: 520px; }
.intro-index,.card-label { color: #72b8ff; font-size: 11px; font-weight: 800; letter-spacing: .22em; }
.auth-intro h1 { margin: 22px 0 18px; color: #fff; font-size: clamp(40px,5vw,76px); font-weight: 500; letter-spacing: -.07em; line-height: .98; }
.auth-intro h1 em { color: #72b8ff; font-style: normal; }
.auth-intro p { max-width: 360px; margin: 0; color: rgba(255,255,255,.58); font-size: 14px; line-height: 1.9; }
.intro-rule { display: flex; align-items: center; gap: 6px; margin-top: 30px; }
.intro-rule span { display: block; width: 34px; height: 2px; background: #2d5bff; }
.intro-rule span:nth-child(2) { width: 10px; background: #48d0d7; }
.intro-rule span:nth-child(3) { width: 4px; background: #fff; }
.auth-card { width: 100%; box-sizing: border-box; padding: 25px 28px 22px; border: 1px solid rgba(163,205,242,.42); border-radius: 12px; background: rgba(247,251,255,.97); box-shadow: 0 32px 90px rgba(0,0,0,.28),0 0 0 8px rgba(94,173,255,.05); color: #15253a; }
.card-topline,.card-footer { display: flex; align-items: center; gap: 8px; color: #8a9bad; font-size: 9px; font-weight: 800; letter-spacing: .16em; }
.card-code { margin-left: auto; color: #a6b3c1; }
.status-dot { width: 7px; height: 7px; border-radius: 50%; background: #2ecf9a; box-shadow: 0 0 0 4px rgba(46,207,154,.12); }
.card-heading { padding: 28px 0 20px; border-bottom: 1px solid #dfe7ef; }
.card-heading h2 { margin: 10px 0 6px; color: #15253a; font-size: 28px; font-weight: 700; letter-spacing: -.04em; }
.card-heading p { margin: 0; color: #8a9bad; font-size: 12px; }
.auth-form { padding-top: 22px; }
.auth-form :deep(.el-form-item) { display: block; margin-bottom: 17px; }
.auth-form :deep(.el-form-item__content) { display: block; line-height: normal; }
.auth-form label { display: block; margin-bottom: 7px; color: #607089; font-size: 11px; font-weight: 700; letter-spacing: .07em; text-transform: uppercase; }
.auth-form :deep(.el-input__wrapper) { min-height: 44px; padding: 0 12px; border: 1px solid #d9e3ed; border-radius: 6px; box-shadow: none; background: #fff; transition: border-color .2s,box-shadow .2s; }
.auth-form :deep(.el-input__wrapper:hover),.auth-form :deep(.el-input__wrapper.is-focus) { border-color: #2d5bff; box-shadow: 0 0 0 3px rgba(45,91,255,.1); }
.auth-form :deep(.el-input__inner) { color: #15253a; font-size: 14px; }
.auth-form :deep(.el-input__inner::placeholder) { color: #a6b3c1; }
.auth-form :deep(.el-input__prefix) { left: 12px !important; color: #8a9bad; }
.auth-form :deep(.el-input__prefix + .el-input__inner) { padding-left: 28px; }
.captcha-line { display: flex; gap: 9px; }
.captcha-line .el-input { flex: 1; }
.captcha-refresh { position: relative; flex: 0 0 104px; height: 44px; padding: 0; overflow: hidden; border: 1px solid #d9e3ed; border-radius: 6px; background: #fff; cursor: pointer; }
.captcha-refresh:hover { border-color: #2d5bff; }
.captcha-refresh img { display: block; width: 100%; height: 100%; object-fit: cover; }
.captcha-refresh span { position: absolute; right: 5px; bottom: 3px; color: #2d5bff; font-size: 13px; font-weight: 700; }
.form-options { display: flex; align-items: center; justify-content: space-between; margin: 2px 0 20px; }
.form-options :deep(.el-checkbox__label) { color: #8a9bad; font-size: 12px; }
.forgot-link { padding: 0; border: 0; color: #2d5bff; background: transparent; cursor: pointer; font-size: 12px; }
.auth-submit { display: flex; align-items: center; justify-content: center; gap: 8px; width: 100%; min-height: 46px; border: 0; border-radius: 6px; background: #172b4d; box-shadow: 0 10px 18px rgba(23,43,77,.2); font-size: 14px; letter-spacing: .08em; }
.auth-submit:hover { border-color: #254879; background: #254879; }
.card-footer { margin-top: 22px; }
.footer-line { flex: 1; height: 1px; background: #dfe7ef; }
.auth-footer { display: flex; justify-content: space-between; width: min(1120px,calc(100% - 48px)); margin: auto auto 24px; color: rgba(255,255,255,.42); font-size: 10px; letter-spacing: .05em; }
@media screen and (max-width: 820px) { .auth-main { grid-template-columns: 1fr; gap: 24px; width: min(480px,calc(100% - 36px)); padding: 30px 0 40px; } .auth-intro { display: none; } .auth-footer { width: min(480px,calc(100% - 36px)); } }
@media screen and (max-width: 520px) { .auth-header { padding: 22px 18px; } .brand-divider,.brand-product { display: none; } .auth-main { width: calc(100% - 28px); padding-top: 20px; } .auth-card { padding: 22px 20px 19px; } .auth-footer { flex-direction: column; gap: 6px; width: calc(100% - 28px); margin-bottom: 18px; } }
</style>
