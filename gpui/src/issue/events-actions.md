# 事件与 Action

本文总结 GPUI 中两类常用“信号”机制：事件（Event）与动作（Action），并给出示例与注意事项。

相关页面：
- [`gpui/src/issue/index.md`](gpui/src/issue/index.md:1)
- [`gpui/src/issue/conversation-summary.md`](gpui/src/issue/conversation-summary.md:1)

## 事件（Event / EventEmitter）

- 用途：广播式消息传递，适合发布-订阅（producer -> many consumers）。
- 核心 API：实体实现 `EventEmitter<T>`，发事件用 `cx.emit(...)`，订阅用 `cx.subscribe(...)`。
- 生命周期与所有权：
  - 事件类型必须是 `'static`。
  - 若携带大数据，优先用 `Arc<T>` 共享。
  - 后台线程不要直接持有 `&mut Context` / `&mut Window`；在后台完成后回到前台（`handle.update` / `cx.spawn` 前台任务）再 `emit`。

示例（最小）：
```rust
rust
use std::sync::Arc;
use gpui::{Context, Entity, EventEmitter, prelude::*};

#[derive(Clone, Debug)]
pub enum MessageEvent {
    Text(Arc<String>),
    Ping,
}

impl EventEmitter<MessageEvent> for MessageProducer {}

pub struct MessageProducer;
impl MessageProducer {
    pub fn send_text(&mut self, cx: &mut Context<Self>, text: String) {
        cx.emit(MessageEvent::Text(Arc::new(text)));
    }
}
```

## Action（actions! 与 derive(Action)）

- 用途：用于键盘绑定、菜单、统一命令分发（capture/bubble），适合“命令”语义。
- 定义方式：
  - `actions!` 宏：快速声明无数据的 unit struct action（适合无参数命令）。
  - `#[derive(Action)]`：为携带字段的 struct 生成 Action 支持（当需携带 payload 时使用）。

示例：带数据的 Action
```rust
rust
#[derive(Clone, PartialEq, Deserialize, Serialize, JsonSchema, gpui::Action)]
#[action(namespace = web_links)]
pub struct AddWebLink {
    pub title: String,
    pub url: String,
    pub description: Option<String>,
}
```

发送与处理：
- 发送：`window.dispatch_action(add.boxed_clone(), cx)`（从当前焦点开始分发）或用 `focus_handle.dispatch_action(&AddWebLink, window, cx)` 指定目标。
- 处理：在视图树上注册 `.on_action(cx.listener(|this, action, ...| { ... }))`，或在 App 层用 `cx.on_action(...)` 注册全局处理。

注意事项：
- `derive(Action)` 要求 `Clone + PartialEq`；若需 JSON 支持加 `serde`/`schemars`；如不需要 JSON 可用 `#[action(no_json)]`。
- dispatch 的分发路径以当前 focus 为起点，modal / window 内的 dispatch 可能不会到达主视图，常见解决方法：
  - 直接在 modal 的回调里通过 `WeakEntity`/`Entity` 更新目标实体（推荐）。
  - 打开 modal 时捕获 `FocusHandle` 并使用 `focus_handle.dispatch_action(...)`。
  - 使用全局消息总线（EventEmitter + global）或在 App 层注册全局 `cx.on_action`。

调试建议：
- 在 on_click / on_action 内打印日志。
- 使用 `window.available_actions(cx)` 查看可用 action。
- 若 dispatch 未触达，尝试使用 `focus_handle` 指定目标或改为直接调用实体方法（`cx.listener`）。