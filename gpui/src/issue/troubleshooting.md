# 排查清单

相关页面：[`gpui/src/issue/index.md`](gpui/src/issue/index.md:1) [`gpui/src/issue/examples.md`](gpui/src/issue/examples.md:1)

常见问题与排查步骤：

1. Button 点击不触发处理
   - 确认按钮的 `on_click` 是否被正确设置，并尝试在回调内打印日志。
   - 若回调使用 `window.dispatch_action(...)`，确认目标实体是否在当前 dispatch 路径上；使用 `focus_handle.dispatch_action(...)` 指定目标。
   - 确认 `.on_action` 是否注册在正确的上层元素或使用 `cx.on_action` 注册全局处理。

2. Action 未被识别
   - 检查 `actions!` 定义是否包含该 Action（无数据的 action 应使用 `actions!`，有数据则用 `derive(Action)`）。
   - 在运行时用 `window.available_actions(cx)` 检查。

3. Modal 中 dispatch 无效
   - modal 的 dispatch 从 modal 的焦点开始；主视图可能无法接收到。解决方法见 [`示例`](./examples.md)。

4. 后台任务更新 UI 失败
   - 不要在 async 中持有 `&mut Window` 或 `&mut Context` 跨 await；改为捕获 handle/WeakEntity 并用 `handle.update` / `cx.update` 回到前台更新 UI。

5. 事件订阅未收到
   - 确认实体实现了 `EventEmitter<T>`。
   - 确认使用 `cx.subscribe(...)` 且返回的订阅被 `detach()`（若需要长期订阅）。
   - 检查事件类型是否 `'static`，携带大数据应使用 `Arc<T>`。

调试小技巧：
- 在 suspect 的回调内加入 `log::debug!` 输出。
- 使用 `focus_handle` 明确目标分发路径。
- 将复杂 payload 用 `Arc` 包裹以避免生命周期问题。