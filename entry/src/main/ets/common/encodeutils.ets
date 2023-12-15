import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import fs from '@ohos.file.fs';
import image from '@ohos.multimedia.image';
import Logger from './logutils';


export async function save(Image: PixelMap) {
  // Get PixelMap
  const pixelMap = Image
  // Packing image.
  const imagePackerApi = image.createImagePacker();
  const packOptions: image.PackingOption = {
    format: 'image/jpeg',
    quality: 100
  }
  const imageData = await imagePackerApi.packing(pixelMap, packOptions);
  console.info(`imageData's length is ${imageData.byteLength}`)
  // Get album's path.
  const context = getContext(this);
  const media = mediaLibrary.getMediaLibrary(context);
  const publicPath = await media.getPublicDirectory(mediaLibrary.DirectoryType.DIR_IMAGE);
  const currentTime = new Date().getTime();
  // Create image asset.
  const imageAssetInfo = await media.createAsset(
    mediaLibrary.MediaType.IMAGE,
    `image_${currentTime}.jpg`,
    publicPath
  );
  const imageFd = await imageAssetInfo.open('rw');
  await fs.write(imageFd, imageData);
  // Image resource release.
  await imageAssetInfo.close(imageFd);
  imagePackerApi.release();
  await media.release();
}