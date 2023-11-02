Config = {}
Config.target = true

Config.minEarn = 100
Config.maxEarn = 450
Config.RegisterEarnings = math.random(Config.minEarn, Config.maxEarn)
Config.resetTime = (60 * 1000) * 10
Config.registerresettime = (60 * 1000) * 10
Config.StolenRegisterResetTime = 15 --min
Config.tickInterval = 1000
Config.lockpicktime = 20 --seconds
Config.lockpickStress = math.random(3, 5)
Config.FailWireHEalthLoss = 10
Config.registerstealtime = 30 --seconds
Config.stealRegisterStress = math.random(4, 6)
Config.RegisterMoneyAmount = math.random(2,5)
Config.RegisterStealItem = 'wirecutter'
Config.safestress = math.random(2, 4)
Config.safeCodeChance = 30
Config.washcoinChance = 50
Config.washcoin = 'washcoin'
Config.deliverMoney = math.random(1250, 1550)

Config.safeRewardItems = {
    [1] = {
        amount = math.random(2,5),
        rewards = {
            'black_money',
            'rolex',
            'goldchain',
        }
    },
}

Config.RareSafeRewardChance = 25 --lower than this
Config.RareSafeReward = {
    [1] = {
        amount = 1,
        rewards = {
            'phone_n2',
        }
    }
}

Config.registerProps = {
    'prop_till_01_dam',
    'prop_till_01',
    'v_ret_gc_cashreg'
}

