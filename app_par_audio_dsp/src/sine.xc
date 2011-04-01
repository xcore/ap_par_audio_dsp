// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>


/*
 * One quarter of a sine wave is stored in an array called sineWave. 513
 * values are stored representing the data in 512 steps from 0 to pi/2.
 *
 * The data in sineWave is stored multiplied by 2^23-1, so the numbers are
 * between
 *
 *       0 = sineWave[0]   = (sin(0)*(2^23-1)) and
 * 8388607 = sineWave[512] = (sin(pi/2)*(2^23-1)).
 *
 * This table can be used to lookup a complete sine or cosine by negating
 * and or flipping the quarter sine wave.
 */

int sineWave[513] = {
0, 25735, 51471, 77206, 102941, 128674, 154406, 180137, 205866,
231593, 257318, 283041, 308761, 334478, 360192, 385902, 411609,
437312, 463011, 488705, 514395, 540080, 565760, 591435, 617104,
642767, 668424, 694075, 719719, 745357, 770988, 796611, 822227,
847835, 873435, 899027, 924610, 950185, 975751, 1001307, 1026855,
1052392, 1077920, 1103437, 1128944, 1154441, 1179926, 1205401,
1230864, 1256315, 1281755, 1307183, 1332598, 1358001, 1383391,
1408768, 1434132, 1459482, 1484818, 1510141, 1535449, 1560743,
1586022, 1611286, 1636536, 1661769, 1686987, 1712189, 1737375,
1762545, 1787698, 1812834, 1837954, 1863056, 1888140, 1913207,
1938255, 1963286, 1988297, 2013291, 2038265, 2063220, 2088155,
2113071, 2137967, 2162843, 2187699, 2212534, 2237348, 2262141,
2286913, 2311663, 2336392, 2361098, 2385783, 2410444, 2435084,
2459700, 2484293, 2508863, 2533409, 2557931, 2582429, 2606903,
2631352, 2655777, 2680176, 2704551, 2728900, 2753223, 2777520,
2801791, 2826036, 2850254, 2874446, 2898610, 2922747, 2946856,
2970938, 2994992, 3019018, 3043015, 3066983, 3090923, 3114834,
3138715, 3162567, 3186388, 3210180, 3233942, 3257673, 3281374,
3305044, 3328683, 3352290, 3375866, 3399410, 3422922, 3446401,
3469849, 3493263, 3516645, 3539994, 3563309, 3586591, 3609839,
3633053, 3656233, 3679379, 3702490, 3725566, 3748607, 3771612,
3794582, 3817517, 3840415, 3863278, 3886104, 3908893, 3931646,
3954361, 3977040, 3999681, 4022284, 4044850, 4067377, 4089866,
4112317, 4134729, 4157102, 4179436, 4201730, 4223985, 4246200,
4268376, 4290511, 4312605, 4334659, 4356673, 4378645, 4400576,
4422466, 4444314, 4466120, 4487884, 4509606, 4531286, 4552923,
4574517, 4596067, 4617575, 4639039, 4660460, 4681837, 4703169,
4724457, 4745701, 4766901, 4788055, 4809164, 4830228, 4851247,
4872220, 4893147, 4914028, 4934862, 4955650, 4976392, 4997087,
5017735, 5038335, 5058888, 5079394, 5099851, 5120261, 5140622,
5160936, 5181200, 5201416, 5221583, 5241700, 5261768, 5281787,
5301756, 5321675, 5341545, 5361363, 5381132, 5400849, 5420516,
5440132, 5459697, 5479210, 5498671, 5518081, 5537439, 5556745,
5575999, 5595200, 5614348, 5633444, 5652486, 5671475, 5690411,
5709294, 5728122, 5746897, 5765618, 5784284, 5802896, 5821453,
5839956, 5858403, 5876796, 5895133, 5913414, 5931640, 5949810,
5967925, 5985983, 6003984, 6021929, 6039818, 6057649, 6075424,
6093141, 6110801, 6128403, 6145948, 6163435, 6180864, 6198235,
6215547, 6232801, 6249996, 6267133, 6284210, 6301229, 6318188,
6335087, 6351927, 6368707, 6385427, 6402087, 6418687, 6435226,
6451705, 6468123, 6484480, 6500777, 6517012, 6533185, 6549297,
6565348, 6581336, 6597263, 6613128, 6628930, 6644670, 6660348,
6675963, 6691514, 6707003, 6722429, 6737792, 6753091, 6768327,
6783498, 6798606, 6813650, 6828630, 6843546, 6858397, 6873184,
6887906, 6902563, 6917155, 6931682, 6946144, 6960540, 6974871,
6989137, 7003336, 7017470, 7031537, 7045538, 7059473, 7073342,
7087144, 7100879, 7114548, 7128149, 7141684, 7155151, 7168551,
7181883, 7195148, 7208345, 7221474, 7234535, 7247528, 7260453,
7273310, 7286098, 7298817, 7311468, 7324050, 7336563, 7349007,
7361382, 7373688, 7385924, 7398090, 7410187, 7422215, 7434172,
7446059, 7457877, 7469624, 7481301, 7492907, 7504443, 7515908,
7527303, 7538626, 7549879, 7561061, 7572171, 7583210, 7594178,
7605075, 7615899, 7626652, 7637334, 7647943, 7658481, 7668946,
7679339, 7689660, 7699908, 7710084, 7720188, 7730219, 7740177,
7750062, 7759874, 7769613, 7779279, 7788872, 7798392, 7807838,
7817210, 7826509, 7835735, 7844886, 7853964, 7862968, 7871898,
7880754, 7889535, 7898243, 7906876, 7915434, 7923918, 7932328,
7940663, 7948923, 7957108, 7965218, 7973254, 7981214, 7989099,
7996909, 8004644, 8012303, 8019887, 8027396, 8034829, 8042186,
8049468, 8056674, 8063804, 8070858, 8077836, 8084738, 8091564,
8098314, 8104988, 8111585, 8118106, 8124551, 8130919, 8137210,
8143425, 8149564, 8155625, 8161610, 8167518, 8173350, 8179104,
8184781, 8190381, 8195905, 8201351, 8206719, 8212011, 8217225,
8222362, 8227422, 8232404, 8237308, 8242136, 8246885, 8251557,
8256151, 8260668, 8265106, 8269467, 8273751, 8277956, 8282083,
8286132, 8290104, 8293997, 8297812, 8301550, 8305209, 8308790,
8312292, 8315717, 8319063, 8322331, 8325520, 8328631, 8331664,
8334619, 8337494, 8340292, 8343011, 8345651, 8348213, 8350696,
8353101, 8355427, 8357674, 8359843, 8361933, 8363945, 8365877,
8367731, 8369506, 8371203, 8372820, 8374359, 8375819, 8377200,
8378502, 8379725, 8380870, 8381936, 8382922, 8383830, 8384659,
8385409, 8386080, 8386672, 8387185, 8387620, 8387975, 8388251,
8388449, 8388567, 8388607
};

/*
 * The sine function computes a sine assuming its first argument is an
 * angle measued in units of pi/1024 radians. Because there are 2048
 * integral steps in a sinewave, the function first computes the argument
 * modulo 2048, and then it looks up the sine value for each of the four
 * quadrants of the winsewave.
 */
int sine(int x) {
    x = x & 2047;
    switch (x >> 9) {
    case 0: return sineWave[x];
    case 1: return sineWave[1024-x];
    case 2: return -sineWave[x-1024];
    case 3: return -sineWave[2048-x];
    }
    return 0;
}


