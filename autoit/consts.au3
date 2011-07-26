
; -------------------------------------------------------------------------------------------
; Константы
; -------------------------------------------------------------------------------------------

; экранные координаты центра клиента для базового разрешения
Global const $cc_b[2] = [840, 517]
; экранные кнопки прокрутки друзей клиента для базового разрешения
Global const $fp_b[2] = [453, 888]
;~ Global const $fp_b[2] = [433, 900]
; координаты левого нижнего угла клиента для базового разрешения
Global const $cp_b[2] = [0, 972]
; координаты звезды для базового разрешения
Global const $sp_b[2] = [835, 816]

; --- Bitmaps -------------------------------------------------------------------------------
; Битмапы элементов управления игры, суть массивы цветов ячеек.
; Помогают точно определить положения элементов управления.
; Центр звезды
Global Const $starBitmap[4][4] = [[0xC9C2BC,0xCEC7C3,0xC3BCB6,0xB5AEA9],[0xCFC8C3,0xC4BDB9,0xB6AFAC,0xB3ACA6],[0xC7C0BD,0xB9B2AC,0xB1AAA6,0xB6AFAC],[0xBCB5B0,0xB3ACA7,0xB6AFAA,0xB4ADA8]]
; Маленькая звезда над меню звезды
Global Const $menuBitmap[4][4] = [[0xADA6A2,0xA29B97,0x9F9895,0x9C958F],[0xA7A09A,0xA29B96,0x9A938F,0x9C9590],[0xA59F9D,0x9C928A,0x98908B,0x98908D],[0x898691,0x838E9C,0x949497,0x938D8A]]
Global Const $Water[5][5] = [[0xDFC7A7, 0x675F5F, 0x37372F, 0x473F37, 0x777F27], [0x776F4F, 0x4F270F, 0x5F5737, 0xAF9F8F, 0x37373F], [0x5F672F, 0x4F1F0F, 0x5F6727, 0x5F6727, 0xDFAF8F], [0x8F874F, 0x4F1F0F, 0x6F772F, 0x4F571F, 0x676F27], [0x4F4F2F, 0x372F17, 0x4F571F, 0x575F27, 0x4F4F1F]]
Global Const $Field[5][5] = [[0xC7A767, 0xAF8747, 0xB78F4F, 0xBF9757, 0xAF8F3F], [0xA78F4F, 0xB7975F, 0xAF8F57, 0xB78F47, 0xAF8F4F], [0x937835, 0xBF9F5F, 0xBF9F67, 0xB79767, 0xA7873F], [0xAF8F4F, 0xAF8F5F, 0xAF8F57, 0x97873F, 0xAF874F], [0xA7874F, 0xA77F47, 0xAF8F4F, 0xB7975F, 0xA7874F]]
Global Const $Builds2[5][5] = [[0x591303, 0x120A05, 0x6D4824, 0xD09449, 0xC38A61], [0xF2D072, 0x6C6C6D, 0x484C51, 0x242931, 0x121118], [0xEAC36B, 0x171727, 0x7B7977, 0xB8B4AF, 0x8A8B8D], [0xB18B59, 0x3B4351, 0x74726D, 0x625F5E, 0x9E9A96], [0x52463E, 0x6B6E73, 0x6C6764, 0xEEEDEC, 0x90918E]]
Global Const $GoGame[5][5] = [[0x328AC3, 0x358BC4, 0x318AC4, 0x1A7EBE, 0x1678B3], [0x298AC9, 0x288AC8, 0x268ACA, 0x147FC4, 0x0074BE], [0x2085C6, 0x1881C5, 0x1682C5, 0x0678C1, 0x0071BD], [0x1980C3, 0x117EC3, 0x087AC2, 0x0074BE, 0x006FBC], [0x117DC2, 0x0979C2, 0x0378C1, 0x0D76B6, 0x609193]]
Global Const $LoginB[5][5] = [[0xB9B185, 0xB9B185, 0x958454, 0x835B1A, 0x835B1A], [0xFFFFD1, 0xFFFFE3, 0xFFFFEB, 0xD9D5B7, 0x907536], [0xFFFFD1, 0xFFFFDC, 0xFFFFEB, 0xFFFFEB, 0xEAE7C4], [0xFFFFD6, 0xFFFFE3, 0xFFFFE3, 0xFFFFDC, 0xFFFFCD], [0xFFFFE3, 0xFFFFE3, 0xFFFFDC, 0xFFFFCD, 0xFFFFC1]]
Global Const $LoginE[5][5] = [[0x5B4A2A, 0x5B4A2A, 0x5B4A2A, 0x5B4A2A, 0x5B4A2A], [0x5B4A2A, 0x5B4A2A, 0x5B4A2A, 0x5B4A2A, 0x5B4A2A], [0xE3CB8F, 0xE3CB8F, 0xE3CB8F, 0xE3CB8F, 0xE3CB8F], [0x5B4A2A, 0x5B4A2A, 0x5B4A2A, 0x5B4A2A, 0x5B4A2A], [0x5B4A2A, 0x5B4A2A, 0x5B4A2A, 0x5B4A2A, 0x5B4A2A]]
;~ [[0xE3CB8F, 0xE3CB8F, 0xE3CB8F, 0xE3CB8F, 0xE3CB8F], [0x5B4A2B, 0x5B4A2B, 0x5B4A2B, 0x5B4A2B, 0x5B4A2B], [0x5B4A2B, 0x5B4A2B, 0x5B4A2B, 0x5B4A2B, 0x5B4A2B], [0x5B4A2A, 0x5B4A2A, 0x5B4A2A, 0x5B4A2A, 0x5B4A2A], [0xE3CB8F, 0xE3CB8F, 0xE3CB8F, 0xE3CB8F, 0xE3CB8F]]
Global Const $PassE[5][5] = [[0x5C4C2B, 0x5C4C2B, 0x5C4C2B, 0x5C4C2B, 0x5C4C2B], [0xE3CB8F, 0xE3CB8F, 0x5C4C2B, 0x5C4C2B, 0xE3CB8F], [0x5C4C2B, 0x5C4C2B, 0xE3CB8F, 0x5C4C2B, 0x5C4C2B], [0x5C4C2B, 0x5C4C2B, 0xE3CB8F, 0x5C4C2B, 0x5C4C2B], [0x5C4C2B, 0x5C4C2B, 0xE3CB8F, 0x5C4C2B, 0x5C4C2B]]
Global Const $EinlogB[5][5] = [[0x645231, 0x564528, 0x513F25, 0x514027, 0x5A482E], [0x827145, 0x7D6C43, 0x7A6A42, 0x7E6D48, 0x8C7A55], [0xBDA96E, 0xBAA56C, 0xBCA66D, 0xD0B779, 0xEACC89], [0xEBD68E, 0xECD48D, 0xECD38D, 0xECD18B, 0xEBCD8B], [0x695635, 0x55432A, 0x5E4C31, 0x7C6845, 0x9C8458]]
Global Const $BOKStart[5][5] = [[0x010101, 0x010101, 0x010101, 0x010101, 0x010101], [0x6A604D, 0x6F6551, 0x020202, 0x685F4C, 0x796F59], [0x726853, 0x15130F, 0x433D31, 0xA29477, 0xAA9C7D], [0x060605, 0x695F4C, 0x15130F, 0x1B1914, 0x7A705A], [0x756B55, 0x9B8D71, 0x988A6E, 0x413B30, 0x010101]]
Global Const $BSearchTr[5][5] =  [[0xB47F50, 0xA6805E, 0xEFF1F2, 0xD7D5D7, 0xD2D2D3], [0xB6865D, 0x875128, 0xC6BCAC, 0xE1E2E4, 0xE5E4EA], [0xA67950, 0xB88B64, 0xC7BBAA, 0xE6E4E8, 0xDEDBD9], [0xEEF0F2, 0xF9F7F5, 0xF0EDEC, 0xC9C6C4, 0xC5C0C0], [0xE3E4E4, 0xF1EBE8, 0xEFEAEA, 0xE1DEDC, 0xD5D2D0]]
Global Const $BSearchTrOk[5][5] = [[0xA6987A, 0xAA9C7D, 0xAFA183, 0xAFA183, 0xB2A589], [0x92856B, 0x95896D, 0x998D73, 0x998D73, 0x9C9178], [0x010101, 0x010101, 0x010101, 0x010101, 0x010101], [0x766C57, 0x796F59, 0x030202, 0x6D6552, 0x7F7662], [0x7F755E, 0x171511, 0x494337, 0xAA9D7F, 0xB2A589]]
Global Const $BRes1[5][5] = [[0xA19681, 0x94876C, 0x7D725B, 0x6E655E, 0xD9C5B8], [0xA19681, 0x94876C, 0x685E4B, 0x988E84, 0xD3BFB1], [0xA19681, 0x94876C, 0x403A2E, 0xB6AB9F, 0xD7C2B2], [0xA19681, 0x94876C, 0x464033, 0xA69E93, 0xE8D8C8], [0xA19681, 0x94876C, 0x706652, 0x8A817A, 0xF1E0D0]]
Global Const $BRes2[5][5] = [[0xF9AA7A, 0x504336, 0x844A31, 0x2F3424, 0x09223A], [0xE09C0C, 0x8F7260, 0xF88943, 0x5C3C12, 0x151D33], [0xD4AA29, 0xFFC79A, 0xC95014, 0x452C13, 0x44371F], [0xE3C493, 0xFC854A, 0x923C0A, 0x122833, 0x4C3222], [0xFFC289, 0xD1490D, 0x332E1F, 0x1B2931, 0x925506]]
Global Const $BRes3[5][5] = [[0x9A917F, 0x9E9583, 0x968D7C, 0x252524, 0xFFFFFF], [0x9A917F, 0x9E9583, 0x837C6D, 0x5B5B5B, 0xFFFFFF], [0x9A917F, 0x9E9583, 0x4B463E, 0xB2B2B2, 0xFFFFFF], [0x9A917F, 0x9E9583, 0x6D675A, 0x7C7C7C, 0xFFFFFF], [0x9A917F, 0x9E9583, 0x948C7B, 0x2E2E2E, 0xFFFFFF]]
Global Const $BRes4[5][5] = [[0x5B4733, 0xA18F8D, 0x9D6D6E, 0x4B3239, 0x5E432D], [0x8C7365, 0xB09295, 0x603B3B, 0x523638, 0x6E4D4A], [0x877461, 0x97696F, 0x4F3031, 0x7C4E4D, 0x36312B], [0x876452, 0x67414C, 0x5E4036, 0x4E3D3B, 0x473822], [0x826370, 0x653D39, 0x3A312D, 0x322B27, 0x755225]]
Global Const $BResOk[5][5] = [[0xA6987A, 0xAA9C7D, 0xAFA183, 0xAFA183, 0x928871], [0xA6987A, 0xAA9C7D, 0xAFA183, 0xAFA183, 0xB2A589], [0xA6987A, 0xAA9C7D, 0xAFA183, 0xAFA183, 0x635B4C], [0x100F0C, 0x201D17, 0x201E18, 0x11100D, 0x010101], [0x4D4739, 0x39352A, 0x3B362C, 0x514B3D, 0x958A73]]
Global Const $FieldBuild[5][5] = [[0xFCD374, 0xDFB43E, 0xFFC12F, 0xFBAC1C, 0xE9B149], [0xFBBF3D, 0xFFC544, 0xE6AD21, 0xFFB71F, 0xD99E2A], [0xDF9D20, 0xFDB426, 0xD39925, 0xC49626, 0xC08C20], [0xDE9E25, 0xC4841B, 0xEEB238, 0xCFA031, 0xAA761C], [0xD99925, 0xCB982E, 0xCE9227, 0xB77E1F, 0x9E6D1C]]
Global Const $WaterBuild[5][5] = [[0x0D0807, 0x3F331B, 0x080D1C, 0x2D5779, 0x42657D], [0x5C400F, 0x3E1F06, 0x4D3312, 0x47351E, 0x1A0D06], [0x745B36, 0x797566, 0x8D5D1F, 0x885B25, 0x5A3307], [0x606974, 0x9CC6D7, 0x653A0D, 0x4A2F0D, 0x5B3D16], [0x494D58, 0xA6C2C6, 0x764711, 0x634013, 0x5B3A0D]]
Global Const $BCloseBuilds[5][5] = [[0xC1772E, 0xC1762D, 0xC0742D, 0xB46925, 0xAE6322], [0xCE8536, 0xBB6F29, 0xB66C27, 0xB36926, 0xAE6424], [0xD88C3C, 0xB86E2A, 0xB26726, 0xB26725, 0xAE6524], [0xC87C31, 0xB66B27, 0xBC6D2A, 0xAE6424, 0xAC6223], [0xC4742C, 0xBD6C28, 0x9F571C, 0xB66925, 0xAF6423]]
Global Const $BHandel[5][5] = [[0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [0x6E5E48, 0x6E5E48, 0x6E5E48, 0x6E5E48, 0x6E5E48], [0x59472D, 0x59472D, 0x59472D, 0x59472D, 0x59472D], [0x59472D, 0xCFCAC3, 0x685840, 0x695942, 0xFAFAF9], [0x5A482E, 0xFEFDFD, 0x59472D, 0xAFA699, 0xA49A8C]]
Global Const $BAngebot[5][5] = [[0x484235, 0x13110E, 0x0C0B09, 0x0D0C09, 0x0D0C0A], [0x94876C, 0x9B8D71, 0xA19275, 0xA6987A, 0xAA9C7D], [0x94876C, 0x9B8D71, 0xA19275, 0xA6987A, 0xAA9C7D], [0x746A55, 0x2B271F, 0x090806, 0x090807, 0x2B2820], [0x221F19, 0x2F2B23, 0x534B3C, 0x564E3F, 0x332F25]]
Global Const $BAuswahlen[5][5] = [[0xA19681, 0x685F4C, 0x94876C, 0xA19275, 0xA6987A], [0xA19681, 0x94876C, 0x9B8D71, 0xA19275, 0xA6987A], [0xA19681, 0x28241D, 0x887C63, 0x95876C, 0x181612], [0xA19681, 0x13110E, 0x9B8D71, 0x6B614E, 0x595242], [0xA19681, 0x0F0E0B, 0x978A6E, 0x625947, 0x8E8268]]
Global Const $BTrade[5][5] = [[0x855829, 0x4C2C0E, 0x754E22, 0x7F5425, 0x4E3316], [0x8D5F2C, 0x492C0F, 0x774D22, 0x7C5523, 0x623A12], [0x8C602C, 0x41260B, 0x42200E, 0x37200B, 0x624E33], [0x512E15, 0x2D1B10, 0x97882E, 0xE6D168, 0xE1C386], [0x875F22, 0xE3B138, 0xB07C23, 0x582C11, 0x331C1F]]
Global Const $BMessages[5][5] = [[0xEAC465, 0x9B7033, 0x775A64, 0x7F7B7B, 0x231C1A], [0xCD9938, 0xBC9E7C, 0xA9ABAF, 0x332925, 0x271B14], [0xA57124, 0xC2A4A1, 0x9D9996, 0x1D1815, 0x584D47], [0x936C24, 0xA99CA0, 0xA29B97, 0x1F1B17, 0x786E67], [0xA6731F, 0xC0A594, 0xB4B1B3, 0x28211C, 0x4E443C]]
Global Const $TMessages[5][5] = [[0xFFFFFF, 0xFBFBFB, 0xABA9A4, 0x5B554D, 0x332C21], [0x726D66, 0x332C22, 0x322C21, 0x332C22, 0x332C21], [0x342D22, 0x332C22, 0x322C21, 0x332C22, 0x332C21], [0x59534B, 0xCFCDCB, 0xFEFEFE, 0xFDFDFD, 0xCECCC9], [0xDBDAD8, 0xFFFFFF, 0xE7E6E4, 0xE7E7E5, 0xFFFFFF]]
Global Const $TradeTab2[5][5] = [[0x59472D, 0xA99F92, 0xB7AFA4, 0x68573F, 0x68573F], [0x59472D, 0xFFFFFF, 0x74654F, 0x59472D, 0x59472D], [0x59472D, 0x59472D, 0x59472D, 0x59472D, 0x59472D], [0xD6D1CB, 0xD6D1CB, 0xD6D1CB, 0xD6D1CB, 0xD6D1CB], [0xA89F91, 0xBFB8AE, 0xA89F91, 0xA89F91, 0xA89F91]]
Global Const $TradeTab3[5][5] = [[0x59472D, 0x59472D, 0xA69C8F, 0xB1A99D, 0x59472D], [0x5A482E, 0x59472D, 0xA69C8F, 0xD2CDC6, 0xD2CDC6], [0x5C4A31, 0x59472D, 0xA59B8D, 0xADA497, 0xADA497], [0x59472D, 0x59472D, 0x59472D, 0x59472D, 0x59472D], [0x59472D, 0x59472D, 0xADA497, 0xC7C1B9, 0xC7C1B9]]
Global Const $TItem0[5][5] = [[0x836641, 0x836641, 0x2E180B, 0x624528, 0xE1D292], [0x836641, 0x836641, 0x402A14, 0x3E1B05, 0x93582B], [0x7A5E3B, 0x836641, 0x51381D, 0x3F220A, 0x834C27], [0x361D09, 0x7C603C, 0x705534, 0x281301, 0x764C27], [0x643C1B, 0x311703, 0x3F250E, 0x261101, 0x583619]]
Global Const $ProviantLager3[5][5] = [[0xDFAF77, 0x973F2F, 0xAF574F, 0x474F17, 0x878737], [0x572727, 0xF78F7F, 0x7F372F, 0x9F8F4F, 0x3F3717], [0x6F2727, 0xAF5F4F, 0xA79757, 0xAFA757, 0xAF9777], [0xAF5F4F, 0x572F1F, 0x87873F, 0xC7A77F, 0xA78767], [0xE76F67, 0x4F471F, 0x777737, 0xA78767, 0xBFA787]]
Global Const $Kohlerei3[5][5] = [[0x371F17, 0x573727, 0x271F0F, 0x2F2717, 0x271F0F], [0x573F1F, 0x372F17, 0x4F2F1F, 0x3F2F17, 0x3F2F1F], [0x1F170F, 0x3F2F17, 0x372717, 0x171707, 0x372717], [0x342414, 0x27170F, 0x27170F, 0x3F2717, 0x47371F], [0x432C1B, 0x121109, 0x3F271F, 0x372717, 0x1F170F]]
Global Const $Kupfermine[3][3] = [[0x171F37, 0x9F8F7F, 0x978777], [0x774717, 0x9F8F7F, 0x8F7F6F], [0x271F17, 0xA7977F, 0x877767]]
Global Const $KupferBuild[5][5] = [[0xFDDDC1, 0x83542C, 0x81522A, 0xCFA47E, 0x593D26], [0x8A5B33, 0x3D1E03, 0x482405, 0x3D2108, 0x251506], [0x6A3B13, 0x4D2806, 0x3D2209, 0x1C1105, 0x180E04], [0x5B2F09, 0x764820, 0x201407, 0xB6490F, 0xCF5C1F], [0x885931, 0x624024, 0x170E04, 0xDC700C, 0xF9D355]]
Global Const $Kupfermine1[3][3] = [[0x162632, 0x3B393E, 0x988876], [0x453B28, 0x8A6231, 0x9F907E], [0x554A28, 0x3A3123, 0xA7977F]]
Global Const $Builds3[5][5] = [[0xB4B5B8, 0x929787, 0xC9C3BD, 0x0E0B07, 0x2A1F0F], [0xA1A8B2, 0x4D4E3C, 0xF2ECEE, 0x5E4A2D, 0x6F6148], [0xABB2BF, 0x433B24, 0xF6F5F6, 0xA1927D, 0x564124], [0x949EAB, 0x342314, 0xE3E5E9, 0xF7F4EE, 0xD0C6C0], [0xACB9D1, 0x472D15, 0x8F9182, 0xA8BDD2, 0x8B9B9A]]
Global Const $EisenBuild[5][5] = [[0xF9CDA7, 0xBB8C64, 0x7E4F27, 0x7D4E26, 0x96673F], [0xEDBE96, 0xC6976F, 0x84552D, 0x492506, 0x71421A], [0xD6A77F, 0xFDDDC1, 0x83542C, 0x81522A, 0x473B35], [0xFCDBBD, 0x8A5B33, 0x3D1E03, 0x3E2107, 0x0E131E], [0xDAAB83, 0x6A3B13, 0x4D2806, 0x1F1817, 0x0D1321]]
Global Const $Eisenmine[3][3] = [[0xB79FA7, 0x57373F, 0x4F3F2F], [0x77572F, 0x3F372F, 0x5F574F], [0x574737, 0x372717, 0x978777]]
Global Const $Goldschmelze[3][3] = [[0xA76F07, 0xFFFF07, 0x6E4C09], [0xCFC707, 0xFFFF77, 0x9F5F17], [0xFFE7B7, 0x71512B, 0x6E4D26]]
Global Const $Munzpragrerei[5][5] = [[0xE7C797, 0xBF9767, 0x8F5F2F, 0x57473F, 0x171717], [0xFFFFCF, 0x775F5F, 0x4F3F27, 0x373737, 0x2F271F], [0x4F4F17, 0xB2967E, 0xA7621F, 0x3E2E2E, 0x534443], [0x2F371F, 0x2F2727, 0x2F2F0F, 0x473727, 0x3F3727], [0x4F3F37, 0x473F37, 0x4F4F1F, 0x473727, 0x271F17]]
Global Const $BCancel[5][5] = [[0xAA9C7D, 0xAA9C7D, 0xAFA183, 0xB2A589, 0xB6AA8E], [0x978B6F, 0x978B6F, 0x9B8F74, 0x9E937A, 0xA2987F], [0x010101, 0x010101, 0x010101, 0x010101, 0x575244], [0x776D57, 0x776D57, 0x7A705B, 0x7C7360, 0x292620], [0xAA9C7D, 0xAA9C7D, 0xAFA183, 0xB2A589, 0x1B1A15]]
Global Const $BPrevFriend[5][5] =  [[0xA99E8C, 0x9E8E76, 0x887557, 0x7D6848, 0x7B6645], [0xA4957F, 0x7E6949, 0x978464, 0xBDAE90, 0xCBBC9F], [0x8B785B, 0x917D5D, 0xB7A88A, 0xAB9C7F, 0xA39477], [0x7F6B4B, 0xC6B698, 0xAFA083, 0xBBAC8F, 0xBBAC8F], [0x7B6645, 0xD4C5A7, 0xA49578, 0xBCAD90, 0xBBAC8F]]
Global const $Stein[5][5] = [[0x575727, 0x675F3F, 0x978F5F, 0x473F17, 0xAFA76F], [0x372F0F, 0x675F3F, 0x4F472F, 0x574F37, 0x27270F], [0x674F17, 0x57573F, 0xCF9757, 0x978F5F, 0x4F4737], [0x17171F, 0x875F1F, 0x674F2F, 0x777707, 0x2F2F0F], [0x2F1F0F, 0x271F17, 0x97672F, 0x3F2F1F, 0xBFB787]]
Global const $Mine[5][5] = [[0x97870F, 0x47370F, 0x2F270F, 0x3F2F0F, 0x070707], [0x473F0F, 0x3F270F, 0x070707, 0x1F0F07, 0x4F3F0F], [0x3F270F, 0x070707, 0x3F270F, 0x574F1F, 0x574717], [0x6F573F, 0x4F3F0F, 0x573F0F, 0x9B8C0E, 0x47370F], [0x47473F, 0x473F3F, 0x453E0E, 0x2F1F0F, 0x473707]]
Global const $BOKStartBeta[5][5] = [[0x8E8369, 0xB2A589, 0xBBAF95, 0xBCB097, 0xC5BAA4], [0xAA9C7D, 0xB2A589, 0xBBAF95, 0xBCB097, 0xC5BAA4], [0x95896D, 0x9C9178, 0xBBAF95, 0xBCB097, 0xC5BAA4], [0x010101, 0x27241E, 0xBBAF95, 0xBCB097, 0xC5BAA4], [0x796F59, 0x7F7662, 0xBBAF95, 0xBCB097, 0xC5BAA4]]

; чтобы не запоминать наименования переменных, сводим их в массив с нормальными русскими названиями
;~ последние 4 параметра указываются относительно $clientCenter: искать в пределах $clientCenter - x1, $clientCenter - y1 до $clientCenter + x2, $clientCenter + y2
Global $bitmaps[48][6] = [ _
['Логин', $LoginB], _
['Авторизация', $EinlogB], _
['Ввод логина', $LoginE], _
['Ввод пароля', $PassE], _
['Вход в игру', $GoGame], _
['ОкСтарт', $BOKStart], _
['ОкСтартБета', $BOKStartBeta], _
['Родник', $Water], _
['Искать сокровища', $BSearchTr], _
['Искать сокровища Ок', $BSearchTrOk], _
['ИскатьКамень', $BRes1], _
['ИскатьМедная руда', $BRes2], _
['ИскатьМрамор', $BRes3], _
['ИскатьЖелезная руда', $BRes4], _
['РесурсОк', $BResOk], _
['Постройки2', $Builds2], _
['Постройки3', $Builds3], _
['СтроитьПоле', $FieldBuild], _
['СтроитьРодник', $WaterBuild], _
['СтроитьМедная руда', $KupferBuild], _
['СтроитьЖелезная руда', $EisenBuild], _
['ЗакрытьПостройки', $BCloseBuilds], _
['Рынок', $BHandel], _
['Предложение на Рынок', $BAngebot], _
['Сообщения', $BMessages], _
['Отменить', $BCancel], _
['Провиант3', $ProviantLager3], _
['Угольщик3', $Kohlerei3], _
['Медная руда', $Kupfermine], _
['Золотоплавильня', $Goldschmelze], _
['Монетный двор', $Munzpragrerei], _
['Медная руда1', $Kupfermine1], _
['Железная руда', $Eisenmine], _
['Предыдущий друг', $BPrevFriend], _
['Камень', $Stein], _
['Шахта', $Mine], _
['Поле', $Field] _
]

; Заголовок искомого окна браузера с игрой
;~ Global Const $browserTitle = "The Settlers Online - Beta"
;Global Const $browserTitle = "Die Siedler Online"
Global Const $browserTitle = "Online"

; --- Browsers ------------------------------------------------------------------------------
; Параметры поиска клиента игры для всех доступных браузеров в формате
; [ "Наименование браузера", "Класс окна браузера", "Класс окна Flash-плагина с игрой" ]

Global Const $browsers[6][3] = [ _
	["Chrome",             "Chrome_WidgetWin_0",                     "NativeWindowClass"], _
	["Opera",              "OperaWindowClass",                       "aPluginWinClass"], _
	["Firefox",            "MozillaUIWindowClass",                   "GeckoPluginWindow"], _
	["Firefox4",           "MozillaWindowClass",                     "GeckoPluginWindow"], _
	["Safari",             "{1C03B488-D53B-4a81-97F8-754559640193}", "WebPluginView"], _
	["Internet Explorer",  "IEFrame",                                "MacromediaFlashPlayerActiveX"] _
]


; --- Hashes --------------------------------------------------------------------------------
; Хэши различных объектов игры (см. PixelChecksum).
; Служат для того, чтобы быстро определять находится ли в определённой точке экрана то, что мы ищем или нет
; Например, определяем открыта ли звезда, является ли данный баф рыбой или нет.

; Хэши слотов с ресурсами в меню звезды
Global Const $slotHashes[32][2] = [ _
	[1969295491, 'Empty'], _              ; 00
	[2416256132, 'Fishfood'], _           ; 01
	[1257575554, 'Wildfood'], _           ; 02 "Musk deer fragrance"
	[1688480899, '+ Settlers'], _         ; 03
	[901125509,  '+ Fir wood planks'], _  ; 04
	[2273910955, '+ Stones'], _           ; 05
	[1936465211, '+ Hard wood planks'], _ ; 06
	[2954964255, '+ Marble'], _           ; 07
	[1548164947, '+ Gold'], _             ; 08
	[1936465211, '+ Hard wood planks'], _ ; 09
	[2098664818, '+ Tools'], _            ; 10
	[2777357247, '+ Coal'], _             ; 11
	[724247114,  '30 minutes buff'], _    ; 12 "Fish plate"
	[193206745,  '2 hours buff'], _       ; 13 "Solid Sandwich"
	[3880594669, '6 hours buff'], _       ; 14 "Aunt Irma's Gift Basket"
	[1780684021, '12 hours'], _           ; 15 корзинок с экзотическими фруктами (12h)
	[3602066251, 'Entdecker'], _          ; 16 Разведчик
	[2499875422, 'Geolog'], _			  ; 17 Геолог
	[3032490639, 'Easter egg'], _         ; 18 пасхальных яиц
	[3402834920, '+ Eisenschwerter'], _   ; 19 Железные мечи
	[1410014200, '+ Langbogen'], _        ; 20 Длинные луки
	[4150205684, '+ Bogen'], _          	; 21 Обычные луки
	[4017165555, 'DiaGeolog'], _			; 22 Геолог из магазина - ищет в два раза быстрее
	[2198547851, 'Titanerz'], _				; 23 - татановая руда
	[924522487, 'Pferde'], _	 		  ; 24 - Лошади
	[3866894248, 'Würste'], _			  ; 25 - Колбаса
	[1609181901, 'Kartenfragment'], _	  ; 26 - Фрагмент карты
	[1365717319, 'Brote'], _			  ; 27 - Хлеб
	[1501306444, 'Bronzenswetter'], _	  ; 28 - Бронзовые мечи
	[164173899, 'Granit'], _              ; 29 - гранит
	[28517460, 'Edelholz'], _              ; 30 - Тройные бревна
	[1641944559, 'Eisenerz'] _              ; 31 - железная руда
]

; Хэши разных элементов игры
Global Const $AllHashes[20][2] = [ _
	[3001234158, 'Найдены сокровища'], _ 
	[278665307, 'Предложение торговли'], _ 
	[893854267, 'Подарок'], _ 
	[1213474123, 'Сражение'] _         
]

; Ширина и высота итема в окне торговли
Global const $isize[2] = [80,40]

Global const $build_b[4][4] = [ _
[2, 'Медная руда', 'Медная руда1', 'Медная руда'], _		; медь
[2, 'Поле', '0', 'Поле'], _ ; кукуруза
[2, 'Родник', '0', 'Родник'], _ ; родник
[3, 'Железная руда',	'0', 'Железная руда'] _; сталь
]

Global const $items[43][3] = [ _ ;Наименование товара, номер закладки, номер итема
['Бревна',  1, 1], _
['Доски',  1, 2], _
['Камень',  1, 3], _
['Рыба',  1, 4], _
['Яйца',  1, 5], _
['Уголь',  2, 1], _
['Медная руда',  2, 2], _
['Медь',  2, 3], _
['Инструменты',  2, 4], _
['Вода',  2, 5], _
['Кукуруза',  2, 6], _
['Пиво',  2, 7], _
['Мука',  2, 8], _
['Хлеб',  2, 9], _
['Медные мечи',  2, 10], _
['Луки',  2, 11], _
['Двойные бревна',  3, 1], _
['Двойные доски',  3, 2], _
['Железная руда',  3, 3], _
['Железо',  3, 4], _
['Сталь',  3, 5], _
['Золотая руда',  3, 6], _
['Золотые слитки',  3, 7], _
['Золото',  3, 8], _
['Мрамор',  3, 9], _
['Окорочка',  3, 10], _
['Колбаса',  3, 11], _
['Кони',  3, 12], _
['Железные мечи',  3, 13], _
['Стальные мечи',  3, 14], _
['Тройные бревна',  4, 1], _
['Тройные доски',  4, 2], _
['Титановая руда',  4, 3], _
['Титан',  4, 4], _
['Селитра',  4, 5], _
['Порох',  4, 6], _
['Гранит',  4, 7], _
['Колеса',  4, 8], _
['Колесница',  4, 9], _
['Сабля',  4, 10], _
['Арбалет',  4, 11], _
['Пушка',  4, 12] _
]


;~ #Include <Array.au3>

;~ _ArrayDisplay($items)