Config.Registers = {
    [1] = {vector3(-47.24,-1757.65, 29.53), robbed = false, stolen = false, time = 0, safeKey = 1, camId = 4},
    [2] = {vector3(-48.58,-1759.21, 29.59), robbed = false, stolen = false, time = 0, safeKey = 1, camId = 4},
    [3] = {vector3(-1486.26,-378.0,  40.16), robbed = false, stolen = false, time = 0, safeKey = 2, camId = 5},
    [4] = {vector3(-1222.03,-908.32, 12.32), robbed = false, stolen = false, time = 0, safeKey = 3, camId = 6},
    [5] = {vector3(-706.08, -915.42, 19.21), robbed = false, stolen = false, time = 0, safeKey = 4, camId = 7},
    [6] = {vector3(-706.16, -913.5, 19.21), robbed = false, stolen = false, time = 0, safeKey = 4, camId = 7},
    [7] = {vector3(24.45, -1347.37, 29.49), robbed = false, stolen = false, time = 0, safeKey = 5, camId = 8},
    [8] = {vector3(1134.15, -982.53, 46.41), robbed = false, stolen = false, time = 0, safeKey = 6, camId = 9},
    [9] = {vector3(1165.05, -324.49, 69.2), robbed = false, stolen = false, time = 0, safeKey = 7, camId = 10},
    [10] = {vector3(1164.7, -322.58, 69.2), robbed = false, stolen = false, time = 0, safeKey = 7, camId = 10},
    [11] = {vector3(372.59, 326.59, 103.57), robbed = false, stolen = false, time = 0, safeKey = 8, camId = 11},
    [12] = {vector3(-1818.9, 792.9, 138.08), robbed = false, stolen = false, time = 0, safeKey = 9, camId = 12},
    [13] = {vector3(-1820.17, 794.28, 138.08), robbed = false, stolen = false, time = 0, safeKey = 9, camId = 12},
    [14] = {vector3(-2966.46, 390.89, 15.04), robbed = false, stolen = false, time = 0, safeKey = 10, camId = 13},
    [15] = {vector3(-3039.05, 584.41, 7.91), robbed = false, stolen = false, time = 0, safeKey = 11, camId = 14},
    [16] = {vector3(-3242.39, 999.91, 12.83), robbed = false, stolen = false, time = 0, safeKey = 12, camId = 15},
    [17] = {vector3(549.04, 2671.24, 42.16), robbed = false, stolen = false, time = 0, safeKey = 13, camId = 16},
    [18] = {vector3(1165.9, 2710.81, 38.15), robbed = false, stolen = false, time = 0, safeKey = 14, camId = 17},
    [19] = {vector3(2677.99, 3279.42, 55.24), robbed = false, stolen = false, time = 0, safeKey = 15, camId = 18},
    [20] = {vector3(1960.08, 3740.16, 32.34), robbed = false, stolen = false, time = 0, safeKey = 16, camId = 19},
    [21] = {vector3(1727.9, 6415.32, 35.04), robbed = false, stolen = false, time = 0, safeKey = 17, camId = 20},
    [22] = {vector3(-161.07, 6321.23, 31.5), robbed = false, stolen = false, time = 0, safeKey = 18, camId = 27},
    [23] = {vector3(160.52, 6641.74, 31.6), robbed = false, stolen = false, time = 0, safeKey = 19, camId = 28},
    [24] = {vector3(162.16, 6643.22, 31.6), robbed = false, stolen = false, time = 0, safeKey = 19, camId = 29},
    [25] = {vector3(75.16, -1388.86, 29.38), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 40},
    [26] = {vector3(75.17, -1390.5, 29.38), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 40},
    [27] = {vector3(75.18, -1392.47, 29.38), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 40},
    [28] = {vector3(425.71, -810.44, 29.49), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 41},
    [29] = {vector3(425.79, -808.57, 29.49), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 41},
    [30] = {vector3(425.74, -806.78, 29.49), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 41},
    [31] = {vector3(-818.83, -1071.29, 11.33), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 42},
    [32] = {vector3(-820.45, -1072.18, 11.33), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 42},
    [33] = {vector3(-822.07, -1073.15, 11.33), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 42},
    [34] = {vector3(127.55, -222.73, 54.56), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 43},
    [35] = {vector3(126.94, -224.18, 54.56), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 43},
    [36] = {vector3(126.41, -225.89, 54.56), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 43},
    [37] = {vector3(-3170.12, 1041.57, 20.86), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 44},
    [38] = {vector3(-3169.41, 1043.18, 20.86), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 44},
    [39] = {vector3(-3168.71, 1044.88, 20.86), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 44},
    [40] = {vector3(-1098.48, 2713.51, 19.11), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 45},
    [41] = {vector3(-1099.76, 2712.26, 19.11), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 45},
    [42] = {vector3(-1101.19, 2710.99, 19.11), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 45},
    [43] = {vector3(613.05, 2760.97, 42.09), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 46},
    [44] = {vector3(612.9, 2762.78, 42.09), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 46},
    [45] = {vector3(612.84, 2764.52, 42.09), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 46},
    [46] = {vector3(1200.86, 2710.47, 38.22), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 47},
    [47] = {vector3(1199.06, 2710.38, 38.22), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 47},
    [48] = {vector3(1197.34, 2710.44, 38.22), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 47},
    [49] = {vector3(1694.63, 4818.7, 42.06), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 48},
    [50] = {vector3(1694.35, 4820.43, 42.06), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 48},
    [51] = {vector3(1694.2, 4822.29, 42.06), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 48},
    [52] = {vector3(1.87, 6509.44, 31.88), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 49},
    [53] = {vector3(3.21, 6510.65, 31.88), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 49},
    [54] = {vector3(4.57, 6512.01, 31.88), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 49},
    [55] = {vector3(1888.08, 3803.39, 33.32), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 50},
    [56] = {vector3(1887.24, 3804.83, 33.32), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 50},
    [57] = {vector3(1886.24, 3806.52, 33.32), robbed = false, stolen = false, time = 0, safeKey = 0, camId = 50},
}

