# Transformer 第一次组会汇报｜15页黑体精简版

共15页，含目录与参考文献。全部页面白底，PPT字体指定为黑体（SimHei）。

PDF预览使用本机兼容黑体渲染；在PowerPoint中打开时请确保系统安装黑体。

结构：背景与问题 → 架构原理 → 创新对比与实现 → 实验与总结。

论文：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 01｜封面

今天汇报Transformer的原始论文。我会先介绍论文的研究背景和已有方法，再解释架构与计算原理，随后重点说明与已有方法相比做了哪些改动、怎样实现，以及实验支持哪些收益。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 02｜目录

先讲已有翻译模型与研究问题，再解释Transformer架构和计算原理，随后比较创新的实现与收益，最后用实验结果和模型变体检验这些说法。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 03｜此前的方法如何工作

机器翻译需要把一种语言序列转换为另一种语言序列。已有循环模型沿位置顺序更新隐藏状态，再用注意力在解码时选择相关源位置。已有卷积模型能并行计算位置特征，但局部卷积需要多层来传递远距离信息。注意力并不是Transformer首次发明的，本文的关键变化是将自注意力放到表示学习的核心，而不是只把它附加在循环或卷积表示之上。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 04｜已有方法的问题

不能把已有方法概括成完全不能捕获长距离信息。更准确的说法是，循环层仍存在沿位置的顺序计算依赖；局部卷积连接远位置时通常需要多层。这些是计算结构上的限制。作者因此希望缩短信息路径、提升并行性，同时保持翻译质量。这里不把表征路径与所有端到端翻译路径混为一谈。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 05｜整体架构

先从底部往上看。源词向量加上位置编码后，进入六层编码器，得到Z。目标输入在训练时右移一位，进入六层解码器；每层先做掩码自注意力，再读取编码器输出。交叉注意力中的K和V来自Z。顶端的线性映射和Softmax给出下一词的分布。框内模块重复六次，嵌入和位置编码不跟着重复。图示省略了残差与层归一化，稍后会补充。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 06｜注意力如何计算

在自注意力中，Q、K、V来自同一序列X的不同可学习线性变换。Q乘K转置得到位置之间的匹配分数，除以根号dk，再对每行做Softmax得到权重，最后乘V完成信息汇总。对于一个查询，结果是多个位置Value的加权组合。末行WQ等符号表示不同投影矩阵，并不是将字母Q直接与X相乘。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 07｜多头注意力的计算过程

每个头有独立的投影矩阵，在自己的表示子空间中计算注意力。各头输出拼接后，再通过输出投影融合。base配置八个头，每个头的键和值维度均为64，所以拼接后回到512维。不是八个头都计算完整的512维，也不是人为指定某个头一定负责语法。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 08｜关键架构细节

这里把三项配套机制集中说明。位置编码与词向量同维，逐元素相加，为注意力提供顺序信息。解码器训练输入右移，并用下三角掩码避免读取未来目标，推理仍需逐词生成。每个子层之后采用残差相加再LayerNorm，前馈网络对各位置共享参数，base的维度是512到2048再回到512。这些机制已在前面的整体架构图中定位，不再分别扩展成独立页面。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 09｜创新总览

第一层面的核心创新是架构：自注意力替代循环或卷积作为序列交互骨干。第二是注意力的具体设计：缩放点积与多头。第三是位置编码这一配套设计，保证取消循环后仍有顺序信息。表中的单次注意力和未缩放点积是机制比较对象，不能理解为所有旧模型都只有一个头或完全相同。注意力本身、前馈网络、残差和归一化都不是本文首次发明。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 10｜架构创新的前后对比

对比对象是同一序列内部的表示计算。循环层中的远距离信息要逐步传递，而全局自注意力在一层中允许任意两个可见位置直接联系。Table1因此给出顺序操作与最大路径的差异。实现上是批量矩阵乘法，并不是把所有计算成本都消除了。完整Transformer还有投影和前馈计算，标准注意力本身还有n平方相关开销。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 11｜如何实现完整模型

从实现角度，首先对输入做词嵌入和位置编码，再堆叠编码器。训练目标序列右移一位后进入解码器，下三角掩码保证不能读取未来答案，交叉注意力读取编码器输出。顶层输出词概率，用含标签平滑的交叉熵训练，通过Adam和warm-up学习率计划更新参数。这里列base参数。推理时没有完整目标真值，必须依次使用已生成的词。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 12｜实验设置与主要结果

主要结果来自WMT2014英德翻译测试集。数据约450万句对，硬件为八张P100。原文还有英法实验，但这页只展示一组结果，避免混用不同任务和版本。base约训练12小时，big约3.5天。big的BLEU为28.4，相比ConvS2S集成的26.36高2.04；估算训练FLOPs比值约0.30。BLEU不是准确率百分比；跨论文成本是估算比较，并非统一环境的严格速度实验。这些是整体架构证据，不能声称每个设计都获得独立收益证明。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 13｜模型变体说明什么

本页使用开发集结果，不能与上一页的测试集BLEU直接混用。八头为25.8，单头24.9，三十二头25.4。改变头数时，每头维度也随之调整，因此不是在完全固定所有变量下单独改变头数。正余弦位置编码25.8，学习式25.7，说明后者也是可行选择，而不是正余弦有显著优势。这些边界是理解创新收益时必须保留的。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 14｜总结

最后回到开头的问题。之前的强模型已经使用注意力，但表示交互主要依赖循环或卷积。本文把自注意力变成架构骨干，配合多头、位置编码、前馈和残差归一化，得到完整Transformer。收益体现在并行结构、信息路径和翻译实验。限制也很清楚：标准全局注意力有平方成本，原始解码器推理仍是自回归。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf

## 15｜参考文献

所有实验数字使用会议版PDF，未混用当前arXiv版本中不同的英法结果。已有方法的比较按原文背景和参考文献概括，不把其他论文作为第二篇汇报对象。

来源：https://proceedings.neurips.cc/paper_files/paper/2017/file/3f5ee243547dee91fbd053c1c4a845aa-Paper.pdf
