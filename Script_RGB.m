clear all
close all
clc

addpath(genpath('SparseCode'));
addpath(genpath('Util'));

load('dictionary/Dc_8_8_32.mat')
load('dictionary/Dt_8_8_32.mat')

% img1=imread('sourceimages/source1.tif');
% img2=imread('sourceimages/source2.tif');

fileFolder=fullfile('./MyDatasets/SPECT-MRI/test/SPECT');
dirOutput=dir(fullfile(fileFolder,'*.png')); % 源图像以及融合图像的后缀名
fileNames = {dirOutput.name};
ir_dir ='./MyDatasets/SPECT-MRI/test/SPECT'; % CT图像所在文件夹
vi_dir = './MyDatasets/SPECT-MRI/test/MRI'; % MRI图像所在文件夹

for numii=1:24
    tic
display(numii);
path2 = fullfile(ir_dir, fileNames{numii});
path1 = fullfile(vi_dir, fileNames{numii}); 
fused_path = ['result/SPECT/',fileNames{numii}];
img1  = imread(path1); %MRI
img2  = imread(path2); %CT/PET/SPECT

img1 = double(img1)/255;
img2 = double(img2)/255;

img2_YUV=ConvertRGBtoYUV(img2);
img1_gray=img1;
img2_gray=img2_YUV(:,:,1);
[h,w] = size(img1);
tic 
F = CSMCA_Fusion(img1_gray, img2_gray,Dc,Dt);
imgf_YUV1=zeros(h,w,3);
imgf_YUV1(:,:,1)=F;
imgf_YUV1(:,:,2)=img2_YUV(:,:,2);
imgf_YUV1(:,:,3)=img2_YUV(:,:,3);
imgf_RGB=ConvertYUVtoRGB(imgf_YUV1);
result = uint8(imgf_RGB*255);

% imgf=CSMCA_Fusion(img1,img2,Dc,Dt);

% figure;imshow(imgf);
imwrite(result,fused_path);
toc

end

