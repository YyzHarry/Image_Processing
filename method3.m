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

%----------------------------约束最小二乘法原理----------------------------%
% 约束最小二乘方滤波的约束条件的关键是各点二阶导数的平方和最小
% 最佳复原解为 f(x,y)=(H'H + γ*C'C)^(-1)*H'g,在此基础上得到其频域表达式为
%               F = [ H'/( ||H||^2+γ||C||^2) ] * G
% 其中 [C(m,n)] = [0 1 0; 1 -4 1; 0 1 0],需扩散成一频谱面函数
% γ是一个加以调整的参量，需通过迭代运算至满足
%               ||g - Hf||^2 = ||n||^2
% 即达到最优解

C = [0 1 0; 1 -4 1; 0 1 0];
CFT = psf2otf(C,[row,col]);      %将C矩阵扩散转换为频谱面函数
CF = abs(CFT).^2;
HFT = fft2(PSF,row,col);
HF = abs(HFT).^2;
GFT = fft2(BlurandNoise);      %退化加噪频谱

%-----------------------以下通过迭代算法得到gamma使结果达到最优--------------------%
rate = 0.001;
a = 1e4;
gamma = 2.87;

% ||n||^2较好的估计是 MN[V+m^2],其中M和N代表图像的维数,V和m^2分别代表噪声方差和噪声均值平方
Noise_info = row * col *(V + m^2);

IsContinue = true;
cnt = 0;      %迭代次数
while (IsContinue && cnt<100)   % 限制迭代次数小于100次
    Fun = GFT.*( conj(HFT)./(HF + gamma*CF) );
    
    R = BlurandNoise - HFT.*( ifft2(Fun) );
    % 此时应求r的2-范数
    r = abs(R).^2;
    s = sum(r(:));
    
    Reimage = ifft2(Fun);      %约束最小二乘法滤波实现图像还原
    
    if (s > Noise_info + a)
        gamma = gamma - rate;
    elseif (s < Noise_info - a)
        gamma = gamma + rate;
    else
        IsContinue = false;
    end
    cnt = cnt + 1;
end

% 滤波效果展示
figure(2);
subplot(121), imshow(BlurandNoise), title('加噪退化图像');
subplot(122), imshow(Reimage), title('还原图像3:约束最小二乘法滤波');

% 由结果可知，约束最小二乘方滤波对高噪声和中等噪声产生结果要好于维纳滤波
% 对于低噪声两种滤波产生结果基本相等（实验报告中会附图）
% 而对于调整参量过程，由于求矩阵范数得到的值与噪声能量差值较大，不知是否没弄清其原理式
% 导致迭代过程仅往一个方向进行，而参数初值只能先手动调整确定范围，故效果没有很理想
% 而按照matlab自带函数deconvreg进行滤波效果则更差，实验报告中会进行分析