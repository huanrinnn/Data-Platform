/*
 * Storage names used by the shell application.
 *
 * The legacy UI is served from the same host, so unprefixed keys would make
 * the two applications overwrite each other's session and layout state.
 */
export const SHELL_STORAGE_PREFIX = 'qdata-shell:'

export function shellStorageKey(key) {
  return `${SHELL_STORAGE_PREFIX}${key}`
}

export const SHELL_BASE_PATH = '/shell/'

export function shellPath(path = '') {
  const normalizedPath = path.startsWith('/') ? path.slice(1) : path
  return `${SHELL_BASE_PATH}${normalizedPath}`
}
