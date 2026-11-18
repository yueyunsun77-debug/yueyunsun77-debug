# Transformer｜15页白底图解精修版

PPT文字与图形主要可编辑；两张实验图为依据论文数值生成的高清图。
全部页面白底；PPT字体指定为黑体SimHei。PDF使用本机兼容黑体渲染。

数值例子与各头的注意力分布均为教学构造，不能作为真实注意力分布或实验证据。
质量—成本图横轴为对数；变体结果来自开发集，不能与测试集直接混用。

论文：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 01｜封面

本次汇报Transformer的原始论文，围绕已有方法的计算限制、架构与注意力原理、创新如何实现，以及实验支持哪些收益展开。封面矩阵仅用作结构示意，不是论文实验结果。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 02｜目录

先讲研究背景与问题，再解释模型内部如何组织信息；随后比较已有方式与本文改动，最后讨论实验能支持哪些收益以及结论的边界。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 03｜已有方法的计算结构

循环网络沿位置递推隐藏状态，再利用注意力选择源句信息。局部卷积可并行处理位置，但较远位置的交互通常要经过多层。这里不是说旧方法不能利用远距离信息，而是指出其表示计算受到顺序依赖或局部传播路径的限制。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 04｜论文的研究问题

作者希望在保留翻译质量的同时，减少表示计算中的顺序依赖，让远位置间的信息交互更直接。图中的路径是机制示意，不是实测耗时。并行性、交互路径和表示能力共同构成后续架构的设计目标。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 05｜清晰理解整体架构

源输入经嵌入和位置编码进入六层编码器，得到源句表示Z。右移目标进入六层解码器，每层先做掩码自注意力，再用交叉注意力读取Z，最后经过前馈网络。Query来自解码器，Key与Value来自编码器。每个注意力或前馈子层的输出都与其输入做残差相加，再做LayerNorm，即原文的Post-LN。图中框内结构重复六次，嵌入与位置编码不重复。顶层线性映射与Softmax输出下一词分布。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 06｜用具体数值解释QKV

Q是查询，K参与匹配，V是实际汇总的内容，三者都可由输入经过不同的可学习线性投影得到。这个单查询示例的缩放后分数为一、二、零，Softmax权重约为0.245、0.665、0.090。分别乘三个Value向量(1,0)、(0,1)、(1,1)，相加得到约(0.335,0.755)。这些数值并非论文模型的真实注意力。一种一致的构造是dk=2，q=(1,0)，三个k分别取(√2,0)、(2√2,0)、(0,1)，缩放后正好得到上述分数。真实模型会对所有查询并行计算，而不只算这一行。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 07｜多头投影与融合

每个头有独立的Query、Key、Value投影，图中展开第一、第二和第八个头，其他头省略。每个头计算自己的注意力并输出n乘64的张量，再拼接为n乘512，最后通过输出投影融合。内部小矩阵只示意每个头有独立注意力，不是实测分布，也没有预先指定某个头必然负责语法。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 08｜三个配套机制

位置编码与词向量同维相加；正余弦并不是唯一可行选择。右移目标配合下三角掩码，保证目标位置不能读取未来答案。原文每个子层后执行残差相加再LayerNorm，即Post-LN；前馈网络对位置共享参数。图中右侧旁路是残差路径，不是另一种注意力。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 09｜创新地图

第一项核心变化是架构骨干：自注意力代替循环或卷积承担序列交互。第二是缩放点积与多头的注意力设计。第三是取消循环后的显式位置编码。这些是机制比较，不意味着所有此前方法都只有一个头。注意力本身、前馈、残差和归一化都不是本文首次发明。每项机制的动机与完整模型的实验收益需要区分。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 10｜核心收益与代价

循环表示中的远位置交互需逐步传递，而全局自注意力允许任意两个可见位置直接联系。Table1给出顺序操作和最长路径从O(n)到O(1)的层类型比较。但标准注意力仍需要计算位置对，存在平方相关成本；完整Transformer还有投影与前馈计算，不能将表中一项当作全部成本，推理也仍然逐词进行。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 11｜监督信号如何进入训练

源序列和右移目标分别进入编码器与解码器。解码器利用目标前缀及编码器提供的Key与Value，输出下一词概率分布。交叉熵同时使用预测分布与真实下一词标签，原文还采用标签平滑。损失反向传播，使用Adam及warm-up学习率更新全部可学习参数，回路只示意参数更新，不是仅更新嵌入。训练可以用已知目标并行计算位置，推理没有未来真值，仍需逐词生成。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 12｜整体质量与成本实验

这是将Table2英德结果重新绘成散点图，横轴采用对数尺度，单位是10的18次方FLOPs，纵轴为BLEU。Transformer big为28.4，较ConvS2S集成的26.36高2.04，训练成本23除以77约为0.30。base成本更低而质量仍很强。图中只展示选取的模型，不能推出所有任务都优于其他架构；跨论文成本来自估算，也不是统一硬件实现的严格速度对比。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 13｜如何解读模型变体证据

单头开发集24.9，八头25.8，三十二头25.4，说明头数不是越多越好；改变头数时也调整了键和值维度，不能把它当作完全固定其余变量的单因素实验。右侧正余弦25.8与学习式25.7接近，也没有误差条或显著性检验证据支持强结论。图中没有编造误差条。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 14｜总结

研究问题、方法与证据形成闭环。作者针对顺序依赖和信息路径提出设计，以自注意力为骨干并组织多头、位置编码和标准子层，再用翻译结果和变体实验验证。在认可收益的同时，仍需保留全局注意力平方开销与自回归推理这两个边界。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 15｜参考文献与版本

所有结果使用NIPS2017会议版PDF，没有与当前arXiv版本混用。架构图与计算图依据原文重绘，矩阵属于示意，数据图严格使用原文表格。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf
