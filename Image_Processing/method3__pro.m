% 对方法三的补充/另一种写法 --- 得到拉格朗日乘子
% 此方法中调用的f_deconvreg函数是按照matlab自带的deconvreg函数为模板写的
% 但是效果没有之前自己写的method3中的效果好
% 方法三：约束最小二乘法滤波

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

% 接下来实现约束最小二乘法滤波
% 与前一段代码不同,这里写了f_deconvreg函数用于迭代产生拉格朗日乘子
% 而不是通过尝试得到gamma值大概的范围再进行迭代

% 噪声功率谱
Noise_info = row * col *(V + m^2);

% 迭代产生最优解
[Reimage, lagra] = f_deconvreg(BlurandNoise, PSF, Noise_info);

% 滤波效果展示
figure(2);
subplot(121), imshow(BlurandNoise), title('加噪退化图像');
subplot(122), imshow(Reimage), title('还原图像3.pro:约束最小二乘法滤波2');
