% 方法二：维纳滤波

%采用平均值法转化为灰度图像,且数据类型为double
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

% 接下来实现维纳滤波

%------------------------------维纳滤波原理-------------------------------%
% 定义式：G(f)=1/H(f)[|H(f)|^2/( |H(f)|^2+N(f)/S(f) )]
% 此为维纳滤波器传递函数，其中H(f)为退化函数频谱S(f)是输入信号功率谱
%                        N(f)是噪声功率谱

Noise = BlurandNoise - Blur;
NoiseF = abs( fft2(Noise) ).^2;      %噪声功率谱
IF = abs( fft2(Grayimage) ).^2;      %原图功率谱
HFT = fft2(PSF,row,col);      %限定HFT传递函数长宽与原图一致，否则会报错
HF = abs(HFT).^2;
GFT = fft2(BlurandNoise);      %退化加噪频谱
Reimage = ifft2( GFT.*( HF./(HF+NoiseF./IF) )./HFT  );      %维纳滤波实现图像还原

% 滤波效果展示
figure(2);
subplot(121), imshow(BlurandNoise), title('加噪退化图像');
subplot(122), imshow(Reimage), title('还原图像2:维纳滤波');

% 维纳滤波的效果与图像的噪信比大小直接相关
% 若无噪声，此时维纳滤波相当于逆滤波，恢复运动模糊效果是极好的
% 因维纳滤波为线性滤波，对高斯噪声滤波效果较好，当噪信比较低时还原效果很好
% 而当噪信比增大，维纳滤波的效果也会下降甚至不可用