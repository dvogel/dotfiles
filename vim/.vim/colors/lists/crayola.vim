" Maintainer:  Drew Vogel <dvogel@sidejump.org>
" Last Change: 2021 Jul 25
"
" Color names used by Crayola™ branded crayons. The color values were sourced
" from  this Wikipedia article:
" https://en.wikipedia.org/wiki/List_of_Crayola_crayon_colors
"
" This color list has no official affiliation with Crayola™ and no Crayola™
" products were used in the making of the list.

" Standard colors
call extend(v:colornames, {
			\ 'crayola_red': '#ed0a3f',
			\ 'crayola_maroon': '#c32148',
			\ 'crayola_scarlet': '#fd0e35',
			\ 'crayola_brick_red': '#c62d42',
			\ 'crayola_chestnut': '#b94e48',
			\ 'crayola_orange_red': '#ff5349',
			\ 'crayola_sunset_orange': '#fe4c40',
			\ 'crayola_bittersweet': '#fe6f5e',
			\ 'crayola_vivid_tangerine': '#ff9980',
			\ 'crayola_burnt_orange': '#ff7034',
			\ 'crayola_red_orange': '#ff681f',
			\ 'crayola_orange': '#ff8833',
			\ 'crayola_macaroni_and_cheese': '#ffb97b',
			\ 'crayola_mango_tango': '#e77200',
			\ 'crayola_yellow_orange': '#ffae42',
			\ 'crayola_banana_mania': '#fbe7b2',
			\ 'crayola_maize': '#f2c649', 
			\ 'crayola_orange_yellow': '#f8d568',
			\ 'crayola_goldenrod': '#fcd667',
			\ 'crayola_dandelion': '#fed85d',
			\ 'crayola_yellow': '#fbe870',
			\ 'crayola_green_yellow': '#f1e788',
			\ 'crayola_olive_green': '#b5b35c',
			\ 'crayola_spring_green': '#ecebbd',
			\ 'crayola_canary': '#ffff99',
			\ 'crayola_lemon_yellow': '#ffff9f', 
			\ 'crayola_inchworm': '#afe313',
			\ 'crayola_yellow_green': '#c5e17a',
			\ 'crayola_asparagus': '#7ba05b',
			\ 'crayola_granny_smith_apple': '#9de093',
			\ 'crayola_fern': '#63b76c',
			\ 'crayola_green': '#01a638',
			\ 'crayola_forest_green': '#5fa777',
			\ 'crayola_sea_green': '#93dfb8',
			\ 'crayola_shamrock': '#33cc99',
			\ 'crayola_mountain_meadow': '#1ab385',
			\ 'crayola_jungle_green': '#29ab87',
			\ 'crayola_caribbean_green': '#00cc99',
			\ 'crayola_tropical_rain_forest': '#00755e',
			\ 'crayola_pine_green': '#01786f',
			\ 'crayola_robins_egg_blue': '#00cccc',
			\ 'crayola_teal_blue': '#008080',
			\ 'crayola_light_blue': '#8fd8d8',
			\ 'crayola_aquamarine': '#95e0e8', 
			\ 'crayola_turquoise_blue': '#6cdae7',
			\ 'crayola_outer_space': '#2d383a',
			\ 'crayola_sky_blue': '#76d7ea',
			\ 'crayola_blue_green': '#0095b7',
			\ 'crayola_pacific_blue': '#009dc4',
			\ 'crayola_cerulean': '#02a4d3',
			\ 'crayola_cornflower': '#93ccea',
			\ 'crayola_green_blue': '#2887c8', 
			\ 'crayola_midnight_blue': '#003366',
			\ 'crayola_navy_blue': '#0066cc',
			\ 'crayola_denim': '#1560bd',
			\ 'crayola_blue_iii ': '#0066ff',
			\ 'crayola_cadet_blue': '#a9b2c3',
			\ 'crayola_periwinkle': '#c3cde6',
			\ 'crayola_bluetiful': '#3c69e7',
			\ 'crayola_wild_blue_yonder': '#7a89b8',
			\ 'crayola_indigo': '#4f69c6',
			\ 'crayola_manatee': '#8d90a1',
			\ 'crayola_blue_bell': '#9999cc',
			\ 'crayola_violet_blue': '#766ec8', 
			\ 'crayola_blue_violet': '#6456b7',
			\ 'crayola_purple_heart': '#652dc1',
			\ 'crayola_royal_purple': '#6b3fa0',
			\ 'crayola_violet_ii ': '#8359a3',
			\ 'crayola_wisteria': '#c9a0dc',
			\ 'crayola_lavender_i ': '#bf8fcc', 
			\ 'crayola_vivid_violet': '#803790',
			\ 'crayola_purple_mountains_majesty': '#d6aedd',
			\ 'crayola_fuchsia': '#c154c1',
			\ 'crayola_pink_flamingo': '#fc74fd',
			\ 'crayola_orchid': '#e29cd2',
			\ 'crayola_plum': '#8e3179',
			\ 'crayola_thistle': '#d8bfd8',
			\ 'crayola_mulberry': '#c8509b', 
			\ 'crayola_red_violet': '#bb3385',
			\ 'crayola_jazzberry_jam': '#a50b5e',
			\ 'crayola_eggplant': '#614051',
			\ 'crayola_magenta': '#f653a6',
			\ 'crayola_cerise': '#da3287',
			\ 'crayola_wild_strawberry': '#ff3399',
			\ 'crayola_lavender_ii ': '#fbaed2',
			\ 'crayola_cotton_candy': '#ffb7d5',
			\ 'crayola_carnation_pink': '#ffa6c9',
			\ 'crayola_violet_red': '#f7468a',
			\ 'crayola_razzmatazz': '#e30b5c',
			\ 'crayola_piggy_pink': '#fdd7e4',
			\ 'crayola_blush': '#db5079',
			\ 'crayola_tickle_me_pink': '#fc80a5',
			\ 'crayola_mauvelous': '#f091a9',
			\ 'crayola_salmon': '#ff91a4',
			\ 'crayola_mahogany': '#ca3435',
			\ 'crayola_melon': '#febaad',
			\ 'crayola_pink_sherbert': '#f7a38e',
			\ 'crayola_burnt_sienna': '#e97451',
			\ 'crayola_brown': '#af593e',
			\ 'crayola_sepia': '#9e5b40',
			\ 'crayola_fuzzy_wuzzy': '#87421f',
			\ 'crayola_beaver': '#926f5b',
			\ 'crayola_tumbleweed': '#dea681',
			\ 'crayola_raw_sienna': '#d27d46',
			\ 'crayola_tan': '#fa9d5a', 
			\ 'crayola_desert_sand': '#edc9af',
			\ 'crayola_peach': '#ffcba4',
			\ 'crayola_apricot': '#fdd5b1',
			\ 'crayola_almond': '#eed9c4',
			\ 'crayola_raw_umber': '#665233', 
			\ 'crayola_shadow': '#837050',
			\ 'crayola_timberwolf': '#d9d6cf',
			\ 'crayola_gold_ii ': '#e6be8a',
			\ 'crayola_silver': '#c9c0bb',
			\ 'crayola_copper': '#da8a67',
			\ 'crayola_antique_brass': '#c88a65',
			\ 'crayola_black': '#000000',
			\ 'crayola_gray': '#8b8680',
			\ 'crayola_blue_gray': '#c8c8cd',
			\ 'crayola_white': '#ffffff',
			\ }, 'keep')

