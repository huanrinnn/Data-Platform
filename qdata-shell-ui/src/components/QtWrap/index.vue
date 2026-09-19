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
  <div class="qt-wrap">
    <div
      :class="[config.search ? '' : 'qt-wrap--search']"
      v-if="$slots.search"
      v-show="store.search"
    >
      <slot name="search"></slot>
    </div>
    <div :class="['qt-wrap--content', config.fullContent ? 'full' : '']">
      <div class="qt-wrap--actions" v-if="config.actions.show">
        <div class="data-actions">
          <slot name="actions-data"></slot>
        </div>
        <div class="table-actions" v-if="config.actions.table.show">
          <el-tooltip effect="dark" :content="t('components.qtWrap.hideSearch')" placement="top">
            <el-button
              circle
              @click="store.search = !store.search"
              v-show="config.actions.table.search"
            >
              <i class="iconfont icon-a-chaxunxianxing"></i>
            </el-button>
          </el-tooltip>

          <el-tooltip effect="dark" :content="t('common.button.refresh')" placement="top">
            <el-button
              circle
              v-show="config.actions.table.refresh"
              @click="handleRefreshClick"
            >
              <i class="iconfont icon-a-shuaxinxianxing"></i>
            </el-button>
          </el-tooltip>

          <el-tooltip effect="dark" :content="t('components.qtWrap.showHideColumns')" placement="top">
            <el-dropdown
              trigger="click"
              :hide-on-click="false"
              v-show="config.actions.table.columns"
              popper-class="columns-popper"
            >
              <el-button circle icon="Menu" />
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item
                    v-for="item in props.columns"
                    :key="item.prop"
                  >
                    <el-checkbox
                      v-show="item?.type != 'selection'"
                      :checked="!item.hide"
                      :label="item.label"
                      @change="handleCheckboxChange($event, item)"
                    />
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </el-tooltip>
        </div>
      </div>
      <div class="qt-wrap--main" v-if="$slots.default">
        <slot name="default" />
      </div>
    </div>
  </div>
</template>

<script setup name="QtWrap">
import { useI18n } from 'vue-i18n'
import { computed, reactive } from "vue";
import { merge } from "lodash-es";

const { t } = useI18n();
const DEFAULT_CONFIG = {
  fullContent: true,
  actions: {
    show: true,
    table: {
      show: true,
      search: true,
      refresh: true,
      columns: true,
    },
  },
};

const props = defineProps({
  config: {
    type: Object,
    default: () => {
      return {};
    },
  },
  columns: {
    type: Array,
    default: () => {
      return [];
    },
  },
  tableRef: {
    type: Object,
    default: () => {
      return {};
    },
  },
});

const config = computed(() => {
  return merge({}, DEFAULT_CONFIG, props.config);
});

const store = reactive({
  search: true,
});

// Refresh
function handleRefreshClick() {
  props.tableRef.getList();
}

// Display and hide columns
function handleCheckboxChange(checked, item) {
  item.hide = !checked;
}
</script>

<style lang="scss" scoped>
.qt-wrap {
  width: 100%;
  height: 100%;
}
.qt-wrap--search {
  padding: 16px 18px 4px;
  background-color: #fff;
  border: 1px solid #e1e7eb;
  border-radius: 6px;
  box-shadow: 0 4px 14px rgba(23, 38, 50, 0.035);
  margin-bottom: 15px;
}

.qt-wrap--content {
  background-color: #ffffff;
  border: 1px solid #e1e7eb;
  border-radius: 6px;
}

.qt-wrap--content.full {
  flex: 1;
  padding: 18px;
  min-height: calc(100vh - 250px);
  box-shadow: 0 4px 14px rgba(23, 38, 50, 0.035);
}

.qt-wrap--actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.data-actions {
  ::v-deep(.el-button) {
    height: 34px;
    padding: 8px 12px;
    font-size: 12px;
  }
}

.data-actions,
.table-actions {
  display: flex;
  align-items: center;
  gap: 12px;
  ::v-deep(.el-button + .el-button) {
    margin-left: 0;
  }
}
</style>

<style lang="scss">
.columns-popper {
  .el-dropdown-menu__item {
    line-height: 30px;
    padding: 0px 17px;
  }
}
</style>
