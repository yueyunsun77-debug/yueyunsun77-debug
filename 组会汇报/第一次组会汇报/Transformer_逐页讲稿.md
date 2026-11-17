# Transformer 组会汇报｜逐页讲稿

主讲第 1—16 页，约 16 分钟；第 17—19 页供讨论与引用。

论文：Attention Is All You Need，NIPS 2017。
正式 PDF：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

所有实验数字统一采用会议版 PDF。

## 01｜封面

今天汇报 Transformer 的原始论文。我的汇报围绕三个问题展开：作者为什么要改变已有序列模型，注意力如何完成信息交互，以及实验是否支持这种设计。内容仅限这篇论文。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 02｜研究问题

循环模型在序列位置之间具有计算依赖，训练单个序列时难以完全并行。自注意力则允许一个位置直接访问其他可见位置的信息，缩短远距离信息交互的路径。右图只表示信息流，不是论文的真实注意力权重。减少顺序操作也不意味着任何长度下计算都更少。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 03｜核心思路

作者没有发明注意力本身。贡献在于提出一套不依赖循环和卷积来建立序列位置联系的架构。三个最值得掌握的概念是自注意力、多头注意力与位置编码。除此之外，模型还需要前馈网络、残差连接和归一化，不能把标题理解为整个网络只有注意力。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 04｜整体架构

先从底部往上看。源句子转成向量并加入位置编码，经过六层编码器得到源序列表示。解码器接收右移后的目标序列；它先通过掩码自注意力处理目标前缀，再通过交叉注意力读取编码器输出。上方线性层和 Softmax 给出下一个词的分布。图中为了清晰省略了每个子层的残差和归一化，下一部分会补充。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 05｜自注意力公式

Q、K、V 不是三份独立原始数据，而是输入经不同线性映射得到的表示。用 Q 和 K 的点积得到匹配分数，除以根号 dk 避免维度增大导致分数幅值过大，再按行用 Softmax 得到权重，最后加权求和 V。这里的查找类比只是帮助理解，不能将权重直接当成严格的因果解释。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 06｜自注意力计算示例

这页是人为构造的单个查询示例。假设与三个位置的缩放后分数为一、二、零，Softmax 后大约为0.245、0.665、0.090，总和为一。用这些数分别乘三个 Value 向量再相加，即得到0.335、0.755。真实模型会并行计算所有查询，每个查询都有自己的权重分布。本例不表示真实语言关系，也不是论文实验结果。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 07｜多头注意力

单头只能在一个表示子空间中汇总信息。多头为每个头学习独立的QKV投影，分别计算后拼接，再做输出投影。base模型有八个头，每头键和值维度都是64，拼接回512维。不要说每个头都处理完整的512维，也不要事先指定某个头一定负责语法或某种关系。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 08｜位置编码

如果不加入位置信息，注意力本身不能从内容以外获得序列顺序。作者给每个位置生成与词向量同维的正余弦编码，并逐元素相加。图中的两条曲线仅用于说明不同频率，不是论文具体某个维度。原文也比较了可学习位置嵌入，效果接近，因此不能把正余弦形式说成唯一可行选择。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 09｜解码器注意力

左侧是下三角可见性矩阵，对角线可见是因为目标输入已经右移：该位置看到的是此前的已知词，不是待预测答案。不可见分数在Softmax之前被置为负无穷。右侧是交叉注意力，Query来自解码器，Key和Value来自编码器。训练时可用已知目标并行计算各位置，但实际推理仍要逐词生成。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 10｜前馈残差与归一化

这页补足整体架构中省略的组件。注意力在位置之间交换信息，前馈网络对每个位置独立进行两层线性变换，中间用ReLU。base的维度为512到2048再回到512。原论文采用Post-LN，即先子层、再残差相加、最后层归一化；不要把后来的Pre-LN结构混入原文介绍。示意图省略了Dropout。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 11｜并行性与复杂度

Table1比较的是不同类型的层。自注意力建立任意位置间联系的路径短，序列方向的顺序操作少。但标准注意力需要计算n乘n的关系，时间中有n平方乘d，显式注意力矩阵的空间随n平方增长。这里尚未把所有投影和前馈计算相加，因此不能把表中这一项当成完整Transformer每层的全部复杂度。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 12｜实验设置

主要实验在WMT2014英德和英法任务上完成，数据规模分别约450万和3600万句对。用BLEU评价翻译质量，还比较估算训练FLOPs。base训练约12小时，big约3.5天，硬件为八张P100。训练成本的跨论文比较是估算，不是完全统一环境下的严格速度测量。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 13｜主要实验结果

这里摘选Table2英译德结果，不代表表中全部方法。Transformer base是27.3，big是28.4，高于ConvS2S集成的26.36，差值2.04 BLEU。同时big的估算训练成本是2.3乘10的19次方，低于该集成方法。base成本更低。不能用这张表推出Transformer在所有任务上都更快或更好。英译法如需要补充，会议版big为41.0，与当前arXiv版本数值不同，整套幻灯片统一使用会议版。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 14｜模型变体实验

这张图使用Table3开发集结果，不能与前页Table2的测试集数字混用。base八头为25.8，单头24.9，三十二头25.4。改变头数时作者也相应调整键和值维度，保持总表示规模与计算量大致可比，因此不是仅增加一项而其他一切固定。这个实验说明多头有用，但头数并非越多越好。柱状图纵轴从24开始，已经明确标注，以免夸大差异。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 15｜局限与讨论

第一，标准全局注意力对长序列成本较高。第二，训练并行并不消除自回归推理的顺序性。第三，论文在具体实验设置下支持架构的有效性，不能推出任何数据集都优于其他方法。这些边界来自方法机制与实验范围，我将它们作为阅读后的分析，不将其都声称为作者逐字列出的缺点。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 16｜总结

我对这篇论文的理解可以归结为三点：作者针对序列计算的顺序依赖提出问题；通过多头注意力与位置编码构成Transformer；通过翻译实验和模型变体实验提供证据。核心是内容驱动的信息交互。以上是本次汇报，谢谢老师和同学。后面附有维度说明与常见问题，便于讨论。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 17｜附录维度

这页用于老师追问公式维度。单头Q、K、V为n乘64，Q乘K转置得到n乘n，乘V后得到n乘64。八头拼接后为n乘512，再乘输出投影。编码器—解码器注意力中目标长度和源长度可以不同，分数矩阵应为目标长度乘源长度。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 18｜附录问答

除以根号dk：在简化独立假设下点积方差随dk增大，缩放使Softmax梯度更稳定。多头：不同可学习投影允许从不同子空间汇总信息。位置编码：补充顺序，正余弦并非唯一形式。训练与推理：训练使用右移真实目标，掩码限制可见性；推理没有未来真实目标，只能基于已生成前缀继续。若追问注意力是否等于解释，应回答权重可以帮助观察信息分配，但不能直接等同因果解释。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 19｜参考文献

整份汇报使用会议版PDF作为统一数据来源。特别注意不同版本的英译法结果可能不同，本文幻灯片没有混用当前arXiv的41.8。重绘架构用于清晰呈现原文关系，玩具计算示例明确标为教学示例。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 使用说明

- PPT 为 16:9，全部页面采用白底，可编辑文本、图形与图表。
- 中文采用微软雅黑，英文采用 Arial，统一正体；如系统缺失字体，可替换为思源黑体。
- 建议先通读 1—16 页，再用附录检查公式维度。
- 源数据不是本地复现实验结果；教学示例已显式标注。