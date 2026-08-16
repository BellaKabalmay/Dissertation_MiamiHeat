var counties = ee.FeatureCollection('TIGER/2018/Counties');
var miamiDade = counties.filter(ee.Filter.eq('GEOID', '12086'));
Map.centerObject(miamiDade, 9);

function maskClouds(image) {
  var qa = image.select('QA_PIXEL');
  var cloud = qa.bitwiseAnd(1 << 3).eq(0);
  var shadow = qa.bitwiseAnd(1 << 4).eq(0);
  return image.updateMask(cloud).updateMask(shadow);
}

function addLstNdvi(image) {
  var lst = image.select('ST_B10')
    .multiply(0.00341802).add(149.0)
    .subtract(273.15)
    .rename('LST');
  var nir = image.select('SR_B5').multiply(0.0000275).add(-0.2);
  var red = image.select('SR_B4').multiply(0.0000275).add(-0.2);
  var ndvi = nir.subtract(red).divide(nir.add(red)).rename('NDVI');
  return image.addBands([lst, ndvi]);
}

var l8 = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2');
var l9 = ee.ImageCollection('LANDSAT/LC09/C02/T1_L2');
var collection = l8.merge(l9)
  .filterBounds(miamiDade)
  .filterDate('2022-06-01', '2022-09-01')
  .filter(ee.Filter.lt('CLOUD_COVER', 60))
  .map(maskClouds)
  .map(addLstNdvi);
print('Number of images used:', collection.size());

var lstMean = collection.select('LST').mean().clip(miamiDade);
var ndviMean = collection.select('NDVI').mean().clip(miamiDade);
Map.addLayer(lstMean, {min: 25, max: 45, palette: ['blue','yellow','red']}, 'LST Summer 2022');
Map.addLayer(ndviMean, {min: 0, max: 0.8, palette: ['white','green']}, 'NDVI Summer 2022');

Export.image.toDrive({
  image: lstMean,
  description: 'LST_Summer2022_MiamiDade',
  folder: 'GEE_Dissertation',
  fileNamePrefix: 'LST_Summer2022_MiamiDade',
  region: miamiDade.geometry(),
  scale: 30,
  crs: 'EPSG:26917',
  maxPixels: 1e13
});

Export.image.toDrive({
  image: ndviMean,
  description: 'NDVI_Summer2022_MiamiDade',
  folder: 'GEE_Dissertation',
  fileNamePrefix: 'NDVI_Summer2022_MiamiDade',
  region: miamiDade.geometry(),
  scale: 30,
  crs: 'EPSG:26917',
  maxPixels: 1e13
});
