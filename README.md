## Unity Shader GetIn

This is a personal exercise and implementation of "getting started with Unity Shader". Some of the content may be slightly different from that in the book. The implementation platform is Unity 2018.4.2f1 (64-bit).



## Examples
### 漫反射



| ![](Examples/1_1.png)  | ![](Examples/1_2.png) | ![](Examples/1_3.png) |
|:----------:|:---:|:--------:|
| 逐顶点反射  | 逐像素反射 | 半兰伯特反射    | 




### 高光反射

| ![](Examples/2_1.png)  | ![](Examples/2_2.png) | ![](Examples/2_3.png) |
|:----------:|:---:|:--------:|
| 逐顶点高光反射（亮斑不连续）  | 逐像素高光反射（完整phong模型） | BlinnPhong(具有更亮的视觉效果)| 

### 法向纹理贴图

| ![](Examples/3_1.png)  | ![](Examples/3_2.png) | ![](Examples/3_3.png) |
|:----------:|:---:|:--------:|
| Bump Scale = -1  | Bump Scale = 0 | Bump Scale = 1| 

### 渐进纹理控制光照效果

| ![](Examples/4_1.png)  | ![](Examples/4_2.png) | ![](Examples/4_3.png) |
|:----------:|:---:|:--------:|
| ![](Examples/4_1_1.png)  | ![](Examples/4_2_1.png) | ![](Examples/4_3_1.png) |

### 增加遮罩的高光反射

| ![](Examples/5_1.png)  | ![](Examples/5_2.png) |
|:----------:|:---:|
| 漫反射+未遮罩的高光反射 | 漫反射+遮罩的高光反射 |

### AlphaTest的单面和双面透明效果

| ![](Examples/6_1.png)  |
|:----------:|


### AlphaBlend的单面和双面透明效果

| ![](Examples/7_1.png)  |
|:----------:|
### 两个Pass的妙用

| ![](Examples/8_1.png)  | ![](Examples/8_2.png) |
|:-------:|:---:|
模型本身具有复杂的遮挡关系，则因排序错误产生错误的透明效果。使用两个Pass可以解决这个问题其中第二个Pass与原始blend相同，而第一个Pass仅仅将模型深度值写入深度缓冲，而不输出颜色


### 前向渲染-光照衰减

| ![](Examples/9_1.png)  | ![](Examples/9_2.png) | ![](Examples/9_3.png) |
|:----------:|:---:|:--------:|
| Base + Additional Pass  | LightMode : Auto | LightMode : NotImportant| 

### 前向渲染-阴影


| ![](Examples/10_1.png)  | ![](Examples/10_2.png) | ![](Examples/10_3.png) |![](Examples/10_4.png)|
|:-------:|:---:|:--------:|:-----:|
| No FallBack  | Only Fallback | Fall +(*shadow) |UNITY_LIGHT_ATTENUATION实现| 

### 透明效果+阴影效果的叠加

| ![](Examples/11_1.png)  | ![](Examples/11_2.png) | ![](Examples/11_3.png) |
|:----------:|:---:|:--------:|
| AlphaTest, Shadow正常  | AlphaBlend,没有shadow |AlphaBlend+强制Fallback设置为Vertexlit| 

### cubemap的创作

| ![](Examples/12_1.png)  | ![](Examples/12_2.png) | 
|:----------:|:---:|

### 反射与折射的实现

| ![](Examples/13_1.png)  | ![](Examples/13_2.png) | ![](Examples/13_3.png) |
|:----------:|:---:|:--------:|
| 反射|折射|菲涅尔反射| 

### 镜面反射

|![](Examples/14_1.png)|
|:--------:|

### 折射与反射的叠加效果

| ![](Examples/15_1.png)  | ![](Examples/15_2.png) |
|:---:|:--------:|
使用rendertoCubemap的先后顺序会造成不同效果，观察可知，前者的纹理较为透亮，而后者有些混沌

### 程序纹理

| ![](Examples/16_1.png)  | ![](Examples/16_2.png) | ![](Examples/16_3.png) |
|:----------:|:---:|:--------:|
可通过参数控制圆形纹理的亮度，大小，颜色和模糊程度

### 纹理动画

| ![](Examples/17_1.gif)  | ![](Examples/17_2.gif) |
|:---:|:--------:|

### 屏幕后处理之调整屏幕亮度，颜色饱和度和对比度

| ![](Examples/18_1.png)  | ![](Examples/18_2.png) |
|:---:|:--------:|

### 屏幕后处理之Sobel算子做边缘检测

| ![](Examples/19_1.png)  | ![](Examples/19_2.png) |
|:---:|:--------:|
EdgesOnly在原图和纯色之前插值得到最终像素值

### 屏幕后处理之高斯模糊

| ![](Examples/20_1.png)  | ![](Examples/20_2.png) | ![](Examples/20_3.png) |
|:----------:|:---:|:--------:|
其中最右侧为下采样尺度太大时造成的问题：像素化

### 屏幕后处理之Bloom效果

| ![](Examples/21_1.png)  | ![](Examples/21_2.png) |
|:---:|:--------:|
在高斯模糊的基础上完成

### 运用累计缓存和深度纹理分别实现运动模糊

| ![](Examples/22_1.png)  | ![](Examples/22_2.png) |
|:---:|:--------:|

| ![](Examples/22_3.gif)  | ![](Examples/23_1.gif) |
|:---:|:--------:|
|累计缓存实现|深度纹理实现|

### 基于深度纹理，使用Roberts算子的边缘检测

| ![](Examples/24_1.png)  | ![](Examples/24_2.png) |
|:---:|:--------:|
### 非真实干渲染

| ![](Examples/25_1.png)  | ![](Examples/25_2.png) |
|:---:|:--------:|

### 素描渲染
| ![](Examples/26_1.png)  |
|:--------:|

### 消融效果

| ![](Examples/27_2.gif)  |
|:--------:|

### 水面渲染

| ![](Examples/28_1.gif)  |
|:--------:|

### 基于深度纹理+噪声实现动态烟雾

| ![](Examples/29_1.gif)  |
|:--------:|







































