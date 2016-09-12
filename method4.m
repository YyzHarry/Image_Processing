% 方法四：Lucy-Richardson迭代算法

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
m = 0;
V = 0.04;
BlurandNoise = imnoise(Blur,'gaussian',m,V);      %添加高斯噪声
subplot(221), imshow(Initialimage);
title('原图像');
subplot(222), imshow(Grayimage);
title('灰度图像');
subplot(223), imshow(Blur);
title('退化图像');
subplot(224), imshow(BlurandNoise);
title('加噪退化图');

% 接下来实现Lucy-Richardson迭代算法滤波

%-----------------------Lucy-Richardson迭代算法原理------------------------%
% Lucy-Richardson迭代算法通过每次完成相关和卷积运算
% 通过限制迭代次数来得到最佳复原解
% 其定义式为
%            f(k+1) = f(k)*[cov( (g / conv(f(k),h), h)]
% 其中k为迭代次数
%

% 此处写了一个Lucy_Richardson函数用于实现Lucy_Richardson迭代滤波
% 直接调用函数生成还原后的图像，其中最后一个参数为迭代次数

Reimage1 = Lucy_Richardson(BlurandNoise, 20, 10, 5);
Reimage2 = Lucy_Richardson(BlurandNoise, 20, 10, 15);
Reimage3 = Lucy_Richardson(BlurandNoise, 20, 10, 50);
Reimage4 = Lucy_Richardson(BlurandNoise, 20, 10, 100);

% 滤波效果展示
figure(2);
subplot(121), imshow(BlurandNoise), title('加噪退化图像');
subplot(122), imshow(Reimage2), title('还原图像4:Lucy-Richardson迭代滤波');

figure(3);
subplot(221), imshow(Reimage1), title('迭代5次');
subplot(222), imshow(Reimage2), title('迭代15次');
subplot(223), imshow(Reimage3), title('迭代50次');
subplot(224), imshow(Reimage4), title('迭代100次');

% 从结果来看，当迭代次数较低时，滤波效果一般，和维纳滤波差不多
% 当迭代次数在15次左右滤波效果较好
% 而迭代次数继续增加，到50/100次时，不仅运算时间较长(100s左右)，得到的图像
% 虽清晰度有所提高，但雪花点较多，效果也不太好(将在实验报告中讨论)