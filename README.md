## Unity Shader GetIn

This is a personal exercise and implementation of "getting started with Unity Shader". Some of the content may be slightly different from that in the book. The implementation platform is Unity 2018.4.2f1 (64-bit).



## Examples
### 漫反射

<img style="width: 30%; padding-right: 1%" src="Examples/1_1.png">
<img style="width: 30%; padding-right: 1%" src="Examples/1_2.png">
<img style="width: 30%; padding-right: 1%" src="Examples/1_3.png">
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%">逐顶点反射</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">逐像素反射</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">半兰伯特反射</div>

### 高光反射

<img style="width: 30%; padding-right: 1%" src="Examples/2_1.png">
<img style="width: 30%; padding-right: 1%" src="Examples/2_2.png">
<img style="width: 30%; padding-right: 1%" src="Examples/2_3.png">
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%">逐顶点高光反射（亮斑不连续）
</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">逐像素高光反射（完整phong模型）
</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">BlinnPhong(具有更亮的视觉效果)
</div>

### 法向纹理贴图

<img style="width: 30%; padding-right: 1%" src="Examples/3_1.png">
<img style="width: 30%; padding-right: 1%" src="Examples/3_2.png">
<img style="width: 30%; padding-right: 1%" src="Examples/3_3.png">
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%">Bump Scale = -1
</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">Bump Scale = 0
</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">Bump Scale = 1
</div>

### 渐进纹理控制光照效果

<img style="width: 30%; padding-right: 1%" src="Examples/4_1.png">
<img style="width: 30%; padding-right: 1%" src="Examples/4_2.png">
<img style="width: 30%; padding-right: 1%" src="Examples/4_3.png">
<img style="width: 30%; padding-right: 1%" src="Examples/4_1_1.png">
<img style="width: 30%; padding-right: 1%" src="Examples/4_2_1.png">
<img style="width: 30%; padding-right: 1%" src="Examples/4_3_1.png">

### 增加遮罩的高光反射

<img style="width: 47%; padding-right: 1%" src="Examples/5_1.png">
<img style="width: 47%; padding-right: 1%" src="Examples/5_2.png">
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%">漫反射+未遮罩的高光反射
</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">漫反射+遮罩的高光反射
</div>

### AlphaTest的单面和双面透明效果

<img style="width: 90%;" src="Examples/6_1.png">

### AlphaBlend的单面和双面透明效果

<img style="width: 90%;" src="Examples/7_1.png">

### 两个Pass的妙用

<img style="width: 47%; padding-right: 1%" src="Examples/8_1.png">
<img style="width: 47%; padding-right: 1%" src="Examples/8_2.png">
<div style="display: inline-block; text-align: center;">模型本身具有复杂的遮挡关系，则因排序错误产生错误的透明效果。使用两个Pass可以解决这个问题其中第二个Pass与原始blend相同，而第一个Pass仅仅将模型深度值写入深度缓冲，而不输出颜色
</div>

### 前向渲染-光照衰减

<img style="width: 30%; padding-right: 1%" src="Examples/9_1.png">
<img style="width: 30%; padding-right: 1%" src="Examples/9_2.png">
<img style="width: 30%; padding-right: 1%" src="Examples/9_3.png">
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%">Base + Additional Pass</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">LightMode : Auto</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">LightMode : NotImportant</div>

### 前向渲染-阴影

<img style="width: 22%; padding-right: 1%" src="Examples/10_1.png">
<img style="width: 22%; padding-right: 1%" src="Examples/10_2.png">
<img style="width: 22%; padding-right: 1%" src="Examples/10_3.png">
<img style="width: 22%; padding-right: 1%" src="Examples/10_4.png">
<div style="display: inline-block; text-align: center; width: 22%; padding-right: 1%">No FallBack</div>
<div style="display: inline-block; text-align: center; width: 22%; padding-right: 1%;">Only Fallback</div>
<div style="display: inline-block; text-align: center; width: 22%; padding-right: 1%;">Fall +(*shadow)</div>
<div style="display: inline-block; text-align: center; width: 22%; padding-right: 1%;">UNITY_LIGHT_ATTENUATION实现</div>

### 透明效果+阴影效果的叠加

<img style="width: 30%; padding-right: 1%" src="Examples/11_1.png">
<img style="width: 30%; padding-right: 1%" src="Examples/11_2.png">
<img style="width: 30%; padding-right: 1%" src="Examples/11_3.png">
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%">AlphaTest, Shadow正常</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">AlphaBlend,没有shadow</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">AlphaBlend+强制Fallback设置为Vertexlit</div>

