% 方法一：直接逆滤波

% 以下为图像退化加噪部分，每段代码均会用到
% 采用平均值法转化为灰度图像,且数据类型为double
Initialimage = im2double( imread('Penguins.jpg') );
[row, col, color] = size(Initialimage);
Grayimage = zeros(row, col);
for i = 1:row
    for j = 1:col
        summ = 0;
        for k = 1:color
            summ = summ + Initialimage(i,j,k)/3;
        end
        Grayimage(i,j) = summ;
    end
end

% 图像退化加噪
PSF = fspecial('motion',20,10);      %定义滤波算子，类型为运动模糊，参数随便定义的
Blur = imfilter(Grayimage,PSF,'conv','circular');      %图像滤波实现退化，通过卷积完成
BlurandNoise = imnoise(Blur,'gaussian',0,0.04);      %添加高斯噪声
subplot(221), imshow(Initialimage);
title('原图像');
subplot(222), imshow(Grayimage);
title('灰度图像');
subplot(223), imshow(Blur);
title('退化图像');
subplot(224), imshow(BlurandNoise);
title('加噪退化图');

%---------------------------接下来实现直接逆滤波-----------------------%
Noise = BlurandNoise - Blur;
NoiseFT = fft2(Noise);
IFT = fft2(Grayimage);
HFT = fft2(PSF,row,col);      %限定HFT传递函数长宽与原图一致，否则会报错
Reimage = ifft2(IFT + NoiseFT./HFT);      %逆滤波实现图像还原

% 滤波效果展示
figure(2);
subplot(121), imshow(BlurandNoise), title('加噪退化图像');
subplot(122), imshow(Reimage), title('还原图像1:逆滤波');

% 由结果可知，加上噪声后逆滤波几乎不可用，原因在于当退化函数H(u,v)趋近于0时，N(u,v)/H(u,v)项
% 会覆盖掉F(u,v),噪声被急剧放大,导致逆滤波得到的图像与原图像严重不符