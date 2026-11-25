# Liberty-Users

Liberty 客户端的登录数据库（由客户端从 GitHub 直接读取）。

## 格式

`users.json`：

```json
{
  "users": [
    { "name": "Admin",  "password": "sha256:<64位hex>", "tier": "beta"   },
    { "name": "Friend", "password": "plain:123456",    "tier": "stable" }
  ]
}
```

| 字段 | 说明 |
|---|---|
| `name` | 登录用户名（不区分大小写） |
| `password` | `sha256:<hex>`（推荐）、`plain:<明文>`、裸 64 位 hex（按 sha256）、其他按明文 |
| `tier` | `beta` 或 `stable`，缺省 `stable` |

## 加一个新用户

1. 生成密码哈希：
   ```powershell
   .\tools\hash-password.ps1 -Password "你的密码"
   ```
2. 把输出（带 `sha256:` 前缀）填进 `users.json`，设置 `tier`。
3. 提交并推送（GitHub Desktop 里点 Commit → Push）。

## 校验某个密码是否正确

```powershell
.\tools\check-password.ps1 -Password "候选密码" -Hash "sha256:xxxx"
```

## 安全说明

- SHA-256 是**单向**的：GitHub 上只有哈希，不能反推出原密码。
- 原密码请保存在密码管理器或本地的 `passwords.local.txt`（此文件已加入 `.gitignore`，不会上传）。
- 公开仓库中的哈希仍可能被暴力破解，请使用足够长的随机密码。