Config.Safes = {
    [1] = {vector4(-43.43, -1748.3, 29.42,  52.5), type = "keypad", robbed = false, stolen = false, camId = 4},
    [2] = {vector4(-1478.94, -375.5, 39.16,  229.5), type = "padlock", robbed = false, stolen = false, camId = 5},
    [3] = {vector4(-1220.85, -916.05, 11.32,  229.5), type = "padlock", robbed = false, stolen = false, camId = 6},
    [4] = {vector4(-709.74, -904.15, 19.21, 229.5), type = "keypad", robbed = false, stolen = false, camId = 7},
    [5] = {vector3(24.4, -1343.88, 26.38), type = "keypad", robbed = false, stolen = false, camId = 8},
    [6] = {vector3(1126.77, -980.1, 45.41), type = "padlock", robbed = false, stolen = false, camId = 9},
    [7] = {vector3(1159.46, -314.05, 69.2), type = "keypad", robbed = false, stolen = false, camId = 10},
    [8] = {vector3(373.34, 329.71, 100.45), type = "keypad", robbed = false, stolen = false, camId = 11},
    [9] = {vector3(-1829.27, 798.76, 138.19), type = "keypad", robbed = false, stolen = false, camId = 12},
    [10] = {vector3(-2959.64, 387.08, 14.04), type = "padlock", robbed = false, stolen = false, camId = 13},
    [11] = {vector3(-3042.23, 583.41, 4.8), type = "keypad", robbed = false, stolen = false, camId = 14},
    [12] = {vector3(-3245.7, 1000.21, 9.72), type = "keypad", robbed = false, stolen = false, camId = 15},
    [13] = {vector3(549.58, 2667.93, 39.04), type = "keypad", robbed = false, stolen = false, camId = 16},
    [14] = {vector3(1169.31, 2717.79, 37.15), type = "padlock", robbed = false, stolen = false, camId = 17},
    [15] = {vector3(2675.0, 3281.02, 52.13), type = "keypad", robbed = false, stolen = false, camId = 18},
    [16] = {vector3(1958.31, 3742.96, 29.23), type = "keypad", robbed = false, stolen = false, camId = 19},
    [17] = {vector3(1729.32, 6418.34, 31.93), type = "keypad", robbed = false, stolen = false, camId = 20},
    [18] = {vector3(-168.40, 6318.80, 30.58), type = "padlock", robbed = false, stolen = false, camId = 27},
    [19] = {vector3(168.95, 6644.74, 31.70), type = "keypad", robbed = false, stolen = false, camId = 30},
    [20] = {vector3(-578.35, -715.21, 116.81), type = "padlock", robbed = false, stolen = false, camId = 27},
}

Config.pedmodels = {
    's_m_y_armymech_01',
    'csb_cletus',
    'a_m_y_cyclist_01',
    'u_m_m_filmdirector'
}

Config.RegiterDeliverLocs = {
    vector4(-950.76, -720.45, 19.92, 170.57),
    vector4(-568.74, -864.16, 26.33, 88.54),
    vector4(-262.0, -902.18, 32.31, 15.74),
    vector4(468.15, -230.35, 53.79, 241.1),
    vector4(356.95, 272.51, 103.09, 39.5),
    vector4(68.98, -1570.03, 29.6, 61.37),
    vector4(-234.45, -1490.59, 32.96, 267.07),
    vector4(-581.96, -1020.42, 22.33, 262.33),
    vector4(-253.36, -948.99, 31.22, 274.95),
    vector4(26.0, -1387.96, 29.3, 352.97)
}

Config.MaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [18] = true, [26] = true, [52] = true, [53] = true, [54] = true, [55] = true, [56] = true, [57] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [112] = true, [113] = true, [114] = true, [118] = true, [125] = true, [132] = true,
}
Config.FemaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [19] = true, [59] = true, [60] = true, [61] = true, [62] = true, [63] = true, [64] = true, [65] = true, [66] = true, [67] = true, [68] = true, [69] = true, [70] = true, [71] = true, [129] = true, [130] = true, [131] = true, [135] = true, [142] = true, [149] = true, [153] = true, [157] = true, [161] = true, [165] = true,
}
