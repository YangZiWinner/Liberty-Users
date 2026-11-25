# Liberty-Users

Liberty 客户端登录数据库。客户端从 GitHub 直接读取本仓库的 `users.json`。

## 字段说明

| 字段 | 必填 | 说明 |
|---|---|---|
| `name` | 是 | 登录用户名，不区分大小写 |
| `password` | 是 | `sha256:<64位hex>`（推荐）、`plain:<明文>`、裸 64 位 hex（按 sha256 处理）、其他按明文 |
| `tier` | 否 | `beta` 或 `stable`，缺省 `stable`；决定标题显示 `(Beta)` 还是 `(Stable)` |
| `dev` | 否 | `true` 或 `false`，缺省 `false`；`true` 时该账号是 **Dev**，标题/HUD 显示 `[DEV]` |

`tier` 和 `dev` 完全独立：可以是 Dev + Beta，也可以是 Dev + Stable。

## 添加一个人（完整流程）

### 1. 生成密码哈希

在仓库目录打开 PowerShell：

```powershell
cd D:\MyProject\Liberty-Users
.\tools\hash-password.ps1 -Password "这个人的密码"
```

输出形如 `sha256:9f86d0...`，复制它。

### 2. 编辑 `users.json`

在 `users` 数组里加一条对象（注意逗号）：

```json
{
  "name": "张三",
  "password": "sha256:9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08",
  "tier": "beta",
  "dev": false
}
```

- 要给他 **Beta**：`"tier": "beta"`；要 **Stable**：`"tier": "stable"`
- 要给他 **Dev**：`"dev": true`；普通用户写 `false` 或直接省略

### 3. 校验（可选但推荐）

```powershell
.\tools\check-password.ps1 -Password "这个人的密码" -Hash "sha256:9f86d0..."
```

输出 `MATCH` 就说明哈希没写错。

### 4. 提交并推送

在 GitHub Desktop 中：

1. 左侧应出现 `users.json` 的改动；
2. 左下角 Summary 填一句说明，例如 `Add user zhangsan`；
3. 点 **Commit to main**；
4. 点顶部的 **Push origin**。

> 也可以直接在 GitHub 网页上打开 `users.json` → 铅笔图标编辑 → Commit changes。

### 5. 生效

- 客户端下次打开登录界面时就会拉取最新数据库（已加 `v=时间戳` 参数绕过 GitHub CDN 缓存，一般立即生效）。
- 若要立刻验证，重新登录一次即可；标题会显示 `(Beta)`/`(Stable)`，Dev 账号前面多一个 `[DEV]`。

## 修改 / 删除已有用户

| 需求 | 做法 |
|---|---|
| 把 Beta 改成 Stable | 改该用户的 `"tier": "stable"` |
| 给某人加 Dev | 加 `"dev": true` |
| 取消 Dev | 改 `"dev": false` |
| 改密码 | `hash-password.ps1` 生成新哈希并替换 |
| 删除用户 | 删掉整个 `{ ... }` 对象（注意前后逗号） |

改完同样 **Commit → Push** 即可。

## 安全提醒

- GitHub 上只有哈希，**无法反推出原密码**。
- 原密码请保存在本地 `passwords.local.txt`（已加入 `.gitignore`）或密码管理器。
- 公开仓库的哈希仍可能被暴力破解，请使用足够长的随机密码。
