import { useEffect, useLayoutEffect, useState } from 'react'
import { withViewTransition } from './transition'

/**
 * 主题只切换 `<html data-theme>`，颜色全部来自 apps/web/src/styles/app.css 的令牌，
 * 官网不另外定义任何颜色。默认跟随系统；只有访客亲手切换过，选择才记进 localStorage——
 * 挂载时不写，否则「跟随系统」会被固化成一次显式选择，之后系统换了深浅色页面也不跟。
 */
export type Theme = 'dark' | 'light'

const STORAGE_KEY = 'umuo-theme'

function readInitialTheme(): Theme {
  // 只在挂载后调用。优先读 <html data-theme>：index.html 的同步脚本已经在首屏前定好了它，
  // 从这里取值可以避免「先渲染成另一个主题、再被 effect 纠正」的闪烁。
  const applied = document.documentElement.dataset.theme
  if (applied === 'light' || applied === 'dark') return applied

  const stored = storedTheme()
  if (stored) return stored
  return window.matchMedia('(prefers-color-scheme: light)').matches ? 'light' : 'dark'
}

function storedTheme(): Theme | null {
  try {
    const value = window.localStorage.getItem(STORAGE_KEY)
    return value === 'light' || value === 'dark' ? value : null
  } catch {
    return null
  }
}

export function useTheme(): { theme: Theme; toggleTheme: () => void } {
  // 渲染期固定暗色，与预渲染和 index.html 的 <html data-theme="dark"> 一致；
  // 挂载后在绘制前换成真实主题（颜色由 <html data-theme> 决定，这里只影响按钮标题）
  const [theme, setTheme] = useState<Theme>('dark')
  useLayoutEffect(() => setTheme(readInitialTheme()), [])
  const [manual, setManual] = useState(false)

  useEffect(() => {
    // 存过的显式选择只在 effect 里读：渲染期不碰 window
    if (manual || storedTheme() !== null) return
    const query = window.matchMedia('(prefers-color-scheme: light)')
    const update = () => {
      const next: Theme = query.matches ? 'light' : 'dark'
      document.documentElement.dataset.theme = next
      setTheme(next)
    }
    update()
    query.addEventListener('change', update)
    return () => query.removeEventListener('change', update)
  }, [manual])

  const toggleTheme = () => {
    const next: Theme = theme === 'dark' ? 'light' : 'dark'
    setManual(true)
    // 两套配色之间做一次短交叉淡化；<html data-theme> 在过渡回调里直接写
    withViewTransition(() => {
      document.documentElement.dataset.theme = next
      setTheme(next)
    })
    try {
      window.localStorage.setItem(STORAGE_KEY, next)
    } catch {
      // 隐私模式等存不了时，这次访问内照样生效，只是下次不记得
    }
  }

  return { theme, toggleTheme }
}
