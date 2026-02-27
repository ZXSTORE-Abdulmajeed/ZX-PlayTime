# 🎮 Playtime — QBCore FiveM Resource

Earn points for time played and spend them in the reward shop.

---

## 📦 Installation

1. Place the `playtime` folder inside your `resources` directory.
2. Add to `server.cfg`:
   ```
   ensure playtime
   ```
3. Make sure `qb-core` and `oxmysql` are running.
4. Start the server — the `playtime_points` table is created automatically.

---

## 🔊 Sounds

Place these audio files in `html/sounds/`:
- `click.wav`
- `close.wav`
- `open.wav`
- `touch.wav`

---

## ⚙️ Configuration (`config.lua`)

| Setting | Description |
|---------|-------------|
| `Config.PointsPerInterval` | Points awarded each interval (default: 1) |
| `Config.PointInterval` | Minutes between each reward (default: 5) |
| `Config.AdminGroups` | Groups allowed to use `/addp` |
| `Config.InventoryImagePath` | NUI path to your inventory images |
| `Config.ShopItems` | List of purchasable items |

---

## 🛒 Item Action Types

| `action` | Description |
|----------|-------------|
| `money`   | Gives cash to player |
| `bank`    | Deposits to bank account |
| `weapon`  | Gives weapon + ammo |
| `item`    | Adds item to inventory |
| `vehicle` | Spawns vehicle for player |

---

## 🖼️ Images

| Category | Image Source |
|----------|-------------|
| `items` / `weapons` | Auto-fetched from `qb-inventory` using the `item` field |
| `money` / `vehicles` | Set manually in the `image` field in `config.lua` |

---

## 💬 Commands

| Command | Permission | Description |
|---------|------------|-------------|
| `/playtime` | Everyone | Open/close the reward shop |
| `/addp [ID] [amount]` | Admin only | Add points to a player |

---

## 📁 File Structure

```
playtime/
├── fxmanifest.lua
├── config.lua
├── client/
│   └── client.lua
├── server/
│   └── server.lua
└── html/
    ├── index.html
    ├── style.css
    ├── script.js
    └── sounds/
        ├── click.wav
        ├── close.wav
        ├── open.wav
        └── touch.wav
```
