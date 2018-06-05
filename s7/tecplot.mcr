#!MC 1400
$!OPENLAYOUT = "/people/song884/dust/fy2018/s7_1a/scripts/s7_satu_slice_with_layer.lay"
ALTDATALOADINSTRUCTIONS = '"/pic/scratch/song884/fy2018/s7_4b/base/tec_data/2026.46.plt" "/people/song884/dust/fy2018/s7_1a/scripts/layer.dat"'
$!EXPORTSETUP ExportFormat = JPEG
$!PRINTSETUP PALETTE = COLOR
$!EXPORTSETUP PRINTRENDERTYPE = VECTOR
$!EXPORTSETUP EXPORTFNAME = "/people/song884/dust/fy2018/s7_4b/figures/base/s7_satu_slice_with_layer_2026.46.jpg"
$!EXPORTSETUP QUALITY = 100
$!EXPORTSETUP IMAGEWIDTH = 1000
$!EXPORT
EXPORTREGION = CURRENTFRAME
$!QUIT