" Extreme Twistables:
call extend(v:colornames, {
			\ 'crayola_fiery_rose': '#ee34d2',
			\ 'crayola_sizzling_sunset': '#ff9966',
			\ 'crayola_heat_wave': '#fd5b78',
			\ 'crayola_lemon_glacier': 'ffff66',
			\ 'crayola_spring_frost': '#66ff66',
			\ 'crayola_absolute_zero': '#0048ba',
			\ 'crayola_winter_sky': '#ff007c',
			\ 'crayola_frostbite': '#e936a7',
			\ }, 'keep')

" Fluorescent crayons
call extend(v:colornames, {
			\ 'crayola_radical_red': '#ff355e',
			\ 'crayola_wild_watermelon': '#fd5b78',
			\ 'crayola_outrageous_orange': '#ff6037',
			\ 'crayola_atomic_tangerine': '#ff9966',
			\ 'crayola_neon_carrot': '#ff9933',
			\ 'crayola_sunglow': '#ffcc33',
			\ 'crayola_laser_lemon': '#ffff66',
			\ 'crayola_unmellow_yellow': '#ffff66',
			\ 'crayola_electric_lime': '#ccff00',
			\ 'crayola_screamin_green': '#66ff66',
			\ 'crayola_magic_mint': '#aaf0d1',
			\ 'crayola_blizzard_blue': '#50bfe6',
			\ 'crayola_shocking_pink': '#ff6eff',
			\ 'crayola_razzle_dazzle rose': '#ee34d2',
			\ 'crayola_hot_magenta': '#ff00cc',
			\ 'crayola_purple_pizzazz': '#ff00cc',
			\ }, 'keep')
