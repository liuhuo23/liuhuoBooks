# 示例代码

相关页面：[`gpui/src/issue/index.md`](gpui/src/issue/index.md:1) [`gpui/src/issue/events-actions.md`](gpui/src/issue/events-actions.md:1)

## 事件：最小示例

```rust
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
    pub fn send_ping(&mut self, cx: &mut Context<Self>) {
        cx.emit(MessageEvent::Ping);
    }
}
```

## Action：按钮与 dispatch 示例

推荐在简单场景直接在 `on_click` 用 `cx.listener` 调用实体方法；需要 Action 流时使用 `focus_handle.dispatch_action` 指定目标。

```rust
Button::new("refresh")
    .on_click(cx.listener(|this: &mut WeblinksView, _ev: &ClickEvent, _window: &mut Window, cx: &mut Context<WeblinksView>| {
        this.do_refresh(cx);
    }))
    .label("刷新")
```

focus_handle 示例：

```rust
Button::new("refresh")
    .on_click(cx.listener(|this: &mut WeblinksView, _ev: &ClickEvent, window: &mut Window, cx: &mut Context<WeblinksView>| {
        this.focus_handle.dispatch_action(&RefreshList, window, cx);
    }))
    .label("刷新")
```

## Modal -> dispatch 问题与解决

modal 的 `on_ok` 中调用 `window.dispatch_action(...)` 可能无法到达主视图；解决：
- 直接在 `on_ok` 用 `Entity`/`WeakEntity` 更新目标
- 在打开 modal 时捕获 `FocusHandle` 并用 `focus_handle.dispatch_action(...)`
- 在 App 层注册全局 `cx.on_action(...)`

`on_ok` 示例（使用 focus_handle）：

```rust
let fh = self.focus_handle.clone();
window.open_modal(cx, move |this, window, cx| {
    this.on_ok(move |_, window, cx| {
        fh.dispatch_action(&AddWebLink { title, url, description }.boxed_clone(), window, cx);
        true
    })
});
```

## 后台任务（spawn）安全地更新 UI

不要在 async 中跨 await 持有 `&mut Window` 或 `&mut Context`；捕获 `window.handle` 或 `WeakEntity`，后台完成后用 `handle.update` / `cx.update` 回到前台。

```rust
Button::new("fetch")
    .on_click(|_ev, window: &mut Window, cx: &mut Context<_>| {
        let handle = window.handle;
        cx.spawn(async move |_, cx| {
            let bytes = reqwest::get("https://example.com/image.png").await.unwrap().bytes().await.unwrap();
            handle.update(cx, |_, window, cx| {
                window.push_notification(&format!("下载完成：{} 字节", bytes.len()), cx);
                Ok(())
            }).ok();
            anyhow::Ok(())
        }).detach();
    });
```

## 诊断建议（简要）

- 在 `on_click` / `on_action` 内打印日志以确认是否触发。
- 使用 [`window.available_actions(cx)`](gpui/src/issue/events-actions.md:1) 查看当前可用 actions。
- 若 dispatch 未到达，尝试 `focus_handle` 或直接调用实体方法。

---