### cubemap的创作

<img style="width: 30%; padding-right: 1%" src="Examples/12_1.png">
<img style="width: 60%; padding-right: 1%" src="Examples/12_2.png">

### 反射与折射的实现

<img style="width: 30%; padding-right: 1%" src="Examples/13_1.png">
<img style="width: 30%; padding-right: 1%" src="Examples/13_2.png">
<img style="width: 30%; padding-right: 1%" src="Examples/13_3.png">
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%">反射</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">折射</div>
<div style="display: inline-block; text-align: center; width: 30%; padding-right: 1%;">菲涅尔反射</div>

### 镜面反射

<img style="width: 95%; " src="Examples/14_1.png">

### 折射与反射的叠加效果

<img style="width: 47%; padding-right: 1%" src="Examples/15_1.png">
<img style="width: 47%; padding-right: 1%" src="Examples/15_2.png">
<div style="display: inline-block; text-align: center;">使用rendertoCubemap的先后顺序会造成不同效果，观察可知，前者的纹理较为透亮，而后者有些混沌
</div>

### 程序纹理

<img style="width: 30%; padding-right: 1%" src="Examples/16_1.png">
<img style="width: 30%; padding-right: 1%" src="Examples/16_2.png">
<img style="width: 30%; padding-right: 1%" src="Examples/16_3.png">
<div style="display: inline-block; text-align: center;">可通过参数控制圆形纹理的亮度，大小，颜色和模糊程度</div>

### 纹理动画

<img style="width: 43%; padding-right: 1%" src="Examples/17_1.gif">
<img style="width: 51%; padding-right: 1%" src="Examples/17_2.gif">

### 屏幕后处理之调整屏幕亮度，颜色饱和度和对比度

<img style="width: 47%; padding-right: 1%" src="Examples/18_1.png">
<img style="width: 47%; padding-right: 1%" src="Examples/18_2.png">

### 屏幕后处理之Sobel算子做边缘检测

<img style="width: 47%; padding-right: 1%" src="Examples/19_1.png">
<img style="width: 47%; padding-right: 1%" src="Examples/19_2.png">
<div style="display: inline-block; text-align: center;">EdgesOnly在原图和纯色之前插值得到最终像素值</div>

### 屏幕后处理之高斯模糊

<img style="width: 30%; padding-right: 1%" src="Examples/20_1.png">
<img style="width: 30%; padding-right: 1%" src="Examples/20_2.png">
<img style="width: 30%; padding-right: 1%" src="Examples/20_3.png">
<div style="display: inline-block; text-align: center;">其中最右侧为下采样尺度太大时造成的问题：像素化</div>

### 屏幕后处理之Bloom效果

<img style="width: 47%; padding-right: 1%" src="Examples/21_1.png">
<img style="width: 47%; padding-right: 1%" src="Examples/21_2.png">
<div style="display: inline-block; text-align: center;">在高斯模糊的基础上完成</div>

### 运用累计缓存和深度纹理分别实现运动模糊

<img style="width: 47%; padding-right: 1%" src="Examples/22_1.png">
<img style="width: 47%; padding-right: 1%" src="Examples/22_2.png">
<img style="width: 47%; padding-right: 1%" src="Examples/22_3.gif">
<img style="width: 47%; padding-right: 1%" src="Examples/23_1.gif">
<div style="display: inline-block; text-align: center; width: 47%; padding-right: 1%">累计缓存实现</div>
<div style="display: inline-block; text-align: center; width: 47%; padding-right: 1%">深度纹理实现</div>

### 基于深度纹理，使用Roberts算子的边缘检测

<img style="width: 47%; padding-right: 1%" src="Examples/24_1.png">
<img style="width: 47%; padding-right: 1%" src="Examples/24_2.png">

### 非真实干渲染

<img style="width: 47%; padding-right: 1%" src="Examples/25_1.png">
<img style="width: 47%; padding-right: 1%" src="Examples/25_2.png">

### 素描渲染

<img style="width: 95%; padding-right: 1%" src="Examples/26_1.png">

### 消融效果

<img style="width: 95%; padding-right: 1%" src="Examples/27_2.gif">

### 水面渲染

<img style="width: 95%; padding-right: 1%" src="Examples/28_1.gif">

### 基于深度纹理+噪声实现动态烟雾

<img style="width: 95%; padding-right: 1%" src="Examples/29_1.gif">







































