import cv2
import numpy as np
import os
os.environ['KMP_DUPLICATE_LIB_OK']='TRUE'

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.onnx as onnx
import torchvision.models as models
import segmentation_models_pytorch as smp
import matplotlib.pyplot as plt
import albumentations as albu

RESIZE_SIZE = 512

import sys
args = sys.argv

plt.gray()

# テンソル化
def to_tensor(x, **kwargs):
    return x.transpose(2, 0, 1).astype('float32')

# 前処理
def get_preprocessing(preprocessing_fn):
    _transform = [
            albu.Lambda(image=preprocessing_fn),
            albu.Lambda(image=to_tensor, mask=to_tensor),
        ]
    return albu.Compose(_transform)


#モデル(path)
ENCODER = 'resnet101'
ENCODER_WEIGHTS = 'imagenet'
CLASSES = ['passage']
ACTIVATION = 'sigmoid'  # could be None for logits or 'softmax2d' for multicalss segmentation
DEVICE = 'cuda:0'
DECODER = 'DeepLabV3Plus'
model = smp.DeepLabV3Plus(
    encoder_name=ENCODER,
    encoder_weights=ENCODER_WEIGHTS,
    classes=len(CLASSES),
# in_channels=1, # model input channels (1 for gray-scale images, 3 for RGB, etc.)
    activation=ACTIVATION,
)
model = model.to(DEVICE)
model_path = f'{DECODER}_{ENCODER}.pth'
model = torch.load(model_path)
preprocessing_fn = smp.encoders.get_preprocessing_fn(ENCODER, ENCODER_WEIGHTS)

#モデル(floor)
CLASSES_f = ['floor']
modelf = smp.DeepLabV3Plus(
    encoder_name=ENCODER,
    encoder_weights=ENCODER_WEIGHTS,
    classes=len(CLASSES_f),
# in_channels=1, # model input channels (1 for gray-scale images, 3 for RGB, etc.)
    activation=ACTIVATION,
)
modelf = model.to(DEVICE)
modelf_path = 'floor.pth'
modelf = torch.load(modelf_path)
preprocessing_fn = smp.encoders.get_preprocessing_fn(ENCODER, ENCODER_WEIGHTS)

def det_path(image_src):

    # 前処理
    image = preprocessing_fn(image_src)
    image = image.transpose(2, 0, 1).astype('float32')

    # モデルで推論
    image = torch.from_numpy(image).to(DEVICE).unsqueeze(0)
    predict = model(image)
    predict = predict.detach().cpu().numpy()[0].reshape((512,512))

    # 0.5以上を1とする
    predict_img = np.zeros([512,512]).astype(np.int8)
    predict_img = np.where(predict>0.5, 1 , predict_img)

    th  = cv2.bitwise_not(predict_img)

    #モルフォロジー変換(Opening)
    kernel = np.ones((5,5),np.uint8)
    th = th.astype('uint8')
    th = cv2.morphologyEx(th, cv2.MORPH_OPEN, kernel)

    #モルフォロジー変換(erosion)
    kernel2 = np.ones((3,3),np.uint8)
    th = cv2.erode(th,kernel2,iterations = 1)

    return th
    #plt.imsave(args[1]+'p.png',th)

def det_floor(image_src):

    # 前処理
    image = preprocessing_fn(image_src)
    image = image.transpose(2, 0, 1).astype('float32')

    # モデルで推論
    image = torch.from_numpy(image).to(DEVICE).unsqueeze(0)
    predict = modelf(image)
    predict = predict.detach().cpu().numpy()[0].reshape((512,512))

    # 0.5以上を1とする
    predict_img = np.zeros([512,512]).astype(np.int8)
    predict_img = np.where(predict>0.5, 1 , predict_img)

    th  = cv2.bitwise_not(predict_img)

    #モルフォロジー変換(Opening)
    kernel = np.ones((5,5),np.uint8)
    th = th.astype('uint8')
    th = cv2.morphologyEx(th, cv2.MORPH_OPEN, kernel)

    #plt.imsave(args[1]+'p.png',th)
    return th
    


def mask_compositing(img):
    mask = cv2.imread("DetectImages/"+ args[1] + "th.png")
    imgp = cv2.bitwise_and(img, mask)
    im_mask, g_, r_ = cv2.split(cv2.imread("DetectImages/"+ args[1] + "th.png"))
    imgp[im_mask==0] = [255,255,255]

    return imgp

 

def main():
    # 画像読み込み
    image_ori = cv2.imread('images/'+ args[1] +".png")
    image_ori = cv2.cvtColor(image_ori, cv2.COLOR_BGR2RGB)
    #image_ori = cv2.rotate(image_ori, cv2.ROTATE_180)
    #plt.imsave('images/'+args[1]+'.png',image_ori)
    image_src = cv2.resize(image_ori , (512, 512))

    th = det_path(image_src)
    plt.imsave('DetectImages/'+args[1]+'p512.png',th)
    th_resize = cv2.imread('DetectImages/'+args[1]+'p512.png')
    #通路領域のリサイズ
    th_resize = cv2.resize(th_resize, (RESIZE_SIZE, RESIZE_SIZE))
    plt.imsave('DetectImages/'+args[1]+'p.png',th_resize)

    thf = det_floor(image_src)

    #抽出した地図領域のリサイズ
    imgh, imgw, imgc = image_ori.shape
    thf = cv2.resize(thf , (int(imgw), int(imgh)))
    plt.imsave('DetectImages/'+args[1]+'th.png',thf)

    floor = mask_compositing(image_ori)
    floor = cv2.cvtColor(floor, cv2.COLOR_RGB2RGBA)
    floor[:, :, 3] = np.where(np.all(floor == 255, axis=-1), 0, 255)
    #保存
    plt.imsave('DetectImages/'+args[1]+'f.png',floor)



if __name__ == "__main__":
    main()
