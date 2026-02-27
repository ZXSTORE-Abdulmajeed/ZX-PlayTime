Config = {}

Config.PointsPerInterval = 1 --نقطة لكل مده
Config.PointInterval     = 30 --30د
Config.AdminGroups       = { 'admin', 'god' }
Config.InventoryImagePath = 'nui://qb-inventory/html/images/' --مسار صور الايتمات

Config.Categories = { --الاقسام
    { id = 'money',    label = 'Money',    icon = '💰' },
    --{ id = 'weapons',  label = 'Weapons',  icon = '🔫' },
    { id = 'vehicles', label = 'Vehicles', icon = '🚗' },
    { id = 'items',    label = 'Items',    icon = '🎒' },
    --{ id = 'other',    label = 'Other',    icon = '🎒' },
}

Config.ShopItems = {
    ------------------------Money------------------------
    {
        label       = '$500 Cash', --الاسم
        description = 'Receive $500 cash directly.', --الوصف
        price       = 5, --كم يحتاج نقطة
        category    = 'money', --في اي قسم
        image       = 'nui://ZXPlayTime/html/image/money.png', --مسار الصورة
        action      = 'money', --نوع الشيء money, vehicles, items, weapons
        amount      = 500, --كم الكمية
    },
    {
        label       = '$2,000 Cash',
        description = 'Receive $2,000 cash directly.',
        price       = 15,
        category    = 'money',
        image       = 'nui://ZXPlayTime/html/image/money.png',
        action      = 'money',
        amount      = 2000,
    },
    {
        label       = '$5,000 Cash',
        description = 'Receive $5,000 cash directly.',
        price       = 35,
        category    = 'money',
        image       = 'nui://ZXPlayTime/html/image/money.png',
        action      = 'money',
        amount      = 5000,
    },
    {
        label       = '$10,000 Bank',
        description = 'Transfer $10,000 directly to your bank account.',
        price       = 60,
        category    = 'money',
        image       = 'nui://ZXPlayTime/html/image/money.png',
        action      = 'bank',
        amount      = 10000,
    },
    ------------------------Weapons------------------------
   --[[{
        label       = 'Pistol',
        description = 'Standard pistol added to your inventory bag.',
        price       = 20,
        category    = 'weapons',
        action      = 'weapon',
        item        = 'weapon_pistol',
    },
    {
        label       = 'SMG',
        description = 'Submachine gun added to your inventory bag.',
        price       = 50,
        category    = 'weapons',
        action      = 'weapon',
        item        = 'weapon_smg',
    },]]
    ------------------------Vehicles------------------------
    {
        label       = 'Tailgater S',
        description = 'Luxury supercar added to your garage.',
        price       = 240,
        category    = 'vehicles',
        image       = 'https://docs.fivem.net/vehicles/tailgater2.webp',
        action      = 'vehicle',
        model       = 'tailgater2',
        garage      = 'pillboxgarage',
    },
    {
        label       = 'Kanjo SJ',
        description = 'High-performance supercar added to your garage.',
        price       = 200,
        category    = 'vehicles',
        image       = 'https://docs.fivem.net/vehicles/kanjosj.webp',
        action      = 'vehicle',
        model       = 'kanjosj',
        garage      = 'pillboxgarage',
    },
    {
        label       = 'Omnis',
        description = 'Top-tier supercar added to your garage.',
        price       = 180,
        category    = 'vehicles',
        image       = 'https://docs.fivem.net/vehicles/omnis.webp',
        action      = 'vehicle',
        model       = 'omnis',
        garage      = 'pillboxgarage',
    },
    ------------------------Items------------------------
    {
        label       = 'Lockpick',
        description = 'A tool used to pick locks.',
        price       = 5,
        category    = 'items',
        action      = 'item',
        item        = 'lockpick',
        amount      = 1,
    },
    {
        label       = 'Body Armor',
        description = 'Full body armor vest.',
        price       = 15,
        category    = 'items',
        action      = 'item',
        item        = 'armor',
        amount      = 1,
    },
    {
        label       = 'Bandage',
        description = 'medical bandage for first aid.',
        price       = 3,
        category    = 'items',
        action      = 'item',
        item        = 'bandage',
        amount      = 1,
    },
}

-- https://discord.gg/zx0
--[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]