function Reimage = Lucy_Richardson(BlurandNoise, len, xita, num)
% Lucy_Richardson滤波器
% 输入参数: 
%         BlurandNoise:  输入的图像矩阵
%         len:   模糊旋转长度，模糊的像素个数
%         xita: 模糊旋转角
% ---------------len和xita为定义图像退化函数时运动模糊参数
%         num: 迭代次数
% 输出参数: 
%         Reimage: 重构滤波图像

BlurandNoise = medfilt2(abs(BlurandNoise));  % 在迭代前先中值滤波进行一定程度的降噪

Blurtmp = BlurandNoise; % 初始迭代目标函数为原模糊函数
% 点扩展函数PSF
PSF = fspecial('motion',len,xita);
% 转化PSF函数到期望的维数
OTF = psf2otf(PSF,size(BlurandNoise));

for i = 1 : num
    GFT = fft2(Blurtmp);    % 转化到频域
    Ftemp = OTF .* GFT;   % 频域相乘 = 时域卷积
    iFtemp = ifft2(Ftemp); % 傅里叶反变换，转换到时域
    % 模糊前 与 去模糊后的比值
    Ftemp2 = BlurandNoise ./(iFtemp + eps);  %此处若不加eps 则迭代次数增多时输出图像为全黑
    iFtemp2 = fft2(Ftemp2);   % 转化到频域
    Correlation = OTF .* iFtemp2; % 计算相关性向量
    iCorrelation = ifft2(Correlation);% 傅里叶反变换，转换到时域
    % 计算估计的去模糊图像矩阵
    Fini = iCorrelation .* Blurtmp;
    Blurtmp = Fini;
end

Reimage = abs(Blurtmp); % 重构滤波图像

end
