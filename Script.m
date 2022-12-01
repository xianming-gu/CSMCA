clear all
close all
clc

addpath(genpath('SparseCode'));
addpath(genpath('Util'));

load('dictionary/Dc_8_8_32.mat')
load('dictionary/Dt_8_8_32.mat')

fileFolder=fullfile('./MyDatasets/CT-MRI/test/CT');
dirOutput=dir(fullfile(fileFolder,'*.png')); % Դͼ���Լ��ں�ͼ��ĺ�׺��
fileNames = {dirOutput.name};
ir_dir ='./MyDatasets/CT-MRI/test/CT'; % CTͼ�������ļ���
vi_dir = './MyDatasets/CT-MRI/test/MRI'; % MRIͼ�������ļ���

for numii=1:24
display(numii);
path2 = fullfile(ir_dir, fileNames{numii});
path1 = fullfile(vi_dir, fileNames{numii}); 
fused_path = ['result/CT/',fileNames{numii}];
img1  = imread(path1); %MRI
img2  = imread(path2); %CT/PET/SPECT

% figure,imshow(img1);
% figure,imshow(img2);

imgf=CSMCA_Fusion(img1,img2,Dc,Dt);

% figure;imshow(imgf);
imwrite(imgf,fused_path);

end


